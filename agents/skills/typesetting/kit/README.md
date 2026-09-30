# Page kit

A small UI kit for linear, static informational pages: styles in
`page.css`, behavior in `page.js`, and a tuning panel in
`page-tune.js`. It follows
[`../SKILL.md`](../SKILL.md), which
explains why each block looks the way it does. Nothing here is specific to
briefs.

## Use

Copy `page.css`, `page.js`, and `page-tune.js` next to the pages so a set
stands alone. Start a page from `template.html` and an index from
`index.html`. [`components.html`](components.html) shows every block, and
its source is the markup to copy.

The kit works offline and on `file://`, as classic scripts with no build
step and no external requests. It targets current browsers and uses
current CSS and JavaScript where they remove code. Pages still read without
`page.js`, in the light theme.

## Blocks

| Need | Block | Notes |
|---|---|---|
| Page metadata | `dl.meta`, one `div` per row (`dt` key, `dd` value); `.own` gives a row its own line | keys are labels, values terse |
| Bottom line | `.callout.tldr` | the one card on a page |
| Numbered questions | `ol.questions` | labels hang in the margin |
| Index of pages | `.parts` with `.cards` rows | |
| Run-in head | `span.rh` | sans only |
| Source line | `span.cite` inside a block, or `p.cite` after a `pre`, table, or figure | muted mono |
| Excerpt | `figure.excerpt` | the caption links the lines |
| Trace, diff | `pre.trace` with `.k` frame, `.c` aside, `.w` cost, `.b` failure, `.o` success, `.add`, `.del` | colored notes name kinds |
| Before/after | `.flow` with two `.box` and an `.arrow` | |
| Proportions | `.strip`, `.bars`, inline SVG | fills by kind |
| Highlight in a quote | `mark` | the decisive part only |
| Diff sizes | `td.num` with `span.add` / `span.del`, one column each | |
| Kind tag | `.tag.ok`, `.warn`, `.bad`, `.info`, `.muted` | the fill carries the kind |
| Must-not-miss warning | `.callout.warn`, `.callout.bad` | colored rule, muted label |
| Background | `details.more` | collapsed, one level deep |
| Aside | `aside.side` | in the right margin when there is room |
| Closing list or ledger | `.callout.report` | plain rule |

Color comes only through classes and tokens. Figures paint areas with
`--fill-KIND` and the text on them with `--label-KIND`; the kinds are
`accent`, `neutral`, `ok`, `warn`, and `bad`.

## Chrome

The kit adds the chrome itself: a top bar with the set, the current
section, the position, and the theme; the contents list as a map in the
left margin, or a drop-down from the section name when there is no room;
hanging section numbers; resume and read marks; reading time in
`span.rt`; syntax colors in code; and wrappers that keep tables and SVGs
inside the column. A contents entry may be shorter than its heading; the
map and the top bar show the entry.

## Tuning

The Tune button or the `,` key opens a panel for the kit's maintainer: it
edits the palette, type, layout, and a few options live in this browser,
checks contrast and the P3 gamut, and exports values to paste back into
`page.css`. Set values once and leave them; readers never need the
panel.
