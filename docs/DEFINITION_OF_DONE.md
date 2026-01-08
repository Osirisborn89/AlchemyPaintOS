# Definition of Done (Recipes vs Placeholders)

This file prevents ambiguity.

## DONE (Recipe)
A recipe is DONE when ALL are true:

### In recipes.csv
- style does NOT contain: "Starter Pack"
- look_summary does NOT contain: "placeholder" / "Phase B" / "TBD"

### In recipe_steps.csv (for that recipe_id)
- No step paint contains "TBD"
- No blank brand/paint for non-Generic rows
- No duplicate step_no within recipe_id
- Steps form a sensible flow:
  Prime -> Base -> Shade/Wash -> Layer -> Highlight/Edge -> Finish/Optional
- Minimum step count guideline:
  - Standard surfaces: 5+ steps
  - Tiny identity recipes (e.g., gems): can be 4 if complete and intentional

## PLACEHOLDER (Recipe)
A recipe is PLACEHOLDER when ANY are true:
- style contains "Starter Pack"
- look_summary contains placeholder/Phase B/TBD markers
- steps contain "TBD"

Placeholders are allowed during Phase A, but must be measurable and intentional.

## DONE (Targets.md)
Targets are part of Phase B and are DONE when:
- Has 1–3 reference links (box art / official / trusted tutorial)
- Has visual notes describing the target look
- Has Date updated
- Optional: named variants and tuning knobs
