---
name: typesetting
description: >-
  Typesetting for rendered pages and documents: what earns a visible
  difference, emphasis, color, labels, boxes, figures, and size. Use when
  producing or styling HTML pages, rendered reports, or formatted documents.
  Includes an HTML page kit.
---

# Typesetting

A philosophy for setting informational pages and rendered documents:
briefs, reports, references, guides.

## Philosophy

The page exists to carry evidence to a reader. Every element either stays
out of the reader's way or carries meaning the reader uses. What does
neither is clutter, and clutter is a failure of design, not a property of
the information (Tufte). Typography is never invisible. It gives the text
its shape, so each choice either helps the meaning or gets in its way
(Butterick, against Warde's "crystal goblet").

- **Every visible difference means something.** A change of face, weight,
  size, color, case, or a box tells the reader "this is a different kind of
  thing". Where there is no different kind, make no difference ("visual
  differences should be semantic differences", Gwern).
- **One signal at a time.** When something must stand out, change one
  property. Hierarchy comes first from structure: headings, order, position,
  lists. Emphasis stacked on emphasis (small, uppercase, bold, letterspaced,
  colored) costs attention and still marks only one thing.
- **Emphasis is rare.** Well-chosen words carry most of it. Bold spent
  everywhere marks nothing; italic is the gentler tool.
- **Color names a kind.** A verdict, a warning, a link, the highlighted part
  of a quote. Chrome and labels stay in the ink's own hues.
- **Evidence sits with its claim.** Excerpts, numbers, traces, and figures
  sit in the flow beside the sentence they support, not in a panel of their
  own ("mode indifference", Tufte). A box that pulls content out of the flow
  needs a reason the reader would give.
- **Chrome stays quiet.** Navigation, metadata, labels, and source lines are
  quieter than the text they serve. Controls for tuning the page are for
  its maintainer and stay out of reading.
- **Honest and robust.** Links look like links; only controls respond to
  clicks. The page still reads correctly without a font, a script, or a
  newer feature (Rendle, Copeland).

## Applying it

- **Faces.** One face per layer: a serif for the text, a sans for chrome
  (labels, navigation, tables, metadata), a mono for code. Switching face is
  itself the signal that the layer changed.
- **Sizes** are perceptual. Faces differ in x-height, so the same nominal
  size reads larger in one face than another. Normalize x-height across
  faces (CSS `font-size-adjust`), then set a smaller size only to mean
  "smaller", never to correct for a face.
- **Labels** (a callout's name, a table header, a metadata key) are sans,
  muted, in sentence case. No capitals, letterspacing, or bold on top.
- **Headings** take size and the sans face; a number and a rule mark
  sections.
- **Run-in heads** ("Inference.", "Watch for.") open a paragraph in the
  sans face and nothing else.
- **Bold** marks the rare term the reader must not miss; italic defines a
  term or quotes a title. Never both, and never on a link or a heading.
- **Boxes.** One orienting box per page, the bottom line. A warning gets a
  colored rule because its kind matters; a ledger or a verdict list gets a
  plain rule. Code and excerpts sit on a card because they are a different
  material, not for emphasis.
- **Figures** show a relation prose hides: a layout, a window, a state
  machine, an order. Label them on the figure itself. Pseudo stack traces
  suit control flow; before/after pairs suit changes.
- **Asides** that a reader can skip go in side notes, in the margin when
  there is room.
- **Numbers** in tables are tabular and right-aligned; a change's size gets
  one column for additions and one for removals.
- **Layout** never truncates; text wraps. Reach first for one intrinsic rule
  that works at every width (wrapping, content sizing clamped by a minimum and
  a maximum), then a media query, and only then a per-block opt-in class.
  Tables size to their content between a minimum and a maximum, and nothing
  widens the page on a phone.

## HTML pages

Build HTML output with the page kit in [`kit/`](kit/). Its
[`README.md`](kit/README.md) maps each need to a block and says what to copy.

## Sources

- Edward Tufte, [*Beautiful Evidence*](https://www.edwardtufte.com/book/beautiful-evidence/): clutter as design failure, mode indifference.
- Matthew Butterick, ["Drowning the crystal goblet"](https://typographyforlawyers.com/drowning-the-crystal-goblet.html): typography shapes the text; and [bold or italic](https://practicaltypography.com/bold-or-italic.html).
- Gwern Branwen, [Design of this website](https://gwern.net/design): visual differences as semantic differences.
- Robin Rendle, ["The New Web Typography"](https://www.robinrendle.com/essays/new-web-typography/): robustness over control.
- David Bryant Copeland, [Brutalist Web Design](https://brutalist-web.design/): honest materials.
