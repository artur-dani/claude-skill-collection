#!/usr/bin/env node
/**
 * Quick validation script for skills - minimal version
 */

const fs = require('fs');
const path = require('path');

/**
 * Basic validation of a skill
 * @param {string} skillPathStr 
 * @returns {Promise<{valid: boolean, message: string}>}
 */
async function validateSkill(skillPathStr) {
    const skillPath = path.resolve(skillPathStr);

    // Check SKILL.md exists
    const skillMdPath = path.join(skillPath, 'SKILL.md');
    if (!fs.existsSync(skillMdPath)) {
        return { valid: false, message: "SKILL.md not found" };
    }

    // Read and validate frontmatter
    let content;
    try {
        content = fs.readFileSync(skillMdPath, 'utf8');
    } catch (e) {
        return { valid: false, message: `Could not read SKILL.md: ${e.message}` };
    }

    if (!content.startsWith('---')) {
        return { valid: false, message: "No YAML frontmatter found" };
    }

    // Extract frontmatter
    // In JS regex, [\s\S] matches any character including newlines (equivalent to Python re.DOTALL)
    const match = content.match(/^---\n([\s\S]*?)\n---/);
    if (!match) {
        return { valid: false, message: "Invalid frontmatter format" };
    }

    const frontmatter = match[1];

    // Check required fields
    if (!frontmatter.includes('name:')) {
        return { valid: false, message: "Missing 'name' in frontmatter" };
    }
    if (!frontmatter.includes('description:')) {
        return { valid: false, message: "Missing 'description' in frontmatter" };
    }

    // Extract name for validation
    const nameMatch = frontmatter.match(/name:\s*(.+)/);
    if (nameMatch) {
        const name = nameMatch[1].trim();
        
        // Check naming convention (hyphen-case: lowercase with hyphens)
        // ^[a-z0-9-]+$
        if (!/^[a-z0-9-]+$/.test(name)) {
            return { 
                valid: false, 
                message: `Name '${name}' should be hyphen-case (lowercase letters, digits, and hyphens only)` 
            };
        }

        if (name.startsWith('-') || name.endsWith('-') || name.includes('--')) {
            return { 
                valid: false, 
                message: `Name '${name}' cannot start/end with hyphen or contain consecutive hyphens` 
            };
        }
    }

    // Extract and validate description
    const descMatch = frontmatter.match(/description:\s*(.+)/);
    if (descMatch) {
        const description = descMatch[1].trim();
        // Check for angle brackets
        if (description.includes('<') || description.includes('>')) {
            return { 
                valid: false, 
                message: "Description cannot contain angle brackets (< or >)" 
            };
        }
    }

    return { valid: true, message: "Skill is valid!" };
}

async function main() {
    const args = process.argv.slice(2);
    
    if (args.length !== 1) {
        console.log("Usage: node quick_validate.js <skill_directory>");
        process.exit(1);
    }

    // Note: Python script prints just the message.
    const result = await validateSkill(args[0]);
    console.log(result.message);
    process.exit(result.valid ? 0 : 1);
}

// Execute main if run directly
if (require.main === module) {
    main();
}

// Export for use in other scripts (like package_skill.js)
module.exports = { validateSkill };