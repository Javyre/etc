// brief.js: shared behavior for a brief page set. Classic script, no
// dependencies, works on file://. Every feature is optional: the pages read
// fine with this file missing.
//
// Browser storage holds only per-reader conveniences. Theme, tuning and the
// tuning panel state are shared by every page that uses the kit (key prefix
// "brief:"); scroll position and pages read belong to one set (prefix
// "brief:<set dir>"), since file:// pages in one browser share one origin.

(function () {
  var root = document.documentElement;
  var dir = location.pathname.replace(/[^/]*$/, "");
  var page = location.pathname.slice(dir.length) || "index.html";
  var base = (document.currentScript && document.currentScript.src || "").replace(/[^/]*$/, "");
  var panelW = 0;

  function get(k) { try { return localStorage.getItem("brief:" + dir + k); } catch (e) { return null; } }
  function set(k, v) { try { localStorage.setItem("brief:" + dir + k, v); } catch (e) {} }
  function gget(k) { try { return localStorage.getItem("brief:" + k); } catch (e) { return null; } }
  function gset(k, v) { try { localStorage.setItem("brief:" + k, v); } catch (e) {} }

  // ---- theme: auto -> light -> dark -> auto. Applied before first paint.
  var theme = gget("theme");
  if (theme === "light" || theme === "dark") root.setAttribute("data-theme", theme);
  var dark = matchMedia("(prefers-color-scheme: dark)");
  function effectiveTheme() {
    return root.getAttribute("data-theme") || (dark.matches ? "dark" : "light");
  }
  function setTheme(t) {
    if (t === "light" || t === "dark") root.setAttribute("data-theme", t); else root.removeAttribute("data-theme");
    gset("theme", t || "auto");
    applyTune();
    var btn = document.querySelector(".theme-toggle");
    if (btn) themeLabel(btn);
  }
  function themeLabel(btn) {
    var t = root.getAttribute("data-theme");
    btn.textContent = t === "light" ? "Light" : t === "dark" ? "Dark" : "Auto";
  }

  // ---- tuning: overrides saved by the tuning panel, applied to every page
  // of the set. Shape: { light: {var: value}, dark: {…}, both: {…},
  // o: {option: value} }. Values are CSS strings, units included.
  var applied = [];
  function loadTune() {
    try { var s = JSON.parse(gget("tune")); if (s) return s; } catch (e) {}
    return { light: {}, dark: {}, both: {}, o: {} };
  }
  function applyTune() {
    var s = loadTune(), t = effectiveTheme();
    applied.forEach(function (k) { root.style.removeProperty("--" + k); });
    applied = [];
    [s.both || {}, s[t] || {}].forEach(function (b) {
      Object.keys(b).forEach(function (k) { root.style.setProperty("--" + k, b[k]); applied.push(k); });
    });
    Array.prototype.slice.call(root.attributes).forEach(function (a) {
      if (a.name.indexOf("data-o-") === 0) root.removeAttribute(a.name);
    });
    Object.keys(s.o || {}).forEach(function (k) { root.setAttribute("data-o-" + k, s.o[k]); });
    layout();
  }
  dark.addEventListener("change", applyTune);

  // ---- layout tiers, from the rule in brief.css:
  // html.rail when gutter >= rail + 2 * rail-gap; html.hang when
  // gutter >= hang. The tuning panel, when open, takes panelW from the page.
  function px(name) {
    var v = getComputedStyle(root).getPropertyValue(name).trim();
    var n = parseFloat(v);
    return /rem$/.test(v) ? n * parseFloat(getComputedStyle(root).fontSize) : n;
  }
  function layout() {
    var w = root.clientWidth - panelW;
    root.style.setProperty("--page-w", w + "px");
    var gutter = (w - px("--col")) / 2;
    root.classList.toggle("rail", gutter >= px("--rail") + 2 * px("--rail-gap"));
    root.classList.toggle("hang", gutter >= px("--hang"));
  }
  applyTune();
  addEventListener("resize", layout);

  // ---- tuning panel: brief-tune.js, next to this file, loaded on demand.
  function toggleTuner() {
    if (window.briefTune) { window.briefTune.toggle(); return; }
    var s = document.createElement("script");
    s.src = base + "brief-tune.js";
    s.onload = function () { window.briefTune.toggle(); };
    document.head.appendChild(s);
  }

  window.brief = {
    get: get, set: set, loadTune: loadTune, applyTune: applyTune,
    saveTune: function (s) { gset("tune", JSON.stringify(s)); applyTune(); },
    gget: gget, gset: gset,
    layout: layout, effectiveTheme: effectiveTheme, setTheme: setTheme,
    setPanel: function (w) { panelW = w; layout(); },
    toggleTuner: toggleTuner
  };

  function initChrome() {
    var bar = document.querySelector(".topbar");
    if (!bar) return;
    // Current section name, between the set link and the position.
    if (!bar.querySelector(".cur")) {
      var cur = document.createElement("span");
      cur.className = "cur";
      bar.insertBefore(cur, bar.children[1] || null);
    }
    var btn = bar.querySelector(".theme-toggle");
    if (btn) {
      themeLabel(btn);
      btn.addEventListener("click", function () {
        var t = root.getAttribute("data-theme");
        setTheme(!t ? "light" : t === "light" ? "dark" : null);
      });
      var tb = document.createElement("button");
      tb.className = "tune-toggle"; tb.type = "button"; tb.textContent = "Tune";
      tb.title = "Tuning panel (,)";
      tb.addEventListener("click", toggleTuner);
      btn.parentNode.insertBefore(tb, btn);
    }
  }

  // ---- scroll: resume, the "read" mark, the current section (map marker,
  // top bar name, focus option).
  function initScroll() {
    var main = document.querySelector("main");
    var pager = document.querySelector(".pager");
    var curName = document.querySelector(".topbar .cur");
    var saved = +get("y:" + page);
    // Resume only unfinished pages; a finished page reopens at the top.
    if (!location.hash && saved > 0 && !get("done:" + page)) window.scrollTo(0, saved);

    // Map links in document order, each with its target heading.
    var map = [];
    var links = document.querySelectorAll('nav.toc a[href^="#"]');
    for (var i = 0; i < links.length; i++) {
      var h = document.getElementById(decodeURIComponent(links[i].hash.slice(1)));
      if (h) map.push([links[i], h]);
    }
    // Section index of each child of main: -1 before the first h2.
    var kids = main ? Array.prototype.slice.call(main.children) : [];
    var sec = [], n = -1;
    kids.forEach(function (el) { if (el.tagName === "H2") n++; sec.push(n); });
    var heads = kids.filter(function (el) { return el.tagName === "H2"; });
    // Heading text without its section number.
    function titleOf(h) {
      return Array.prototype.map.call(h.childNodes, function (c) {
        return c.classList && c.classList.contains("n") ? "" : c.textContent;
      }).join("").trim();
    }

    var current = null, pending = false;
    function update() {
      pending = false;
      set("y:" + page, String(Math.round(scrollY)));
      if (pager && pager.getBoundingClientRect().top < innerHeight) set("done:" + page, "1");

      // Current = last heading above the top third of the viewport.
      var next = null, idx = -1;
      for (var j = 0; j < map.length; j++) {
        if (map[j][1].getBoundingClientRect().top < innerHeight / 3) next = map[j][0];
      }
      for (var k = 0; k < heads.length; k++) {
        if (heads[k].getBoundingClientRect().top < innerHeight / 3) idx = k;
      }
      if (next !== current) {
        if (current) current.classList.remove("current");
        if (next) next.classList.add("current");
        current = next;
      }
      if (curName) curName.textContent = idx >= 0 ? titleOf(heads[idx]) : "";
      var focus = root.getAttribute("data-o-focus") === "section" && idx >= 0;
      for (var m = 0; m < kids.length; m++) {
        var chrome = kids[m] === pager || kids[m].matches(".topbar, nav.toc");
        kids[m].classList.toggle("dim", focus && !chrome && sec[m] !== idx);
      }
    }
    addEventListener("scroll", function () {
      if (!pending) { pending = true; requestAnimationFrame(update); }
    }, { passive: true });
    window.brief.refresh = update;
    update();
  }

  function initIndexMarks() {
    var links = document.querySelectorAll(".cards a[href]");
    for (var i = 0; i < links.length; i++) {
      var href = links[i].getAttribute("href").split("#")[0];
      if (get("done:" + href)) links[i].classList.add("done");
    }
  }

  // Keys: left/right follow the pager; "," opens the tuning panel. Only when
  // nothing else wants the keys.
  function initKeys() {
    addEventListener("keydown", function (e) {
      if (e.altKey || e.ctrlKey || e.metaKey) return;
      var a = document.activeElement;
      if (a && a !== document.body && a.tagName !== "A" && a.tagName !== "BUTTON") return;
      if (e.key === ",") { toggleTuner(); return; }
      if (e.shiftKey) return;
      var sel = e.key === "ArrowLeft" ? ".pager a:not(.next)" : e.key === "ArrowRight" ? ".pager a.next" : null;
      var link = sel && document.querySelector(sel);
      if (link) location.href = link.href;
    });
  }

  // Section numbers become their own permalinks.
  // Keep authored content inside the column: every table scrolls in its own
  // wrapper, and every SVG scales from a viewBox.
  function initContent() {
    var tables = document.querySelectorAll("main table");
    for (var i = 0; i < tables.length; i++) {
      var t = tables[i];
      if (t.parentNode.classList.contains("table-wrap")) continue;
      var w = document.createElement("div");
      w.className = "table-wrap";
      t.parentNode.insertBefore(w, t);
      w.appendChild(t);
    }
    var svgs = document.querySelectorAll("main svg");
    for (var j = 0; j < svgs.length; j++) {
      var s = svgs[j], vw = parseFloat(s.getAttribute("width")), vh = parseFloat(s.getAttribute("height"));
      if (!s.getAttribute("viewBox") && vw && vh) s.setAttribute("viewBox", "0 0 " + vw + " " + vh);
      if (s.getAttribute("viewBox")) { s.removeAttribute("width"); s.removeAttribute("height"); }
      s.classList.add("fig");
    }
  }

  function initAnchors() {
    var hs = document.querySelectorAll("h2[id] > span.n");
    for (var i = 0; i < hs.length; i++) {
      var a = document.createElement("a");
      a.className = "n"; a.href = "#" + hs[i].parentNode.id;
      a.textContent = hs[i].textContent;
      hs[i].replaceWith(a);
    }
  }

  // Reading time: appended to the first .meta line, 230 words per minute,
  // code counted at half weight.
  function initReadTime() {
    var meta = document.querySelector(".meta");
    var main = document.querySelector("main");
    if (!meta || !main || meta.querySelector(".rt")) return;
    var codeWords = 0;
    var pres = main.querySelectorAll("pre");
    for (var i = 0; i < pres.length; i++) codeWords += pres[i].textContent.split(/\s+/).length;
    var words = main.textContent.split(/\s+/).length - codeWords + codeWords / 2;
    var s = document.createElement("span");
    s.className = "rt";
    s.textContent = " · " + Math.max(1, Math.round(words / 230)) + " min read";
    meta.appendChild(s);
  }

  document.addEventListener("DOMContentLoaded", function () {
    layout();
    initChrome(); initContent(); initAnchors(); initReadTime(); initIndexMarks(); initKeys(); initScroll();
    if (gget("tuner") === "open" || location.hash === "#tune") toggleTuner();
  });
})();

