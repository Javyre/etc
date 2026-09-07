# matklad

Reach for when:
- studying module seams
- studying explicit ids and architecture shape
- studying bounded abstractions in large systems
- studying design commentary on language and architecture
- choosing expression density and searchable source forms
- choosing testing philosophy, test boundaries, testability architecture,
  or runtime assertion placement

Transferable patterns:
- keep big codebases navigable
- avoid detached abstraction
- make ids, seams, and ownership obvious
- keep policy close to call-site and owner

Watch:
- higher macro tolerance than Casey/Kelley pole
- use more for architecture and abstraction judgment than for purity on hidden-work axis

Orientation reads:
- https://matklad.github.io/2021/05/31/how-to-test.html
  - primary testing philosophy, feature tests, cheap fixtures, and testability
- https://matklad.github.io/2022/07/04/unit-and-integration-tests.html
  - purity and extent as separate design choices
- https://matklad.github.io/2025/04/15/underusing-snapshot-testing.html
  - concrete examples and snapshots alongside generated properties
- https://matklad.github.io/2025/08/31/vibe-coding-terminal-editor.html
  - agent test failures and an explicit feature-testing interface
- https://tigerbeetle.com/blog/2023-12-27-it-takes-two-to-contract/
  - runtime assertions, paired obligations, and independent execution paths
- https://matklad.github.io/2025/08/09/zigs-lovely-syntax.html
  - small choices at their use, local value-producing blocks, and syntax that
    supports textual search; useful counterpressure to needless expansion
- https://matklad.github.io/2020/08/15/concrete-abstraction.html
- https://matklad.github.io/2020/12/28/csdi.html
- https://rust-analyzer.github.io/book/contributing/architecture.html

Code reads:
- https://github.com/rust-lang/rust-analyzer
