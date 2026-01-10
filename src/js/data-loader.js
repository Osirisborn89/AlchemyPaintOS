class DataLoader {
  constructor() {
    this.recipes = [];
    this.recipeSteps = [];
    this.inventory = [];
    this.factions = [];
    this.recipesByFaction = {};
    this.inventoryMap = {};
    this.loaded = false;
    this.cacheBuster = Math.random().toString(36).substr(2, 9);
  }

  parseCSV(csvText) {
    const lines = csvText.trim().split('\n');
    if (lines.length < 2) return [];
    const headers = this.parseCSVLine(lines[0]);
    const rows = [];
    for (let i = 1; i < lines.length; i++) {
      const values = this.parseCSVLine(lines[i]);
      const row = {};
      headers.forEach((header, idx) => {
        row[header.trim()] = values[idx] ? values[idx].trim() : '';
      });
      rows.push(row);
    }
    return rows;
  }

  parseCSVLine(line) {
    const result = [];
    let current = '';
    let insideQuotes = false;
    for (let i = 0; i < line.length; i++) {
      const char = line[i];
      const nextChar = line[i + 1];
      if (char === '"') {
        if (insideQuotes && nextChar === '"') {
          current += '"';
          i++;
        } else {
          insideQuotes = !insideQuotes;
        }
      } else if (char === ',' && !insideQuotes) {
        result.push(current);
        current = '';
      } else {
        current += char;
      }
    }
    result.push(current);
    return result;
  }

  async fetchCSV(filename) {
    const url = `/data/${filename}?cb=${this.cacheBuster}`;
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Failed to load ${filename}: ${response.statusText}`);
    }
    return await response.text();
  }

  async loadAllData() {
    try {
      const recipesCSV = await this.fetchCSV('recipes.csv');
      const recipeStepsCSV = await this.fetchCSV('recipe_steps.csv');
      const inventoryCSV = await this.fetchCSV('inventory_export.csv');
      const factionsCSV = await this.fetchCSV('factions_lore.csv');
      
      this.recipes = this.parseCSV(recipesCSV);
      this.recipeSteps = this.parseCSV(recipeStepsCSV);
      this.inventory = this.parseCSV(inventoryCSV);
      this.factions = this.parseCSV(factionsCSV);
      this.normalizeData();
      this.buildLookups();
      this.loaded = true;
      console.log(`✓ Data loaded: ${this.recipes.length} recipes, ${this.inventory.length} paints, ${this.factions.length} factions`);
      return true;
    } catch (error) {
      console.error('Data loading failed:', error);
      return false;
    }
  }

  normalizePrimer(paintName) {
    const primerMap = {
      'Rubber Black': 'Black Primer',
      'Anthracite Grey': 'Grey Primer',
      'Corax White': 'White Primer',
      'Smoke Black': 'Black Primer',
      'Bold Titanium White': 'White Primer',
      'Greenish White': 'White Primer',
      'Transparent Black': 'Black Primer',
      'White': 'White Primer',
      'Black': 'Black Primer'
    };
    return primerMap[paintName] || paintName;
  }

  normalizeBrand(brand, stage) {
    if ((stage || '').toLowerCase() === 'prime' && brand === 'AK Interactive') {
      return 'Any';
    }
    return brand;
  }

  capitalize(str) {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
  }

  normalizeData() {
    this.recipes = this.recipes.map(r => ({
      id: r['recipe_id'] || '',
      name: r['look_summary'] || r['recipe_id'] || '',
      faction: (r['faction'] || '').trim(),
      surface: (r['surface'] || '').toLowerCase(),
      difficulty: (r['difficulty'] || '').toLowerCase(),
      timeMode: (r['time_mode'] || '').toLowerCase(),
      finish: (r['finish'] || '').toLowerCase(),
      style: (r['style'] || ''),
      description: r['look_summary'] || ''
    }));

    this.recipeSteps = this.recipeSteps.map(s => {
      const isPrime = (s['stage'] || '').toLowerCase() === 'prime';
      return {
        recipeId: s['recipe_id'] || '',
        stepNumber: parseInt(s['step_no'] || 0),
        stage: (s['stage'] || '').toLowerCase(),
        action: (s['action'] || ''),
        paint: isPrime ? this.normalizePrimer(s['paint'] || '') : (s['paint'] || ''),
        brand: isPrime ? this.normalizeBrand(s['brand'] || '', s['stage']) : (s['brand'] || ''),
        description: s['method_notes'] || ''
      };
    });

    this.inventory = this.inventory.map(p => ({
      id: `${p['Brand']}_${p['Paint Name']}`.replace(/\s+/g, '_'),
      brand: (p['Brand'] || '').trim(),
      name: (p['Paint Name'] || '').trim(),
      type: (p['Type'] || '').toLowerCase(),
      count: parseInt(p['Count'] || 1),
      line: (p['Line'] || '').trim()
    }));

    // Extract unique factions from recipes instead of parsing factions CSV
    const uniqueFactions = {};
    this.recipes.forEach(r => {
      const factionName = (r['faction'] || '').trim();
      if (factionName && !uniqueFactions[factionName]) {
        uniqueFactions[factionName] = true;
      }
    });

    this.factions = Object.keys(uniqueFactions).map(name => ({
      id: name.toLowerCase().replace(/\s+/g, '_'),
      name: name,
      keyThemes: [],
      notableUnits: [],
      lore: ''
    })).sort((a, b) => a.name.localeCompare(b.name));
  }

  buildLookups() {
    this.recipesByFaction = {};
    this.recipes.forEach(recipe => {
      if (!this.recipesByFaction[recipe.faction]) {
        this.recipesByFaction[recipe.faction] = [];
      }
      this.recipesByFaction[recipe.faction].push(recipe);
    });
    this.inventoryMap = {};
    this.inventory.forEach(paint => {
      this.inventoryMap[paint.id] = paint;
    });
  }

  getRecipesByFaction(factionName) {
    return this.recipesByFaction[factionName] || [];
  }

  getRecipeSteps(recipeId) {
    return this.recipeSteps.filter(s => s.recipeId === recipeId);
  }

  getPaint(paintId) {
    return this.inventoryMap[paintId] || null;
  }

  getAllFactions() {
    return this.factions.sort((a, b) => a.name.localeCompare(b.name));
  }

  searchRecipes(query) {
    const q = query.toLowerCase();
    return this.recipes.filter(r => r.name.toLowerCase().includes(q) || r.description.toLowerCase().includes(q));
  }
}
