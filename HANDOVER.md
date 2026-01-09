\# PaintOS / PProject — Handover Capsule



\*\*Generated:\*\* 2026-01-08 15:46 GMT  

\*\*Repo Path:\*\* C:\\Users\\day\_8\\Desktop\\Pproject  

\*\*PowerShell:\*\* 7.5.4 (no ?? operator)  

\*\*Release Posture:\*\* LOCAL REPO IS TRUTH SOURCE



---



\## 🎯 Current Health Status (Must Stay GREEN)



| Metric | Status | Value |

|--------|--------|-------|

| \*\*Recipes\*\* | ✅ | 401 |

| \*\*Recipe Steps\*\* | ✅ | 1,741 |

| \*\*Factions\*\* | ✅ | 39 |

| \*\*Orphan Steps\*\* | ✅ | 0 |

| \*\*Recipes with No Steps\*\* | ✅ | 0 |

| \*\*Duplicate Step Groups\*\* | ✅ | 0 |

| \*\*TBD Rows\*\* | ✅ | 0 |

| \*\*Blank Brand/Paint (non-Generic)\*\* | ✅ | 0 |

| \*\*RecipeIds Used by Multiple Factions\*\* | ✅ | 0 |



---



\## ✅ Truth Pass v2 Quality Gates (CURRENT)



| Gate | Status | Value |

|------|--------|-------|

| \*\*Placeholder Recipes Remaining\*\* | ✅ | 0 |

| \*\*Placeholder Steps Remaining\*\* | ✅ | 0 |

| \*\*Steps with Paints NOT in Inventory (non-Generic)\*\* | ✅ | 0 |

| \*\*Missing targets.md (used by recipes)\*\* | ✅ | 0 |

| \*\*targets.md with NO links\*\* | ✅ | 0 |

| \*\*Audit Status\*\* | ✅ PASS | Core + Truth Pass gates green |



---



\## 📋 What We Are Doing



\### Truth Pass v2 Mission



Align each faction's recipes to \*\*official/curated reference schemes\*\* using \*\*only owned paints\*\* (inventory enforced).



\*\*Key Rules:\*\*

\- ✅ "Generic" allowed only for material-type steps (texture paste, etc.)

\- ✅ Non-Generic paint MUST be in `inventory\_export.csv`

\- ✅ Every surface should be research-anchored via `targets.md`

\- ✅ Inventory columns: Brand='Brand', Paint='Paint Name'



\### Big Milestone Reached ✅



\*\*Truth Pass v2 placeholder cleanup is COMPLETE\*\*



All remaining Starter Pack / placeholder recipes and placeholder step text have been \*\*eliminated\*\*.  

Quality gates are \*\*green across the full dataset\*\*.



---



\## ✅ Completed Work (This Run)



\### Early Batches (Confirmed Completed)



\- ✅ \*\*Adepta Sororitas\*\* — full Truth Pass v2 rewrite + targets patched

\- ✅ \*\*Adeptus Custodes\*\* — full Truth Pass v2 rewrite + polish + targets patched

\- ✅ \*\*Adeptus Mechanicus\*\* — full Truth Pass v2 rewrite + polish + targets patched

\- ✅ \*\*Aeldari\*\* — rewritten + metadata aligned to Truth Pass v2; targets patched

\- ✅ \*\*Aeldari (Blue/Purple)\*\* — glow fixes; targets OK

\- ✅ \*\*Asuryani\*\* — full Truth Pass v2 rewrite + targets patched

\- ✅ \*\*Black Templars\*\* — glow fixed; targets OK

\- ✅ \*\*Blood Angels\*\* — glow fixed; targets OK

\- ✅ \*\*Chaos Daemons\*\* — full Truth Pass v2 rewrite + targets patched

\- ✅ \*\*Chaos Knights\*\* — Truth Pass v2 rewrite + targets OK



\### Later Batches (Completed After Initial Snapshot)



\- ✅ \*\*Imperial Knights\*\* — full rewrite fixed (all IK recipe\_ids at 4 steps; gates green)

\- ✅ \*\*Iron Hands\*\* — full rewrite (all IH recipe\_ids at 4 steps; gates green)

\- ✅ \*\*Leagues of Votann\*\* — full rewrite (all LOV recipe\_ids at 4 steps; gates green)

\- ✅ \*\*Orks\*\* — rewrite (incl. "Checks \& Markings" handled; gates green)

\- ✅ \*\*Raven Guard\*\* — full rewrite applied (all RG recipe\_ids at 4 steps; gates green)

\- ✅ \*\*Salamanders\*\* — full rewrite applied (all SAL recipe\_ids at 4 steps; gates green)

\- ✅ \*\*Space Wolves\*\* — Lenses \& Glow placeholder fixed to Truth Pass v2 (SW\_LENSESGLOW\_MIX\_01)

\- ✅ \*\*T'au Empire\*\* — rewrite completed (targets patched; scheme = sept-style ochre + white + teal/green glow)

\- ✅ \*\*Thousand Sons\*\* — full rewrite completed (all TS recipe\_ids at 4 steps)

\- ✅ \*\*Tyranids\*\* — full rewrite completed (all TYR recipe\_ids at 4 steps)

\- ✅ \*\*Ultramarines\*\* — full rewrite completed (all UM recipe\_ids at 4 steps)

\- ✅ \*\*White Scars\*\* — full rewrite completed (all WS recipe\_ids at 4 steps)

\- ✅ \*\*Imperial Agents\*\* — placeholder metadata cleaned (look\_summary updated; placeholder count now 0)

\- ✅ \*\*Ynnari\*\* — completed \*(this was the final remaining placeholder set; counters hit 0/0)\*



