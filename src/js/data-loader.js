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

  async fetchCSV(filename) {
    const url = `./Data/${filename}?cb=${this.cacheBuster}`;
    console.log(`📥 Fetching: ${url}`);
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`Failed to load ${filename}: ${response.status} ${response.statusText}`);
      }
      const text = await response.text();
      console.log(`✓ Loaded ${filename}: ${text.split('\n').length} lines`);
      return text;
    } catch (error) {
      console.error(`✗ Fetch failed for ${filename}:`, error);
      throw error;
    }
  }

  async loadAllData() {
    try {
      console.log('🎨 Starting data load...');
      const recipesCSV = await this.fetchCSV('recipes.csv');
      const recipeStepsCSV = await this.fetchCSV('recipe_steps.csv');
      
      let inventoryCSV = '';
      try {
        inventoryCSV = await this.fetchCSV('inventory/inventory_export.csv');
      } catch (err) {
        console.log('ℹ Inventory file not found - continuing without it');
        inventoryCSV = 'id,name\n';
      }
      
      const recipesResult = Papa.parse(recipesCSV, { header: true, skipEmptyLines: true });
      const stepsResult = Papa.parse(recipeStepsCSV, { header: true, skipEmptyLines: true });
      const inventoryResult = Papa.parse(inventoryCSV, { header: true, skipEmptyLines: true });
      
      this.recipes = recipesResult.data || [];
      this.recipeSteps = stepsResult.data || [];
      this.inventory = inventoryResult.data || [];
      
      console.log(`📊 Raw data parsed:`);
      console.log(`  - ${this.recipes.length} recipes`);
      console.log(`  - ${this.recipeSteps.length} recipe steps`);
      console.log(`  - ${this.inventory.length} paints`);
      
      this.normalizeData();
      this.buildLookups();
      this.loaded = true;
      
      console.log(`✓ Data loaded successfully:`);
      console.log(`  - ${this.recipes.length} normalized recipes`);
      console.log(`  - ${this.factions.length} factions found`);
      
      return true;
    } catch (error) {
      console.error('✗ Data loading failed:', error);
      throw error;
    }
  }

  capitalize(str) {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
  }

  normalizeData() {
    this.recipes = this.recipes
      .filter(r => r.recipe_id && r.recipe_id.trim())
      .map(r => ({
        id: r.recipe_id || '',
        name: r.look_summary || r.recipe_id || '',
        faction: (r.faction || '').trim(),
        surface: (r.surface || '').toLowerCase(),
        difficulty: (r.difficulty || '').toLowerCase(),
        timeMode: (r.time_mode || '').toLowerCase(),
        finish: (r.finish || '').toLowerCase(),
        style: (r.style || ''),
        description: r.look_summary || ''
      }));

    this.recipeSteps = this.recipeSteps
      .filter(s => s.recipe_id && s.recipe_id.trim())
      .map(s => ({
        recipeId: s.recipe_id || '',
        stepNumber: parseInt(s.step_no || 0),
        stage: (s.stage || '').toLowerCase(),
        action: (s.action || ''),
        paint: (s.paint || ''),
        brand: (s.brand || ''),
        description: s.method_notes || ''
      }));

    const uniqueFactions = {};
    this.recipes.forEach(r => {
      const factionName = (r.faction || '').trim();
      if (factionName && !uniqueFactions[factionName]) {
        uniqueFactions[factionName] = true;
      }
    });

    this.factions = Object.keys(uniqueFactions)
      .map(name => ({
        id: name.toLowerCase().replace(/\s+/g, '_'),
        name: name,
        keyThemes: [],
        notableUnits: [],
        lore: ''
      }))
      .sort((a, b) => a.name.localeCompare(b.name));

    console.log(`✓ Normalized ${this.factions.length} factions:`, this.factions.map(f => f.name));
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
      if (paint.id) {
        this.inventoryMap[paint.id] = paint;
      }
    });
  }

  getAllFactions() {
    return this.factions.sort((a, b) => a.name.localeCompare(b.name));
  }

  getRecipesByFaction(factionName) {
    return this.recipesByFaction[factionName] || [];
  }

  getRecipeSteps(recipeId) {
    return this.recipeSteps.filter(s => s.recipeId === recipeId).sort((a, b) => a.stepNumber - b.stepNumber);
  }

  getPaint(paintId) {
    return this.inventoryMap[paintId] || null;
  }

  searchRecipes(query) {
    const q = query.toLowerCase();
    return this.recipes.filter(r => 
      r.name.toLowerCase().includes(q) || 
      r.description.toLowerCase().includes(q)
    );
  }
}
