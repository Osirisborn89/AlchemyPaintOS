# HANDOVER

## What this project is
Paint OS / PProject is a CSV-driven paint recipe system for Warhammer factions and surfaces, anchored by reference links in targets.md and enforced by inventory validation.

## Repo structure (canonical)
- data/recipes/recipes.csv (recipe metadata)
- data/recipes/recipe_steps.csv (ordered paint steps)
- data/inventory/inventory_export.csv (owned paints; Brand + Paint Name)
- references/**/TARGETS/targets.md (research anchors; must contain at least one URL)
- docs/ (project brain)
- backups/ (snapshots)
- exports/ (reports)

## Guardrails (must stay green)
- No blank recipe_id rows
- No orphan steps (step recipe_id must exist in recipes.csv)
- No recipes with zero steps
- No duplicate step_no per recipe_id
- Non-Generic paints must exist in inventory_export.csv
- targets.md must exist for every reference_folder used, and must contain a URL

## Current repo health (live)
- Recipes: 401; Steps: 1741; Factions: 39
- Orphan steps: 0; Recipes with no steps: 0; Duplicate step groups: 0
- Placeholder recipes: 0; Placeholder steps: 0
- targets.md missing: 0; targets.md no links: 0
- Verdict: AUDIT PASS (Core + Truth Pass gates)

## What was done most recently
- Truth Pass v2 placeholder cleanup completed across remaining factions.
- Repo dedupe performed earlier (nested data/data, docs/docs, references/references removed/quarantined).

## Next recommended work
- Phase B: tighten each faction surface recipe against official/curated references (targets.md), still using owned inventory only.
- Keep guardrails green after every micro-batch.

