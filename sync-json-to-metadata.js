const fs = require("fs");
const path = require("path");

// Input/Output paths
const jsonFile = path.join(process.cwd(), "files", "my_record.json");
const metadataFile = path.join(__dirname, "../force-app/main/default/customMetadata/AAA_Settings.Bundling_JSON.md-meta.xml");
const jsonData = JSON.parse(fs.readFileSync(jsonFile, "utf8"));

let jsonString = JSON.stringify(jsonData, null, 2); // Pretty-print with indentation

// Escape special XML characters
function escapeXml(unsafe) {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&apos;");
}

jsonString = escapeXml(jsonString);

// Convert JSON to Metadata XML
const xmlContent = `<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Bundling JSON</label>
    <protected>false</protected>
    <values>
        <field>Json_Value__c</field>
        <value xsi:type="xsd:string">${jsonString}</value>
    </values>
    <values>
        <field>Value__c</field>
        <value xsi:type="xsd:string">Bundling</value>
    </values>
</CustomMetadata>`;

// Write output
fs.writeFileSync('force-app/main/default/customMetadata/AAA_Settings.Bundling_JSON.md-meta.xml', xmlContent, "utf8");
