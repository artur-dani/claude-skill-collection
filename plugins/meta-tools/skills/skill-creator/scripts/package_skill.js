#!/usr/bin/env node
/**
 * Skill Packager - Creates a distributable zip file of a skill folder
 *
 * Usage:
 *    node utils/package_skill.js <path/to/skill-folder> [output-directory]
 *
 * Example:
 *    node utils/package_skill.js skills/public/my-skill
 *    node utils/package_skill.js skills/public/my-skill ./dist
 */

const fs = require('fs');
const path = require('path');
const archiver = require('archiver');

// Try to import the validator. 
// Assumes quick_validate.js exists and exports a validateSkill function.
let validateSkill;
try {
    // We try to require from the same directory as this script
    const validatorModule = require('./quick_validate');
    validateSkill = validatorModule.validateSkill;
} catch (e) {
    console.warn("⚠️  Warning: quick_validate.js not found or invalid. Skipping validation step.");
}

async function packageSkill(skillPathStr, outputDirStr = null) {
    /**
     * Package a skill folder into a zip file.
     */
    
    const skillPath = path.resolve(skillPathStr);

    // Validate skill folder exists
    if (!fs.existsSync(skillPath)) {
        console.error(`❌ Error: Skill folder not found: ${skillPath}`);
        return null;
    }

    const stats = fs.statSync(skillPath);
    if (!stats.isDirectory()) {
        console.error(`❌ Error: Path is not a directory: ${skillPath}`);
        return null;
    }

    // Validate SKILL.md exists
    const skillMdPath = path.join(skillPath, "SKILL.md");
    if (!fs.existsSync(skillMdPath)) {
        console.error(`❌ Error: SKILL.md not found in ${skillPath}`);
        return null;
    }

    // Run validation before packaging
    if (validateSkill) {
        console.log("🔍 Validating skill...");
        try {
            // Assumes validateSkill returns { valid: boolean, message: string }
            // or [boolean, string] depending on how you converted the Python script.
            // Here assuming object return for cleaner JS: { valid, message }
            const result = await validateSkill(skillPath);
            
            // Handle Python-style tuple return if converted literally [bool, msg]
            const isValid = Array.isArray(result) ? result[0] : result.valid;
            const message = Array.isArray(result) ? result[1] : result.message;

            if (!isValid) {
                console.error(`❌ Validation failed: ${message}`);
                console.error("   Please fix the validation errors before packaging.");
                return null;
            }
            console.log(`✅ ${message}\n`);
        } catch (err) {
            console.error(`❌ Error running validation: ${err.message}`);
            return null;
        }
    }

    // Determine output location
    const skillName = path.basename(skillPath);
    let outputPath;

    if (outputDirStr) {
        outputPath = path.resolve(outputDirStr);
        if (!fs.existsSync(outputPath)) {
            fs.mkdirSync(outputPath, { recursive: true });
        }
    } else {
        outputPath = process.cwd();
    }

    const zipFilename = path.join(outputPath, `${skillName}.zip`);

    // Create the zip file
    return new Promise((resolve, reject) => {
        const output = fs.createWriteStream(zipFilename);
        const archive = archiver('zip', {
            zlib: { level: 9 } // Sets the compression level.
        });

        output.on('close', function() {
            console.log(`\n✅ Successfully packaged skill to: ${zipFilename}`);
            resolve(zipFilename);
        });

        archive.on('error', function(err) {
            console.error(`❌ Error creating zip file: ${err.message}`);
            resolve(null);
        });

        archive.pipe(output);

        // This effectively does: arcname = file_path.relative_to(skill_path.parent)
        // It takes the content of 'skillPath' and puts it into a folder named 'skillName' inside the zip
        archive.directory(skillPath, skillName);

        // To mimic the Python script logging every file added:
        archive.on('entry', (entry) => {
            console.log(`  Added: ${entry.name}`);
        });

        archive.finalize();
    });
}

async function main() {
    const args = process.argv.slice(2);

    if (args.length < 1) {
        console.log("Usage: node utils/package_skill.js <path/to/skill-folder> [output-directory]");
        console.log("\nExample:");
        console.log("  node utils/package_skill.js skills/public/my-skill");
        console.log("  node utils/package_skill.js skills/public/my-skill ./dist");
        process.exit(1);
    }

    const skillPath = args[0];
    const outputDir = args.length > 1 ? args[1] : null;

    console.log(`📦 Packaging skill: ${skillPath}`);
    if (outputDir) {
        console.log(`   Output directory: ${outputDir}`);
    }
    console.log();

    const result = await packageSkill(skillPath, outputDir);

    if (result) {
        process.exit(0);
    } else {
        process.exit(1);
    }
}

// Execute main
if (require.main === module) {
    main();
}