---
name: document-review-sync-check
description: "检查一份文档是否与其关联文档、JSON、配置文件和实际资源资产保持同步。适用于 schema/枚举表/接入文档/资源文档。核心方法：L1 引用存在性、L2 参数一致性、L3 反向归因。"
license: MIT
---

# Document Review Sync Check

Use this skill when you need to audit whether one document is synchronized with its related documents, JSON data files, config files, and real repository assets.

## What this skill is for

This skill is designed for documentation ecosystems where different files play different roles, such as:
- schema docs → enumeration docs → integration guides → real assets
- docs that often rename files or move directories
- docs that derive values from JSON/config files
- docs that describe generated assets/resources

The goal is to systematically detect:
- broken links
- renamed/deleted upstream docs still referenced downstream
- field drift
- stale examples
- downstream documents not updated after upstream changes
- document vs JSON vs filesystem mismatches

## Method: Three-Layer Review

### L1 — Reference Existence
Check whether references still exist.

What to check:
- markdown links resolve
- referenced files still exist
- renamed/deleted docs are still being referenced
- section anchors still make sense
- referenced directories/files still exist

Output:
- path exists → pass
- path missing → blocking issue
- path exists but target is deprecated/outdated → important issue

### L2 — Parameter / Content Consistency
Check whether the content definitions still match.

What to compare:
- field names
- enum values
- version numbers
- ids / numeric values / config values
- naming conventions
- JSON structure
- sample snippets / code examples
- declared responsibilities / authority statements

Typical examples:
- schema doc vs enum table
- enum table vs JSON file
- integration guide vs resource spec
- doc vs real asset directory

### L3 — Reverse Propagation
Check whether upstream changes have propagated to all downstream documents.

Core question:
If document A changed, did every dependent document B/C/D update too?

What to look for:
- old field names still present downstream
- renamed files still referenced
- new directory structure not reflected in guides
- authority source changed but derived docs still cite old source
- generated assets renamed but docs/examples still use old names

## Detailed Workflow

### Step 1: Identify authority sources
Before checking anything, answer:
1. Which file defines the rules?
2. Which file lists the instances/data?
3. Which file explains integration/runtime behavior?
4. Which file describes assets/resources?
5. Which file is the runtime truth (JSON/config/filesystem)?

### Step 2: Inspect the document header first
Always read the header before the body.

Check:
- version
- source document
- related documents
- prerequisites
- authority scope
- owner

### Step 3: Run L1
Check all links and referenced paths.

### Step 4: Run L2
Compare definitions and values field-by-field.

### Step 5: Run L3
Propagate upstream changes through all downstream references.

### Step 6: Compare against real files
Never stop at docs alone. Cross-check:
- JSON files
- config files
- filesystem layout
- asset/resource files
- generated metadata

### Step 7: Separate content problems from rollout problems
Content problem:
- docs contradict each other

Rollout problem:
- docs are correct, but implementation / assets / JSON have not caught up

### Step 8: Fix near the source
Preferred repair order:
1. authority source
2. primary derived doc
3. integration guide
4. examples / appendix / notes

### Step 9: Re-verify
After changes, re-check:
- links
- versions
- fields
- values
- JSON parsing
- real file existence
- authority statements

## Output Format

Use a structured result like this:

1. **Conclusion**
   - fully synchronized / mostly synchronized / not synchronized
2. **What is already in sync**
   - list dimensions with no problems
3. **Problems found**
   - location
   - what is inconsistent
   - why it matters
   - whether it is a content problem or rollout problem
4. **Repair priority**
   - P0 authority/blocking
   - P1 downstream docs
   - P2 examples/appendix/version notes
   - P3 style only
5. **Verification result**
   - what was re-checked after repair

## Caveats

- A document can be functionally usable while still having stale version references.
- Examples go stale faster than field tables; always check examples separately.
- Relative paths often break after directory nesting changes.
- Filesystem truth may differ from JSON truth; verify both.
- If the project is in transition, do not falsely claim one source is authoritative if it has not actually been updated.
- Clearly distinguish “not yet delivered” assets from “wrongly documented” assets.

## Minimal Checklist

- [ ] Authority source identified
- [ ] Header metadata checked
- [ ] L1 reference existence done
- [ ] L2 parameter consistency done
- [ ] L3 reverse propagation done
- [ ] Real files / JSON / assets checked
- [ ] Content vs rollout issues separated
- [ ] Near-source fix strategy proposed
- [ ] Re-verification complete

## Project-specific notes

A project may have special conventions for:
- authority-source document names
- directory naming
- JSON filenames
- asset naming conventions
- version reference patterns
- issue severity taxonomy

Replace those details per project when applying this skill.
