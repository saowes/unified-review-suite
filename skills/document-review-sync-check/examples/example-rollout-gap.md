# Example: Rollout Gap

## Scenario

The schema document has already been updated, but the JSON/config/runtime assets have not caught up yet.

## Typical Symptoms

- docs say a field is authoritative, but the JSON source does not contain it yet
- integration guide uses the new structure, but the runtime file still uses the legacy one
- real assets are partially delivered, while docs describe the full future state

## Expected Review Focus

- L2 detects that definitions and examples do not fully match runtime data
- L3 detects that upstream changes have not fully propagated
- reviewer should classify this as a **rollout problem**, not necessarily a content contradiction

## Expected Output Shape

- Conclusion: mostly synchronized / not fully synchronized
- Problem type: rollout problem
- Repair priority: update runtime source or rewrite authority statement