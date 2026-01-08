# CHANGELOG

## 2026-01-07
- Docs synced to live repo truth (counts + audit gates).
- Current verdict: AUDIT PASS (Core + Truth Pass gates)

# Paint OS - Changelog

## Unreleased

### Truth Pass v2 progress (20260106_002222)
- Converted multiple factions from Starter Pack placeholders toward final reference-aligned recipes using owned paints.
- Inventory enforcement confirmed: non-Generic steps must map to inventory_export.csv (Brand + Paint Name).
- Health remains green: no orphans, no dup step groups, no TBD rows, no inventory misses.

Completed in this run:
- Adepta Sororitas — full Truth Pass v2 rewrite (9 recipes / 36 steps) + targets patched
- Adeptus Custodes — full Truth Pass v2 rewrite (9/36) + polish pass + targets patched
- Adeptus Mechanicus — full Truth Pass v2 rewrite (7/28) + polish pass + targets patched
- Aeldari — rewritten (8 recipes) + metadata fix to Truth Pass v2; Wraithbone kept as Identity Surface; targets patched
- Aeldari - Blue — glow recipe fixed (AEB_LENSESGLOW_MIX_01); rest already Box Art/Identity; targets OK
- Aeldari - Purple — glow recipe fixed (AEP_LENSESGLOW_MIX_01); rest already Box Art/Identity; targets OK
- Asuryani — full Truth Pass v2 rewrite (9/36) + targets patched
- Black Templars — glow recipe fixed (BT_LENSESGLOW_MIX_01); rest already Box Art/Identity; targets OK
- Blood Angels — glow recipe fixed (BA_LENSESGLOW_MIX_01); rest already Box Art/Identity; targets OK
- Chaos Daemons — full Truth Pass v2 rewrite (7/28) + targets patched
- Chaos Knights — full Truth Pass v2 rewrite applied (8 recipes; removed 24 placeholder steps) + targets OK

Current remaining:
- Placeholder recipes: 193
- Placeholder steps: 609
- Core surface scaffolding parity completed across roster (Bases/Weapons/Details/Glow for all factions)
- Added missing surface recipes + targets.md where needed (collision-safe recipe_id allocation)
- Dataset remains audit-green (0 orphans / 0 no-steps / 0 dup groups / 0 TBD / 0 missing targets used)
- Current totals: Factions 39, Recipes 401, Steps 1741
- Next: Truth Pass v2 (box-art/official compass + owned-paint recipe rewrite), one army at a time
## 0.1.1 - 2026-01-05
- Final Standard v1 achieved across current roster (data audit green)
- Cleared all TBD rows in recipe steps (TBD remaining: 0)
- Resolved orphan steps (Orphan steps: 0)
- Enforced no duplicate step groups (Duplicate step groups: 0)
- Ensured every recipe has steps (Recipes with no steps: 0)
- Ensured all used reference folders have targets.md (Missing targets.md (used): 0)
- Anchored targets.md across references (Targets anchored: 321 / 321)
- Inventory swap pass completed; remaining Generic rows allowed by design (22)

## Unreleased
- Core surface scaffolding parity completed across roster (Bases/Weapons/Details/Glow for all factions)
- Added missing surface recipes + targets.md where needed (collision-safe recipe_id allocation)
- Dataset remains audit-green (0 orphans / 0 no-steps / 0 dup groups / 0 TBD / 0 missing targets used)
- Current totals: Factions 39, Recipes 401, Steps 1741
- Next: Truth Pass v2 (box-art/official compass + owned-paint recipe rewrite), one army at a time
## 0.1.0 - 2026-01-04
- Project scaffold created (folders + recipe CSV templates)

<!-- AUTO:CHANGELOG -->
Last updated: 2026-01-07

## Unreleased
- Docs refreshed from live repo stats (auto blocks).
- Repo hygiene confirmed (no nested duplicates under data/docs/references).

## 0.1.1 (current)
- Truth Pass v2 progressed to placeholders cleared (recipes/steps now 0/0).
- targets.md coverage maintained (missing: 0, no-link: 0).
<!-- /AUTO:CHANGELOG -->