// Minimal syntax highlighting for code blocks.
//
// It wraps tokens in text nodes only, so existing markup (<mark>, <a>, trace
// and diff spans) survives. Trace spans (.c .k .w .b .o .add .del) are left
// untouched. Blocks opt out with class "plain" or "trace"; a block outside an
// excerpt whose first child is span.k is treated as a trace too.
//
// Language comes from data-lang on the <pre>, else from the file extension of
// the excerpt's source link, else from a guess.
(function () {
  var KW = {
    rust: "as async await break const continue crate dyn else enum extern false fn for if impl in let loop match mod move mut pub ref return self Self static struct super trait true type unsafe use where while None Some Ok Err",
    c: "auto break case char const continue default do double else enum extern float for goto if inline int long register return short signed sizeof static struct switch typedef union unsigned void volatile while bool true false NULL nullptr class namespace template typename public private protected virtual override fn pub var comptime defer errdefer try orelse catch",
    js: "async await break case catch class const continue default delete do else export extends false finally for from function if import in instanceof interface let new null of return static super switch this throw true try type typeof undefined var void while yield readonly enum implements as",
    go: "break case chan const continue default defer else fallthrough for func go goto if import interface map package range return select struct switch type var nil true false",
    hash: "if then else elif fi for do done in case esac export local return function while until"
  };
  var EXT = {
    rs: "rust", c: "c", h: "c", cc: "c", cpp: "c", hpp: "c", zig: "c",
    js: "js", mjs: "js", ts: "js", tsx: "js", jsx: "js",
    go: "go", sh: "hash", bash: "hash", fish: "hash", toml: "hash", nix: "hash",
    yml: "hash", yaml: "hash", typ: "hash", py: "hash", json: "json", md: null, css: null, html: null, txt: null
  };
  var TRACE = /(^|\s)(c|k|w|b|o|add|del|t-[a-z])(\s|$)/;

  function langOf(pre) {
    if (pre.dataset.lang) return pre.dataset.lang === "none" ? null : pre.dataset.lang;
    var fig = pre.closest("figure.excerpt");
    var a = fig && fig.querySelector("figcaption a");
    if (a) {
      var m = a.getAttribute("href").split(/[?#]/)[0].match(/\.([a-z]+)$/);
      if (m && m[1] in EXT) return EXT[m[1]];
    }
    var t = pre.textContent.replace(/^\s+/, "");
    if (/^(\$ |curl |# |jq |for |export )/.test(t) || /\bjq\b/.test(t)) return "hash";
    if (/^[{\[]"?/.test(t)) return "json";
    if (/\b(fn|impl|let mut|pub struct)\b/.test(t)) return "rust";
    if (/\b(function|const|=>|interface)\b/.test(t)) return "js";
    return "c";
  }

  function build(lang) {
    var kws = (KW[lang] || KW.c).split(" ").join("|");
    var comment = lang === "hash" ? "(#(?![!\\[])[^\\n]*)" : lang === "json" ? "(\\u0000)" : "(\\/\\/[^\\n]*)";
    var parts = [
      comment,                                                        // 1 comment
      "(\"(?:[^\"\\\\\\n]|\\\\.)*\"?|'(?:[^'\\\\\\n]|\\\\.){2,}'|`[^`]*`)", // 2 string
      "(#!?\\[[^\\]\\n]*\\]?|@[A-Za-z_]+)",                           // 3 attribute
      "(\\b0x[0-9a-fA-F_]+\\b|\\b\\d[\\d_]*(?:\\.\\d+)?(?:[eE]\\d+)?(?:[ui](?:8|16|32|64|128|size)|f32|f64)?\\b)", // 4 number
      lang === "rust" ? "(\\b[a-z_][a-z0-9_]*!)" : "(\\u0000)",        // 5 macro
      "(\\b[A-Z][A-Za-z0-9_]*[a-z][A-Za-z0-9_]*\\b|\\b(?:[ui](?:8|16|32|64|128|size)|f32|f64|bool|str|char|string|number)\\b)", // 6 type
      "(\\b(?:" + kws + ")\\b)"                                       // 7 keyword
    ];
    return new RegExp(parts.join("|"), "g");
  }
  var CLS = [null, "t-c", "t-s", "t-m", "t-n", "t-m", "t-t", "t-k"];

  function span(cls, text) {
    var s = document.createElement("span");
    s.className = cls; s.textContent = text; return s;
  }

  function highlightText(node, re, lang, st) {
    var text = node.nodeValue, out = document.createDocumentFragment(), i = 0;
    // Continue a comment or string that began in an earlier text node.
    if (st.open) {
      var end = st.open === "t-c" ? text.indexOf("\n") : text.search(/(^|[^\\])"/);
      if (end < 0) { out.appendChild(span(st.open, text)); node.parentNode.replaceChild(out, node); return; }
      if (st.open === "t-s") end += text[end] === '"' ? 1 : 2;
      if (end > 0) out.appendChild(span(st.open, text.slice(0, end)));
      i = end; st.open = null;
    }
    re.lastIndex = i;
    var m;
    while ((m = re.exec(text))) {
      var g = 1; while (g < m.length && m[g] === undefined) g++;
      if (g === 1 && lang === "hash" && m.index > 0 && !/\s/.test(text[m.index - 1])) { re.lastIndex = m.index + 1; continue; }
      if (lang === "json" && (g === 3 || g === 6 || g === 7)) { re.lastIndex = m.index + 1; continue; }
      if (m.index > i) out.appendChild(document.createTextNode(text.slice(i, m.index)));
      out.appendChild(span(CLS[g], m[0]));
      i = m.index + m[0].length;
      if (i === text.length) {
        if (g === 1) st.open = "t-c";
        if (g === 2 && m[0][0] === '"' && (m[0].length === 1 || m[0].slice(-1) !== '"')) st.open = "t-s";
      }
    }
    if (i === 0 && !out.childNodes.length) return;
    if (i < text.length) out.appendChild(document.createTextNode(text.slice(i)));
    node.parentNode.replaceChild(out, node);
  }

  function walk(el, re, lang, st) {
    var kids = Array.prototype.slice.call(el.childNodes);
    for (var j = 0; j < kids.length; j++) {
      var n = kids[j];
      if (n.nodeType === 3) highlightText(n, re, lang, st);
      else if (n.nodeType === 1) {
        if (n.tagName === "SPAN" && TRACE.test(n.className)) { st.open = null; continue; }
        walk(n, re, lang, st);
      }
    }
  }

  document.addEventListener("DOMContentLoaded", function () {
    var pres = document.querySelectorAll("pre");
    for (var k = 0; k < pres.length; k++) {
      var pre = pres[k];
      if (pre.classList.contains("plain") || pre.classList.contains("trace")) continue;
      var first = pre.firstElementChild;
      if (!pre.closest("figure.excerpt") && first && first === pre.firstChild && first.matches("span.k")) continue;
      var lang = langOf(pre);
      if (!lang) continue;
      try { walk(pre, build(lang), lang, { open: null }); } catch (e) {}
    }
  });
})();
