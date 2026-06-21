# document-review-sync-check

A reusable skill for checking whether one document stays synchronized with its related documents, JSON/config files, and real repository assets.

## What it does

This skill is designed for documentation ecosystems with layered dependencies, such as:

- schema docs → enumeration docs → integration guides → real assets
- docs that frequently rename files or move directories
- docs that derive values from JSON/config files
- docs that describe generated assets/resources

It helps systematically detect:

- broken links
- renamed/deleted upstream docs still referenced downstream
- field drift
- stale examples
- downstream documents not updated after upstream changes
- document vs JSON vs filesystem mismatches

## Directory Structure

```text
document-review-sync-check/
  SKILL.md
  README.md
  references/
    project-method.md
    generic-method.md
  examples/
    example-input.md
    example-output.md
```

## Mounting / Usage

### Claude Code

Place the directory under:

```text
~/.claude/skills/document-review-sync-check/
```

Claude Code will detect the `SKILL.md` file and make the skill available.

### Cursor / Other Agents

For tools that support custom prompt packs / skill directories:

- keep `SKILL.md` as the primary instruction file
- reuse `references/` as supporting context material
- optionally map `examples/` into tool-specific prompt examples

If the target agent requires a different wrapper format, keep `SKILL.md` content as the canonical source and adapt only the outer loader structure.

## Recommended Inputs

When using this skill, provide:

1. target document path
2. known related documents (if any)
3. known JSON/config/asset directories (if any)
4. what kind of sync matters most:
   - link existence
   - field/schema consistency
   - data consistency
   - resource/asset consistency

## Examples

- `examples/example-input.md` — 标准输入示例
- `examples/example-output.md` — 标准输出示例
- `examples/example-broken-links.md` — 纯断链场景（L1）
- `examples/example-rollout-gap.md` — 文档正确但运行时未跟上的 rollout 问题（L2/L3）
- `examples/example-reverse-propagation.md` — 上游改动向下游传导不完整的场景（L3）

## Notes

- `references/project-method.md` preserves a project-originated SOP example
- `references/generic-method.md` is the cross-project reusable abstraction
- `examples/` shows how to ask for a sync audit and how the output should look