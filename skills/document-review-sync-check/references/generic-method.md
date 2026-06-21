# Generic Document Review Method

## Purpose

Use this method to determine whether a target document remains synchronized with its related documents, JSON/config sources, and real repository files/assets.

## Three-Layer Review

### L1 — Reference Existence
Check whether referenced files, directories, and anchors still exist.

### L2 — Parameter / Content Consistency
Check whether fields, values, enum definitions, naming conventions, examples, and declared responsibilities still match.

### L3 — Reverse Propagation
Check whether upstream changes have propagated to all downstream documents, JSON files, configs, and assets.

## Recommended Workflow

1. Identify authority sources
2. Inspect document header metadata
3. Run L1 reference checks
4. Run L2 field/value consistency checks
5. Run L3 reverse-propagation checks
6. Compare against real filesystem / JSON / assets
7. Separate content problems from rollout problems
8. Fix near the source
9. Re-verify everything

## Common Cross-Project Failure Modes

- renamed documents with stale downstream links
- schema changes not reflected in derived tables
- examples using removed fields
- JSON and markdown diverging silently
- docs claiming an authority source that has not actually been updated
- resource guides not matching real directory structures

## Output Pattern

- Conclusion: fully synchronized / mostly synchronized / not synchronized
- What is already in sync
- Problems found
- Repair priority
- Verification result

## Minimal Checklist

- authority source identified
- header metadata checked
- L1 completed
- L2 completed
- L3 completed
- real files checked
- content vs rollout separated
- near-source repair proposed
- re-verification complete