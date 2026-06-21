# Example Output

## Conclusion

The target document is **not fully synchronized** with its related documents.

## What is already in sync

- linked paths all resolve
- current schema authority source identified correctly
- asset naming convention matches the current directory layout

## Problems Found

### P0 / Blocking
- The integration guide still references removed field `direction_mode`, but the current schema has already deleted it.
- The guide still treats `skills.json` as holding `vfx_config`, but the current JSON source does not contain that field.

### P1 / Must Fix
- The document still uses old version references for upstream docs.
- The runtime lookup description does not match the current asset table model.

### P2 / Follow-up
- Example snippets should be refreshed to match the current field structure.

## Problem Types

- **Content problem**: schema description conflicts with upstream source of truth
- **Rollout problem**: JSON source has not yet caught up with the latest doc-layer structure

## Repair Priority

1. fix authority-source references
2. remove deleted fields from downstream guide
3. align examples and runtime lookup text
4. re-run reference + content + propagation audit

## Verification Result

After the fixes, re-check:
- link reachability
- field list parity
- example freshness
- JSON/config reality
- directory layout consistency