# Example: Reverse Propagation

## Scenario

An upstream schema or naming convention changed, and downstream documents were only partially updated.

## Typical Symptoms

- old field names remain in examples
- new directory structure is not reflected in integration docs
- one downstream table was fixed, but its related guide still cites the old source

## Expected Review Focus

- L3 is the primary layer here
- reviewer should enumerate all dependent artifacts affected by the upstream change
- reviewer should verify whether each downstream target updated completely or only partially

## Expected Output Shape

- Conclusion: not synchronized
- Problem type: reverse-propagation failure
- Repair priority: authority source already correct, downstream docs still pending