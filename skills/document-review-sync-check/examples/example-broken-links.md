# Example: Broken Links Only

## Scenario

A document was moved into a deeper subdirectory, but its relative links were not updated.

## Typical Symptoms

- `../buff-system/...` should have become `../../buff-system/...`
- references to renamed files still use the old filename
- section anchors point to deleted headings

## Expected Review Focus

- L1 should catch all broken paths first
- L2 may still pass if field content itself is consistent
- Conclusion should separate link breakage from content correctness

## Expected Output Shape

- Conclusion: not synchronized
- Problem type: content structure / reference existence
- Repair priority: fix paths first, then rerun full audit