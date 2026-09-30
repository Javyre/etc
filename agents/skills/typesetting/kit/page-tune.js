// page-tune.js: the tuning panel. page.js loads it on demand (the Tune
// button, or the "," key). It edits the palette, type, layout and options
// live on every page of the set, saves them in this browser, and exports
// them as CSS or as a JSON file to paste back into page.css.
//
// Classic script, no dependencies, works on file://.

(function () {
  var root = document.documentElement;
  var B = window.pageKit;
  var PANEL = 360;

  // Parameters. s: "t" = per theme, "c" = both themes. span: the slider
  // covers the kit value ± span, for fine control; the number box takes any
  // value. base: a delta is added to this base; the row shows the result.
  var P = [
    { k: "l-bg", l: "page L", s: "t", g: "Page", span: .08, step: .001 },
    { k: "c-paper", l: "paper C", s: "t", g: "Page", span: .015, step: .0005 },
    { k: "h-paper", l: "paper hue", s: "t", g: "Page", span: 60, step: 1 },
    { k: "d-card", l: "card L", s: "t", g: "Page", base: "l-bg", span: .1, step: .001 },
    { k: "d-rule", l: "rule L", s: "t", g: "Page", base: "l-bg", span: .12, step: .001 },
    { k: "d-fill", l: "fill L", s: "t", g: "Fill and highlight", base: "l-bg", span: .12, step: .001 },
    { k: "c-fill", l: "fill C", s: "t", g: "Fill and highlight", span: .04, step: .001 },
    { k: "d-mark", l: "highlight L", s: "t", g: "Fill and highlight", base: "l-bg", span: .15, step: .001 },
    { k: "c-mark", l: "highlight C", s: "t", g: "Fill and highlight", span: .05, step: .001 },
    { k: "h-mark", l: "highlight hue", s: "c", g: "Fill and highlight", span: 30, step: .1 },
    { k: "l-fg", l: "text L", s: "t", g: "Text", span: .12, step: .001 },
    { k: "c-ink", l: "ink C", s: "t", g: "Text", span: .015, step: .0005 },
    { k: "d-muted", l: "muted L", s: "t", g: "Text", base: "l-fg", span: .15, step: .001 },
    { k: "l-accent", l: "accent L", s: "t", g: "Accent", span: .1, step: .001 },
    { k: "c-accent", l: "accent C", s: "t", g: "Accent", span: .08, step: .001 },
    { k: "h-accent", l: "accent hue", s: "c", g: "Accent", span: 60, step: .1 },
    { k: "d-sig", l: "signal L", s: "t", g: "Signal (warnings, trace notes)", base: "l-accent", span: .1, step: .001 },
    { k: "dc-sig", l: "signal C", s: "t", g: "Signal (warnings, trace notes)", base: "c-accent", span: .1, step: .001 },
    { k: "h-ok", l: "ok hue", s: "c", g: "Signal (warnings, trace notes)", span: 30, step: 1 },
    { k: "h-warn", l: "warn hue", s: "c", g: "Signal (warnings, trace notes)", span: 30, step: 1 },
    { k: "h-bad", l: "bad hue", s: "c", g: "Signal (warnings, trace notes)", span: 30, step: 1 },
    { k: "d-label", l: "label L", s: "t", g: "Label (text on fills)", base: "l-fill", span: .1, step: .001 },
    { k: "dc-label", l: "label C", s: "t", g: "Label (text on fills)", base: "c-accent", span: .1, step: .001 },
    { k: "d-syn", l: "code L", s: "t", g: "Code", base: "l-accent", span: .1, step: .001 },
    { k: "dc-syn", l: "code C", s: "t", g: "Code", base: "c-accent", span: .12, step: .001 },
    { k: "h-str", l: "string hue", s: "c", g: "Code", span: 40, step: 1 },
    { k: "h-num", l: "number hue", s: "c", g: "Code", span: 40, step: 1 },
    { k: "h-ty", l: "type hue", s: "c", g: "Code", span: 40, step: 1 },
    { k: "h-mac", l: "macro hue", s: "c", g: "Code", span: 40, step: 1 },
    { k: "text", l: "size", s: "c", g: "Type", span: 2, step: .25, u: "px" },
    { k: "leading", l: "leading", s: "c", g: "Type", span: .2, step: .01 },
    { k: "bold-x", l: "bold stroke", s: "t", g: "Type", span: .02, step: .001, u: "em" },
    { k: "col", l: "column", s: "c", g: "Layout", span: 6, step: .25, u: "rem" },
    { k: "rail", l: "rail", s: "c", g: "Layout", span: 3, step: .25, u: "rem" },
    { k: "rail-gap", l: "rail gap", s: "c", g: "Layout", span: 2.5, step: .25, u: "rem" },
    { k: "hang", l: "hang", s: "c", g: "Layout", span: 1.5, step: .25, u: "rem" }
  ];
  // Chroma caps, one per colored role (see "Caps" in page.css). Only "fit P3"
  // sets them, so they get no rows of their own.
  var CAPS = ["accent", "mark", "sig-ok", "sig-warn", "sig-bad",
    "fill-accent", "fill-ok", "fill-warn", "fill-bad", "label-accent", "label-ok", "label-warn", "label-bad",
    "syn-kw", "syn-str", "syn-num", "syn-ty", "syn-mac"];
  CAPS.forEach(function (r) { P.push({ k: "cap-" + r, l: r + " cap", s: "t", cap: true }); });
  var PK = {}; P.forEach(function (p) { PK[p.k] = p; });
  var BASE_NAME = { "l-bg": "page L", "l-fill": "fill L", "l-fg": "text L", "l-accent": "accent L", "c-accent": "accent C" };

  // Options: [name, label, values (first = kit default), hint]. Each maps to
  // html[data-o-NAME] in page.css.
  var O = [
    ["density", "density", ["compact", "normal", "airy"], "vertical rhythm of every block"],
    ["metaform", "metadata", ["line", "grid"], "line: rows run together; grid: one row per key"],
    ["cites", "citations", ["line", "inline"], "line: a muted source line under the block; inline: in parentheses at its end"],
    ["num", "section no.", ["hang", "inline", "none"]],
    ["barsection", "bar section", ["auto", "on", "off"], "current section name in the top bar; auto = when there is no map"],
    ["notes", "side notes", ["inline", "hidden"], "side notes when there is no right gutter"],
    ["focus", "focus", ["off", "section"], "dims everything outside the section you are reading"],
    ["font", "body font", ["serif", "sans"]],
    ["links", "links", ["accent", "quiet"], "quiet: ink text, accent underline"],
    ["keywords", "code keywords", ["color", "plain"], "plain: keywords in the text color"],
    ["mapnum", "map numbers", ["off", "on"]]
  ];
  var OK = {}; O.forEach(function (o) { OK[o[0]] = o; });

  // ---- state: numbers here; strings with units in storage.
  var defaults = { light: {}, dark: {}, c: {} };
  var st = { light: {}, dark: {}, c: {}, o: {} };
  var guides = false;

  function fromStore() {
    var s = B.loadTune();
    // Options the kit no longer has are dropped.
    const o = Object.fromEntries(Object.entries(s.o ?? {}).filter(([k, v]) => OK[k]?.[2].includes(v)));
    st = { light: {}, dark: {}, c: {}, o };
    [["light", "light"], ["dark", "dark"], ["both", "c"]].forEach(function (m) {
      var src = s[m[0]] || {};
      Object.keys(src).forEach(function (k) { if (PK[k]) st[m[1]][k] = parseFloat(src[k]); });
    });
  }
  function toStore() {
    var s = { light: {}, dark: {}, both: {}, o: {} };
    [["light", "light"], ["dark", "dark"], ["c", "both"]].forEach(function (m) {
      Object.keys(st[m[0]]).forEach(function (k) { s[m[1]][k] = fmt(st[m[0]][k]) + unit(PK[k]); });
    });
    Object.keys(st.o).forEach(function (k) { if (st.o[k] !== OK[k][2][0]) s.o[k] = st.o[k]; });
    return s;
  }

  function theme() { return B.effectiveTheme(); }
  function bag(p, t) { return p.s === "t" ? st[t || theme()] : st.c; }
  function def(p, t) { return p.s === "t" ? defaults[t || theme()][p.k] : defaults.c[p.k]; }
  function get(k, t) { var p = PK[k], b = bag(p, t); return k in b ? b[k] : def(p, t); }
  function unit(p) { return p.u || ""; }
  function fmt(n) { return String(+(+n).toFixed(4)).replace(/^(-?)0\./, "$1."); }
  function opt(name) { return st.o[name] || OK[name][2][0]; }

  // Kit values come from page.css: drop overrides, read each theme, restore.
  function readDefaults() {
    var had = root.getAttribute("data-theme");
    P.forEach(function (p) { root.style.removeProperty("--" + p.k); });
    ["light", "dark"].forEach(function (t) {
      root.setAttribute("data-theme", t);
      var cs = getComputedStyle(root);
      P.forEach(function (p) {
        var v = parseFloat(cs.getPropertyValue("--" + p.k));
        if (p.s === "t") defaults[t][p.k] = v; else defaults.c[p.k] = v;
      });
    });
    root.dataset.theme = had;
    B.applyTune();
  }

  // ---- color roles, mirroring the role table in page.css. Kinds: accent,
  // neutral, ok, warn, bad. Returns [L, C, h] for either theme.
  function derived(k, t) {
    var g = function (x) { return get(x, t); };
    if (k === "l-fill") return g("l-bg") + g("d-fill");
    return g(k);
  }
  function hueOf(kind, t) {
    return kind === "neutral" ? get("h-paper", t) : get("h-" + kind, t);
  }
  // raw: ignore the role's chroma cap.
  function role(r, t, raw) {
    var c = roleOf(r, t), cap = raw || !PK["cap-" + r] ? NaN : get("cap-" + r, t);
    return isFinite(cap) ? [c[0], Math.min(c[1], cap), c[2]] : c;
  }
  function roleOf(r, t) {
    var g = function (k) { return get(k, t); };
    var bg = g("l-bg"), fg = g("l-fg"), la = g("l-accent"), ca = g("c-accent"), hp = g("h-paper");
    var fill = bg + g("d-fill");
    var m = r.match(/^(fill|label|sig|syn)-(.+)$/);
    if (m) {
      var kind = m[2], neutral = kind === "neutral";
      if (m[1] === "fill") return [fill, neutral ? g("c-paper") : g("c-fill"), hueOf(kind, t)];
      if (m[1] === "label") return [fill + g("d-label"), neutral ? g("c-ink") : ca + g("dc-label"), hueOf(kind, t)];
      if (m[1] === "sig") return [la + g("d-sig"), neutral ? g("c-ink") : ca + g("dc-sig"), hueOf(kind, t)];
      return [la + g("d-syn"), ca + g("dc-syn"), kind === "kw" ? g("h-accent") : g("h-" + kind)];
    }
    switch (r) {
      case "bg": return [bg, g("c-paper"), hp];
      case "card": return [bg + g("d-card"), g("c-paper"), hp];
      case "rule": return [bg + g("d-rule"), g("c-paper"), hp];
      case "mark": return [bg + g("d-mark"), g("c-mark"), g("h-mark")];
      case "fg": return [fg, g("c-ink"), hp];
      case "muted": return [fg + g("d-muted"), g("c-ink"), hp];
      case "accent": return [la, ca, g("h-accent")];
    }
  }
  var SYN = { kw: "keyword", str: "string", num: "number", ty: "type", mac: "macro" };
  function nameOf(r) {
    var m = r.match(/^(fill|label|sig|syn)-(.+)$/);
    if (m) return m[1] === "syn" ? "code " + SYN[m[2]] : (m[1] === "sig" ? "signal" : m[1]) + " " + m[2];
    return { bg: "page", card: "card", rule: "rule", mark: "highlight", fg: "text", muted: "muted", accent: "accent" }[r];
  }
  var CSSVAR = { "sig-ok": "--ok", "sig-warn": "--warn", "sig-bad": "--bad", mark: "--mark-bg" };
  function cssv(r) { return CSSVAR[r] || "--" + r; }

  function lin(c) {
    var L = c[0], C = c[1], h = c[2] * Math.PI / 180, a = C * Math.cos(h), b = C * Math.sin(h);
    var l = Math.pow(L + .3963377774 * a + .2158037573 * b, 3);
    var m = Math.pow(L - .1055613458 * a - .0638541728 * b, 3);
    var s = Math.pow(L - .0894841775 * a - 1.291485548 * b, 3);
    return [4.0767416621 * l - 3.3077115913 * m + .2309699292 * s,
            -1.2684380046 * l + 2.6097574011 * m - .3413193965 * s,
            -.0041960863 * l - .7034186147 * m + 1.707614701 * s];
  }
  function gamut(c) {
    var e = .0005, ok = function (v) { return v.every(function (x) { return x >= -e && x <= 1 + e; }); };
    if (ok(c)) return "";
    return ok([.8224621 * c[0] + .177538 * c[1], .0331941 * c[0] + .9668058 * c[1],
      .0170827 * c[0] + .0723974 * c[1] + .9105199 * c[2]]) ? "P3" : "out";
  }
  function Y(c) { return Math.max(0, .2126 * c[0] + .7152 * c[1] + .0722 * c[2]); }
  function ratio(a, b) { var x = Y(a), y = Y(b); return (Math.max(x, y) + .05) / (Math.min(x, y) + .05); }

  // [text role, surface role, WCAG target]. Each role is checked on the
  // surface it is used on: signal on the page (warning rules) and cards
  // (trace notes), labels on their own fill, code on cards.
  var KINDS = ["accent", "neutral", "ok", "warn", "bad"];
  var PAIRS = [["fg", "bg", 7], ["fg", "card", 7], ["fg", "mark", 7],
    ["muted", "bg", 4.5], ["muted", "card", 4.5], ["accent", "bg", 4.5], ["accent", "card", 4.5]]
    .concat(["ok", "warn", "bad"].flatMap((k) => [["sig-" + k, "card", 4.5], ["sig-" + k, "bg", 4.5]]))
    .concat(KINDS.map(function (k) { return ["label-" + k, "fill-" + k, 4.5]; }))
    .concat(["kw", "str", "num", "ty", "mac"].map(function (k) { return ["syn-" + k, "card", 4.5]; }));
  // [surface, against, visibility floor]. The floors are judgment, not a
  // standard: below them a surface reads as the same plane.
  var STEPS = [["card", "bg", 1.06], ["rule", "bg", 1.2], ["rule", "card", 1.1], ["fill-neutral", "bg", 1.1],
    ["fill-neutral", "card", 1.1], ["mark", "bg", 1.15]];
  function contrast(t) {
    return PAIRS.map(function (p) {
      var a = lin(role(p[0], t)), b = lin(role(p[1], t)), r = ratio(a, b);
      var g = [gamut(a), gamut(b)].indexOf("out") >= 0 ? "out" : [gamut(a), gamut(b)].indexOf("P3") >= 0 ? "P3" : "";
      return { text: nameOf(p[0]), on: nameOf(p[1]), fg: p[0], bg: p[1], ratio: +r.toFixed(2), need: p[2], pass: r >= p[2], gamut: g };
    });
  }
  function steps(t) {
    return STEPS.map(function (p) {
      var r = ratio(lin(role(p[0], t)), lin(role(p[1], t)));
      return { a: nameOf(p[0]), b: nameOf(p[1]), ra: p[0], ratio: +r.toFixed(2), floor: p[2], pass: r >= p[2] };
    });
  }

  // ---- fit P3: bring every role inside Display P3 by lowering chroma only,
  // the direction CSS Color 4 gamut mapping takes: lightness and hue stay
  // put, and contrast barely changes. A colored role that falls outside
  // gets a cap at the most chroma P3 holds at its L and hue; every other
  // role keeps its chroma, so the look changes only where a screen would
  // clip anyway. The neutral groups have no caps and drop as a group.
  var NGROUPS = [["c-paper", ["bg", "card", "rule", "fill-neutral"]],
    ["c-ink", ["fg", "muted", "label-neutral"]]];
  // Largest chroma, at .001, that keeps role r inside P3 at its L and hue.
  function maxC(r, t) {
    var c = role(r, t, true), inside = function (C) { return gamut(lin([c[0], C, c[2]])) !== "out"; };
    if (inside(c[1])) return c[1];
    var lo = 0, hi = c[1];
    for (var i = 0; i < 30; i++) { var m = (lo + hi) / 2; if (inside(m)) lo = m; else hi = m; }
    return Math.floor(lo * 1000) / 1000;
  }
  // Set a per-theme value; a value equal to the kit's is dropped instead.
  function put(k, t, v) {
    var d = def(PK[k], t);
    if (v === d || (!isFinite(v) && !isFinite(d))) delete st[t][k]; else st[t][k] = v;
  }
  function fitP3() {
    var moved = [];
    ["light", "dark"].forEach(function (t) {
      NGROUPS.forEach(function (g) {
        var from = get(g[0], t), to = Math.min.apply(null, [from].concat(g[1].map(function (r) { return maxC(r, t); })));
        if (to === from) return;
        put(g[0], t, to);
        moved.push(t + " " + PK[g[0]].l + " " + fmt(from) + " → " + fmt(to));
      });
      CAPS.forEach(function (r) {
        var k = "cap-" + r, was = get(k, t), C = role(r, t, true)[1], m = maxC(r, t);
        // When no cap is needed, drop it, or set 1 to lift a cap the kit sets.
        var to = m < C ? m : isFinite(def(PK[k], t)) ? 1 : NaN;
        put(k, t, to);
        var now = get(k, t);
        if (now === was || (!isFinite(now) && !isFinite(was))) return;
        moved.push(t + " " + nameOf(r) + (m < C ? " C " + fmt(Math.min(C, was) || C) + " → " + fmt(m) : " cap lifted"));
      });
    });
    commit();
    note(moved.length ? "Fit P3: " + moved.join("; ") + "." : "Every color is already inside P3.");
  }

  // ---- apply: save to page.js storage, which applies to the page.
  function commit() {
    B.saveTune(toStore());
    root.classList.toggle("tune-guides", guides);
    drawGuides();
    if (B.refresh) B.refresh();
    render();
  }

  function px(name) {
    var v = getComputedStyle(root).getPropertyValue(name).trim(), n = parseFloat(v);
    return /rem$/.test(v) ? n * parseFloat(getComputedStyle(root).fontSize) : n;
  }
  function tiers() {
    var w = root.clientWidth - (isOpen() ? PANEL : 0), col = px("--col");
    return { w: w, rail: Math.ceil(col + 2 * (px("--rail") + 2 * px("--rail-gap"))),
      hang: Math.ceil(col + 2 * px("--hang")) };
  }
  function drawGuides() {
    var el = document.getElementById("tune-guides");
    el.innerHTML = "";
    if (!guides || !isOpen()) return;
    var w = root.clientWidth - PANEL, col = px("--col"), gutter = (w - col) / 2, rail = px("--rail"), gap = px("--rail-gap");
    [[gutter, ""], [gutter + col, ""], [gutter - gap, "c"], [gutter - gap - rail, "c"],
     [gutter + col + gap, "c"], [gutter + col + gap + rail, "c"]].forEach(function (x) {
      var g = document.createElement("i"); g.className = x[1]; g.style.left = x[0] + "px"; el.appendChild(g);
    });
  }

  // ---- export
  function cssText() {
    var out = [];
    ["light", "dark"].forEach(function (t) {
      const line = (ps) => ps.map((p) => "--" + p.k + ": " + fmt(get(p.k, t)) + unit(p) + ";").join("  ");
      out.push("/* " + t + " */");
      out.push(line(P.filter((p) => p.s === "t" && !p.cap)));
      // Caps go in the theme's cap block, not with its tokens.
      const caps = P.filter((p) => p.cap && isFinite(get(p.k, t)) && get(p.k, t) < 1);
      if (caps.length) out.push("/* " + t + " caps */", line(caps));
    });
    out.push("/* both themes */");
    out.push(P.filter(function (p) { return p.s === "c"; }).map(function (p) {
      return "--" + p.k + ": " + fmt(get(p.k)) + unit(p) + ";";
    }).join("  "));
    out.push("/* options */");
    out.push(O.map(function (o) { return o[0] + "=" + opt(o[0]); }).join("  "));
    return out.join("\n");
  }
  function changed() {
    var c = { light: {}, dark: {}, both: {}, options: {} };
    ["light", "dark"].forEach(function (t) {
      Object.keys(st[t]).forEach(function (k) { c[t][k] = { kit: defaults[t][k], now: st[t][k] }; });
    });
    Object.keys(st.c).forEach(function (k) { c.both[k] = { kit: defaults.c[k], now: st.c[k] }; });
    O.forEach(function (o) { if (opt(o[0]) !== o[2][0]) c.options[o[0]] = { kit: o[2][0], now: opt(o[0]) }; });
    return c;
  }
  function saveFile() {
    var data = { what: "page kit tuning", saved: new Date().toISOString(), page: location.pathname,
      changed: changed(), css: cssText(),
      contrast: { light: contrast("light"), dark: contrast("dark") } };
    var a = document.createElement("a");
    a.href = URL.createObjectURL(new Blob([JSON.stringify(data, null, 2)], { type: "application/json" }));
    a.download = "page-tune.json";
    document.body.appendChild(a); a.click(); a.remove();
    note("Saved page-tune.json to your downloads folder.");
  }
  function note(s) { var el = document.getElementById("tune-note"); if (el) el.textContent = s; }

  // ---- panel DOM
  var CSS = [
    "html.tuning body { margin-right: " + PANEL + "px; }",
    "#tune { position: fixed; top: 0; right: 0; bottom: 0; width: " + PANEL + "px; z-index: 30; overflow-y: auto;",
    "  background: var(--bg); border-left: 1px solid var(--rule); color: var(--fg); padding: 8px 12px 40px;",
    "  font: 11.5px/1.35 var(--sans); font-variant-numeric: tabular-nums; display: none; }",
    "html.tuning #tune { display: block; }",
    "#tune h3 { font: 700 10px/1.2 var(--sans); letter-spacing: .08em; text-transform: uppercase; color: var(--muted);",
    "  margin: 12px 0 3px; border: 0; padding: 0; }",
    "#tune table { width: 100%; border-collapse: collapse; margin: 0; font-size: 11.5px; line-height: 1.3; }",
    "#tune th { font: 600 9.5px var(--sans); letter-spacing: .05em; text-transform: uppercase; color: var(--muted);",
    "  padding: 2px 3px; text-align: left; border-bottom: 1px solid var(--rule); }",
    "#tune td { padding: 1px 3px; border-bottom: 1px solid var(--rule); vertical-align: middle; }",
    "#tune td.k { color: var(--muted); white-space: nowrap; width: 88px; }",
    "#tune td.k small { display: block; font-size: 9.5px; color: var(--muted); line-height: 1.1; }",
    "#tune tr.changed td.k { color: var(--fg); font-weight: 650; }",
    "#tune td.r { text-align: right; white-space: nowrap; }",
    "#tune td.eq { color: var(--muted); text-align: right; white-space: nowrap; width: 40px; }",
    "#tune td.x { width: 16px; text-align: center; }",
    "#tune input[type=range] { width: 100%; height: 14px; margin: 0; accent-color: var(--accent); }",
    "#tune input[type=number] { width: 56px; font: inherit; background: transparent; color: var(--fg);",
    "  border: 0; padding: 0 2px; text-align: right; }",
    "#tune input[type=number]:focus { background: var(--card); outline: 1px solid var(--accent); }",
    "#tune button { font: inherit; border: 1px solid transparent; background: transparent; color: var(--muted);",
    "  border-radius: 3px; padding: 0 5px; cursor: pointer; line-height: 1.5; }",
    "#tune button:hover { color: var(--fg); }",
    "#tune button.on { color: var(--fg); background: var(--card); border-color: var(--rule); }",
    "#tune button.on.moved { border-color: var(--accent); }",
    "#tune button.reset { padding: 0; visibility: hidden; }",
    "#tune tr.changed button.reset { visibility: visible; }",
    "#tune .chips { display: flex; flex-wrap: wrap; gap: 2px; }",
    "#tune .hdr { display: flex; gap: 2px; align-items: center; flex-wrap: wrap; }",
    "#tune .hint { color: var(--muted); font-size: 10.5px; margin: 3px 0; }",
    "#tune td.sw { font: 650 11px var(--sans); text-align: center; width: 26px; }",
    "#tune .low { color: var(--bad); font-weight: 700; }",
    "#tune .pass { color: var(--ok); }",
    "#tune textarea { width: 100%; height: 110px; font: 10.5px/1.35 var(--mono); background: var(--card);",
    "  color: var(--fg); border: 1px solid var(--rule); border-radius: 3px; padding: 5px; }",
    "#tune-guides { position: fixed; inset: 0; pointer-events: none; z-index: 5; }",
    "#tune-guides i { position: absolute; top: 0; bottom: 0; border-left: 1px dashed oklch(.65 .2 25 / .7); }",
    "#tune-guides i.c { border-left-style: dotted; border-left-color: oklch(.65 .15 250 / .7); }"
  ].join("\n");

  function build() {
    var style = document.createElement("style"); style.textContent = CSS; document.head.appendChild(style);
    var g = document.createElement("div"); g.id = "tune-guides"; document.body.appendChild(g);
    var el = document.createElement("aside"); el.id = "tune"; el.setAttribute("aria-label", "Tuning panel");
    var h = [];
    h.push('<div class="hdr"><b style="margin-right:4px">Tune</b><span class="chips" id="tune-theme">' +
      '<button data-t="light">light</button><button data-t="dark">dark</button></span>' +
      '<span style="flex:1"></span><button id="tune-save" title="Download page-tune.json">save file</button>' +
      '<button id="tune-close" title="Close (,)">close</button></div>');
    h.push('<p class="hint">Changes apply to every page that uses this kit, in this browser. Color rows edit the theme ' +
      'shown; hues, type, layout and options apply to both. Rows marked "base +" are offsets: the right column ' +
      'shows the result. Sliders span the kit value ± a small window; type any value in the box. ' +
      'Arrows step, Shift ×10, Alt ÷10. ↺ resets a row.</p><p class="hint" id="tune-note"></p>');
    var group = null;
    P.forEach(function (p) {
      if (p.cap) return;
      if (p.g !== group) { if (group) h.push("</table>"); group = p.g; h.push("<h3>" + group + "</h3><table>"); }
      h.push('<tr data-k="' + p.k + '"><td class="k" title="--' + p.k + '">' + p.l +
        (p.base ? "<small>= " + BASE_NAME[p.base] + " +</small>" : "") +
        '</td><td><input type="range"></td><td class="r"><input type="number" step="' + p.step +
        '"></td><td class="eq"></td><td class="x"><button class="reset" title="Reset to kit value">↺</button></td></tr>');
    });
    h.push("</table><h3>Options</h3><table>");
    O.forEach(function (o) {
      h.push('<tr data-o="' + o[0] + '"><td class="k"' + (o[3] ? ' title="' + o[3] + '"' : "") + ">" + o[1] +
        '</td><td colspan=3><span class="chips">' +
        o[2].map(function (v) { return '<button data-v="' + v + '">' + v + "</button>"; }).join("") +
        '</span></td><td class="x"><button class="reset" title="Reset to kit value">↺</button></td></tr>');
    });
    h.push('<tr><td class="k" title="Tuning panel only; not saved">guides</td><td colspan=4><span class="chips" id="tune-guides-t">' +
      '<button data-v="off">off</button><button data-v="on">on</button></span></td></tr>');
    h.push('</table><p class="hint">Hover an option name for what it does. Guides: dashed = text column, dotted = map and note rails.</p>');
    h.push('<h3>Layout</h3><p class="hint" id="tune-tiers"></p>');
    h.push('<h3>Contrast, theme shown</h3><table><thead><tr><th></th><th>text</th><th>on</th>' +
      '<th class="r">ratio</th><th class="r">need</th><th></th><th>gamut</th></tr></thead><tbody id="tune-contrast"></tbody></table>');
    h.push('<p class="hint">Ratio: WCAG 2 contrast, 1 to 21. Need: 7 for body text, 4.5 for other text. ' +
      'Gamut: blank = any screen; P3 = exact only on wide-gamut screens (clipped on sRGB); out = no screen shows it.</p>' +
      '<div class="hdr"><button id="tune-fit" title="Lower chroma, never lightness or hue, until every color in both ' +
      'themes is inside P3">fit P3</button></div>');
    h.push('<table><thead><tr><th></th><th>surface</th><th>vs</th><th class="r">ratio</th><th class="r">floor</th><th colspan=2></th></tr></thead>' +
      '<tbody id="tune-steps"></tbody></table><p class="hint">Surface steps: how far one surface stands off ' +
      'another. Floor: below it the two read as one plane; a judgment, not a standard. 1.00 means identical.</p>');
    h.push('<h3>Export</h3><textarea id="tune-css" readonly></textarea><div class="hdr">' +
      '<button id="tune-copy">copy</button><button id="tune-reset-t">reset theme</button>' +
      '<button id="tune-reset-all">reset all</button></div>');
    el.innerHTML = h.join("");
    document.body.appendChild(el);
    wire(el);
  }

  function windowFor(p) {
    var d = def(p), v = get(p.k);
    return [Math.min(d - p.span, v), Math.max(d + p.span, v)];
  }

  function wire(el) {
    el.querySelectorAll("tr[data-k]").forEach(function (row) {
      var p = PK[row.dataset.k], r = row.querySelector("[type=range]"), n = row.querySelector("[type=number]");
      function set(v) { v = parseFloat(v); if (isNaN(v)) return; bag(p)[p.k] = +v.toFixed(5); commit(); }
      r.addEventListener("input", function () { set(r.value); });
      n.addEventListener("change", function () { set(n.value); });
      [r, n].forEach(function (inp) {
        inp.addEventListener("keydown", function (e) {
          var up = e.key === "ArrowUp" || (inp === r && e.key === "ArrowRight");
          var down = e.key === "ArrowDown" || (inp === r && e.key === "ArrowLeft");
          if (!up && !down) return;
          e.preventDefault(); e.stopPropagation();
          set(get(p.k) + (up ? 1 : -1) * p.step * (e.shiftKey ? 10 : e.altKey ? .1 : 1));
        });
      });
      row.querySelector(".reset").addEventListener("click", function () { delete bag(p)[p.k]; commit(); });
    });
    el.querySelectorAll("tr[data-o]").forEach(function (row) {
      row.addEventListener("click", function (e) {
        var name = row.dataset.o;
        if (e.target.classList.contains("reset")) { delete st.o[name]; commit(); return; }
        var v = e.target.dataset && e.target.dataset.v; if (!v) return;
        st.o[name] = v; commit();
      });
    });
    document.getElementById("tune-guides-t").addEventListener("click", function (e) {
      var v = e.target.dataset && e.target.dataset.v; if (v) { guides = v === "on"; commit(); }
    });
    document.getElementById("tune-theme").addEventListener("click", function (e) {
      var t = e.target.dataset && e.target.dataset.t; if (t) { B.setTheme(t); render(); }
    });
    document.getElementById("tune-save").addEventListener("click", saveFile);
    document.getElementById("tune-fit").addEventListener("click", fitP3);
    document.getElementById("tune-close").addEventListener("click", toggle);
    document.getElementById("tune-copy").addEventListener("click", function () {
      var ta = document.getElementById("tune-css"); ta.select();
      try { navigator.clipboard.writeText(ta.value); note("Copied."); } catch (e) { document.execCommand("copy"); }
    });
    document.getElementById("tune-reset-t").addEventListener("click", function () { st[theme()] = {}; commit(); });
    document.getElementById("tune-reset-all").addEventListener("click", function () {
      st = { light: {}, dark: {}, c: {}, o: {} }; commit();
    });
  }

  function render() {
    var el = document.getElementById("tune"); if (!el) return;
    el.querySelectorAll("tr[data-k]").forEach(function (row) {
      var p = PK[row.dataset.k], v = get(p.k), w = windowFor(p);
      var r = row.querySelector("[type=range]");
      r.min = w[0]; r.max = w[1]; r.step = p.step / 10; r.value = v;
      var n = row.querySelector("[type=number]");
      if (document.activeElement !== n) n.value = fmt(v);
      row.classList.toggle("changed", p.k in bag(p));
      row.querySelector("td.eq").textContent = p.base ? "= " + fmt(derived(p.base) + v) : "";
      row.title = p.k in bag(p) ? "kit value " + fmt(def(p)) : "";
    });
    el.querySelectorAll("tr[data-o]").forEach(function (row) {
      var o = OK[row.dataset.o], cur = opt(o[0]);
      row.classList.toggle("changed", cur !== o[2][0]);
      row.querySelectorAll("button[data-v]").forEach(function (b) {
        b.classList.toggle("on", b.dataset.v === cur);
        b.classList.toggle("moved", b.dataset.v === cur && cur !== o[2][0]);
      });
    });
    document.querySelectorAll("#tune-guides-t button").forEach(function (b) {
      b.classList.toggle("on", (b.dataset.v === "on") === guides);
    });
    document.querySelectorAll("#tune-theme button").forEach(function (b) {
      b.classList.toggle("on", b.dataset.t === theme());
    });
    var t = tiers();
    document.getElementById("tune-tiers").innerHTML =
      "Page width now " + t.w + " px (without this panel: " + root.clientWidth + " px).<br>" +
      "Map and side notes in the gutters from " + t.rail + " px; below that, contents at the top, the section " +
      "name in the top bar opens the map as a drop-down, notes inline.<br>Hanging section numbers from " + t.hang + " px.<br>Now: <b>" +
      (root.classList.contains("rail") ? "map and notes in gutters" : "no gutters") + "</b>, numbers <b>" +
      (root.classList.contains("hang") ? "hanging" : "inline") + "</b>.";
    document.getElementById("tune-contrast").innerHTML = contrast(theme()).map(function (c) {
      return "<tr><td class=sw style='background:var(" + cssv(c.bg) + ");color:var(" + cssv(c.fg) + ")'>Aa</td><td>" +
        c.text + "</td><td>" + c.on + "</td><td class=r>" + c.ratio.toFixed(2) + "</td><td class=r>" + c.need +
        "</td><td>" + (c.pass ? '<span class="pass">ok</span>' : '<span class="low">low</span>') + "</td><td>" +
        (c.gamut === "out" ? '<span class="low">out</span>' : c.gamut) + "</td></tr>";
    }).join("");
    document.getElementById("tune-steps").innerHTML = steps(theme()).map(function (s) {
      return "<tr><td class=sw style='background:var(" + cssv(s.ra) + ")'></td><td>" + s.a + "</td><td>" + s.b +
        "</td><td class=r>" + s.ratio.toFixed(2) + "</td><td class=r>" + s.floor + "</td><td>" +
        (s.pass ? '<span class="pass">ok</span>' : '<span class="low">low</span>') + "</td><td></td></tr>";
    }).join("");
    document.getElementById("tune-css").value = cssText();
  }

  function isOpen() { return root.classList.contains("tuning"); }
  function toggle() {
    var open = !isOpen();
    root.classList.toggle("tuning", open);
    B.gset("tuner", open ? "open" : "closed");
    B.setPanel(open ? PANEL : 0);
    if (open) { fromStore(); render(); }
    root.classList.toggle("tune-guides", open && guides);
    drawGuides();
  }

  readDefaults();
  fromStore();
  build();
  addEventListener("resize", function () { drawGuides(); render(); });
  window.pageKitTune = { toggle: toggle };
})();