\*\*Total Factions Processed:\*\* 39 | \*\*Total Recipes:\*\* 401 | \*\*Total Steps:\*\* 1,741



---



\## 🔧 Repo Hygiene / Incident Log



\### Nested Folder Dupes Fixed ✅



\*\*Detected and Removed:\*\*

\- ✅ `data\\data` — removed, canonical verified

\- ✅ `docs\\docs` — removed, canonical verified

\- ✅ `references\\references` — removed, canonical verified



\*\*Approach:\*\*

1\. Quarantine/move dupes out of the way (timestamped quarantine path)

2\. Verify canonical paths remain intact

3\. Diff scan confirmed many mismatches (quarantined copies were older than canonical — expected)

4\. \*\*Current state:\*\* Canonical folder layout is clean (no nested dupes) ✅



\*\*Project is safe to continue.\*\*



---



\## 🚀 Next Work (Resume From Here)



\### Phase: Frontend Build



Now that Truth Pass v2 placeholder cleanup is finished, \*\*transition from "data rescue" to "product build"\*\*.



\*\*Goal:\*\* Turn the dataset into a usable local dashboard



\*\*MVP Features:\*\*

\- Faction picker → surface picker → step view (brand/paint/method notes)

\- Show `targets.md` links per surface (research transparency)

\- Search by paint / recipe\_id

\- Optional: "What can I paint with X paint?" reverse lookup



\*\*Tech Stack (Recommended):\*\*

\- Single HTML file with embedded CSS/JS

\- Load from CSV (no backend needed initially)

\- Responsive design (mobile, tablet, desktop)

\- Real-time search \& filtering



---



\### Phase: B Accuracy Pass (Later)



Even though placeholders are gone, do a \*\*later scheme accuracy review\*\* (box art faithfulness) faction-by-faction:



\- ✅ Keep `targets.md` as the compass

\- ✅ Adjust recipes only when research warrants it

\- ✅ Maintain green gates

\- \*\*Timing:\*\* After frontend MVP is live



---



\### Ongoing: Documentation Polish



Keep docs in sync with reality:



\- \[ ] HANDOVER.md reflects "placeholders = 0" ✅

\- \[ ] MILESTONES.md marks Truth Pass v2 placeholder cleanup complete ✅

\- \[ ] STATUS.md updated with current numbers + next phase ✅

\- \[ ] VERSION.txt reflects v1.0.0 ✅



---



\## 📖 New Chat Bootstrap



\### When Starting Fresh in a New Chat:



1\. \*\*Upload repo zip\*\*

2\. \*\*Tell assistant:\*\*

"Read docs/HANDOVER.md first. Confirm audit gates are green.

Then resume at NEXT WORK."



text

3\. \*\*Run audit:\*\*

```powershell

\# Quick health check

$recipes = (Import-Csv "data/recipes/recipes.csv").Count

$steps = (Import-Csv "data/recipes/recipe\_steps.csv").Count

$factions = (Import-Csv "data/recipes/recipes.csv").faction | Select-Object -Unique | Measure-Object | Select-Object -ExpandProperty Count



Write-Host "Recipes: $recipes"

Write-Host "Steps: $steps"

Write-Host "Factions: $factions"

Paste output and continue



🔐 Pinned Context — PaintOS Project Charter

What This Project Is

PaintOS is a local, home-network dashboard/OS that helps you paint Warhammer factions/armies using only the paints you own.



What The Repo Contains

Inventory CSV — data/inventory/inventory\_export.csv (single source of truth for owned paints)



Recipes \& Steps — data/recipes/recipes.csv, data/recipes/recipe\_steps.csv (backend data for future dashboard)



Research Anchors — references/\*\*/TARGETS/targets.md (per faction/surface, research trail)



End Goal Dashboard Behavior

Select a faction → returns surface-specific recipes + steps



Schemes must be faithful to official/curated references (box art / studio schemes)



Paint choices must use owned paints only (brands can mix)



"Nearest match" means nearest from owned inventory, never recommend a paint you don't own



Non-Negotiable Rules

Inventory CSV is truth — no non-Generic paints outside inventory



Every faction update must be research-anchored — targets.md links first



Micro-batches — snapshot → targets patch → rewrite → audit → stop



Quality gates must stay green — the full list at top of this doc



📊 Current Status Summary

Item	Status

Truth Pass v2 (Placeholder Cleanup)	✅ COMPLETE

Data Audit Gates	✅ GREEN

Repo Hygiene	✅ CLEAN

Documentation	✅ UPDATED

Next Phase	🚀 Frontend Build

Release Status	📦 LOCAL (v1.0.0)

🎯 Quick Reference

Key Files

data/recipes/recipes.csv — All 401 recipes



data/recipes/recipe\_steps.csv — All 1,741 steps



data/inventory/inventory\_export.csv — Owned paints (source of truth)



references/\*\*/TARGETS/targets.md — Research anchors (321 files)



Key Metrics

Factions: 39



Recipes: 401



Steps: 1,741



Paints: 315+



targets.md: 321 (all anchored)



Quality Gates

Placeholders: 0 ✅



Orphans: 0 ✅



Duplicates: 0 ✅



Audit: GREEN ✅



📝 Notes For Future Self

Placeholders are done — focus shifts to frontend + accuracy



Don't add paints to recipes without inventory check — gates will catch it



targets.md is gospel — if recipe disagrees with targets, check targets first



Micro-batches work — snapshot→patch→rewrite→audit creates good diffs



Quality gates are your friend — green gates = safe to push



Last Updated: January 8, 2026, 15:46 GMT

Prepared by: Osirisborn89

Status: READY FOR NEXT PHASE ✅



For the Emperor! ⚔️🌟

