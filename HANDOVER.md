PaintOS / PProject — Handover Capsule

Generated: 20260107\_1700

Repo path (local): C:\\Users\\day\_8\\Desktop\\Pproject

PowerShell: 7.5.4 (no ?? operator)

Release posture: UNRELEASED (local repo is truth source)



Current Health (must stay green)



Recipes: 401

Steps: 1741

Factions: 39



Orphan steps: 0

Recipes with no steps: 0

Duplicate step groups: 0

TBD rows: 0

Blank brand/paint (non-Generic): 0

RecipeIds used by multiple factions: 0



Truth Pass v2 Quality Gates (current)



Placeholder recipes remaining: 0

Placeholder steps remaining: 0

Inventory columns: Brand='Brand' Paint='Paint Name'

Steps with paints NOT in inventory (non-Generic): 0

Missing targets.md (used by recipes): 0

targets.md with NO links: 0



✅ AUDIT PASS (Core + Truth Pass gates)



What we are doing



Truth Pass v2 = align each faction’s recipes to official/curated reference schemes using only owned paints (inventory enforced).



“Generic” is allowed only for material-type steps where it makes sense (e.g., texture paste).



Non-Generic paint must always be in inventory\_export.csv.



Every surface should be research-anchored via targets.md.



Big milestone reached

✅ Truth Pass v2 placeholder cleanup is COMPLETE



All remaining Starter Pack / placeholder recipes and placeholder step text have been eliminated.

Quality gates are green across the full dataset.



Completed in this run (confirmed by outputs during this chat)



(High confidence: written to CSV + post-write health checks / counters confirmed)



Early batches (previously completed in this run):



Adepta Sororitas — full Truth Pass v2 rewrite + targets patched



Adeptus Custodes — full Truth Pass v2 rewrite + polish + targets patched



Adeptus Mechanicus — full Truth Pass v2 rewrite + polish + targets patched



Aeldari — rewritten + metadata aligned to Truth Pass v2; targets patched



Aeldari (Blue/Purple variants) — glow fixes; targets OK



Asuryani — full Truth Pass v2 rewrite + targets patched



Black Templars — glow fixed; targets OK



Blood Angels — glow fixed; targets OK



Chaos Daemons — full Truth Pass v2 rewrite + targets patched



Chaos Knights — Truth Pass v2 rewrite + targets OK



Later batches (completed after that handover snapshot):



Imperial Knights — full rewrite fixed (all IK recipe\_ids at 4 steps; gates green)



Iron Hands — full rewrite (all IH recipe\_ids at 4 steps; gates green)



Leagues of Votann — full rewrite (all LOV recipe\_ids at 4 steps; gates green)



Orks — rewrite (incl. “Checks \& Markings” handled; gates green)



Raven Guard — full rewrite successfully applied (all RG recipe\_ids at 4 steps; gates green)



Salamanders — full rewrite successfully applied (all SAL recipe\_ids at 4 steps; gates green)



Space Wolves — Lenses \& Glow placeholder fixed to Truth Pass v2 (SW\_LENSESGLOW\_MIX\_01)



T’au Empire — rewrite completed (targets patched; scheme = sept-style ochre + white + teal/green glow)



Thousand Sons — full rewrite completed (all TS recipe\_ids at 4 steps)



Tyranids — full rewrite completed (all TYR recipe\_ids at 4 steps)



Ultramarines — full rewrite completed (all UM recipe\_ids at 4 steps)



White Scars — full rewrite completed (all WS recipe\_ids at 4 steps)



Imperial Agents — placeholder metadata cleaned (look\_summary updated; placeholder count now 0)



Ynnari — completed (this was the final remaining placeholder set; counters hit 0/0)



Repo hygiene / incident log (important)

✅ Nested folder dupes fixed



Detected and removed nested duplicates:



data\\data



docs\\docs



references\\references



Approach used:



Quarantine/move dupes out of the way (timestamped quarantine path), then verify canonical paths remain.



A diff scan showed many mismatches because quarantined copies were older than canonical (expected).



Current state: canonical folder layout is clean (no nested dupes) and project is safe to continue.



Next work (resume from here)



Now that Truth Pass v2 placeholder cleanup is finished, the project transitions from “data rescue” to “product build.”



1\) Front end build (next major phase)



Goal: turn the dataset into a usable local dashboard:



Faction picker → surface picker → step view (brand/paint/method notes)



Show targets.md links per surface (research transparency)



Search by paint / recipe\_id



Optional: “What can I paint with X paint?” reverse lookup



2\) Phase B accuracy pass (quality, not placeholders)



Even though placeholders are gone, we still do a later scheme accuracy review (box art faithfulness) faction-by-faction:



Keep targets.md as the compass



Adjust recipes only when research warrants it



Maintain green gates



3\) Documentation polish



Ensure docs match reality:



HANDOVER.md reflects “placeholders = 0”



MILESTONES.md marks Truth Pass v2 placeholder cleanup complete



STATUS.md updated with current numbers + next phase (“Frontend”)



“New Chat Bootstrap”



When starting a fresh chat:



Upload the repo zip.



Tell the assistant: “Read docs/NEW\_CHAT\_BOOT.md and docs/HANDOVER.md first. Confirm audit gates are green. Then resume at NEXT WORK.”



Run the audit and paste output.



PINNED CONTEXT

PPaintOS — Project Charter (Pinned Context)

What this project is



PPaintOS is a local, home-network dashboard/OS that helps Day paint Warhammer factions/armies using only the paints Day owns.



The repo contains:



Inventory CSV exported from PaintRack: data/inventory/inventory\_export.csv (single source of truth for owned paints)



Recipes and steps: data/recipes/recipes.csv, data/recipes/recipe\_steps.csv (backend data future dashboard will use)



Research anchors per faction/surface: references/\*\*/TARGETS/targets.md



End goal dashboard behavior



Select a faction → returns surface-specific recipes + steps



Schemes must be faithful to official/curated references (box art / studio)



Paint choices must use owned paints only (brands can mix)



“Nearest match” means nearest from owned inventory, never “recommend a paint you don’t own”



Non-negotiable rules



Inventory CSV is truth (no non-Generic paints outside inventory)



Every faction update must be research-anchored (targets.md links first)



Micro-batches: snapshot → targets patch → rewrite → audit → stop



Quality gates must stay green (the full list above)



Current workflow (Truth Pass v2)



Truth Pass v2 placeholder cleanup phase is complete.

Next: frontend build + later Phase B accuracy pass.



Status snapshot (current)



Placeholder recipes remaining: 0



Placeholder steps remaining: 0



Next focus: Frontend build + Phase B accuracy review

