class LoreDataLoader {
  constructor() {
    this.factions = [];
  }

  async loadFactions(csvData) {
    try {
      const lines = csvData.trim().split(String.fromCharCode(10));
      if (lines.length < 2) return false;

      const headers = this.parseCSVLine(lines[0]);
      const factionIdx = headers.indexOf("faction");
      const loreIdx = headers.indexOf("lore_md");
      const themesIdx = headers.indexOf("key_themes");

      if (factionIdx === -1 || loreIdx === -1) {
        console.error("Missing columns");
        return false;
      }

      for (let i = 1; i < lines.length; i++) {
        const fields = this.parseCSVLine(lines[i]);
        const factionName = fields[factionIdx] ? fields[factionIdx].trim() : "";
        
        if (!factionName || factionName.startsWith("#") || factionName === "") {
          continue;
        }

        this.factions.push({
          faction: factionName,
          lore_md: fields[loreIdx] ? fields[loreIdx].trim() : "",
          key_themes: fields[themesIdx] ? fields[themesIdx].trim() : ""
        });
      }

      console.log("Loaded " + this.factions.length + " factions");
      return true;
    } catch (error) {
      console.error("Parse error:", error);
      return false;
    }
  }

  parseCSVLine(line) {
    const result = [];
    let current = "";
    let insideQuotes = false;

    for (let i = 0; i < line.length; i++) {
      const char = line[i];
      const nextChar = line[i + 1];

      if (char === String.fromCharCode(34)) {
        if (insideQuotes && nextChar === String.fromCharCode(34)) {
          current += String.fromCharCode(34);
          i++;
        } else {
          insideQuotes = !insideQuotes;
        }
      } else if (char === "," && !insideQuotes) {
        result.push(current);
        current = "";
      } else {
        current += char;
      }
    }

    result.push(current);
    return result.map(field => field.replace(/^"|"$/g, ""));
  }

  getFactionByName(name) {
    return this.factions.find(f => f.faction === name);
  }

  getAllFactions() {
    return this.factions;
  }
}
