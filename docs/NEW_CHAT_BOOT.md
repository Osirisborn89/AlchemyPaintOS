# NEW CHAT — START HERE

This repo is the **single source of truth**. Do not rely on chat history.

## Step 0 — Confirm working directory
Run in PowerShell:
- cd "C:\Users\day_8\Desktop\Pproject"
- Confirm you can see: data\recipes\recipes.csv and data\recipes\recipe_steps.csv

## What this project is
PaintOS / PProject = a recipe-based paint system for armies/factions.
Each faction has recipes by surface (Armour, Metals, Lenses, etc).
Truth Pass v2 goal: convert any placeholders to final, reference-aligned paint steps using owned paints (inventory enforced).

## Current status snapshot
Read: docs/HANDOVER.md

## Mandatory workflow guardrails
- Snapshot before edits (backups/)
- Micro-batches (one faction or smaller)
- Audit after each batch
- Keep health checks green: no orphans, no dup step groups, no TBD rows, no inventory misses.

## Next action
Resume at: docs/HANDOVER.md → “Next work (resume from here)”
