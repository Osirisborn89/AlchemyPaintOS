# Guardrails

- Always take a snapshot before edits (backups\SNAPSHOT_*).
- Keep audits green:
  - Duplicate step groups = 0
  - Blank brand/paint (non-Generic) = 0
  - Orphan steps = 0
  - Recipes with no steps = 0
  - TBD rows remaining = 0
  - Missing targets.md (used by recipes) = 0
- PowerShell 7.5.4 only. Avoid the '??' operator.
- When sorting multiple keys in Sort-Object, use hashtable syntax:
  - Sort-Object @{Expression='count'; Descending=$true}, @{Expression='paint'; Descending=$false}
- Generic rows are allowed (you can pick products at paint time).
