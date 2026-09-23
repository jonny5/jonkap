// The play page's three calls -- puzzle, check, reveal -- answered from files
// instead of the studio server. rebus-export.js copies this next to a copy of
// play.html and loads it first; play.html picks it up as window.RebusStatic.
//
// What the page gets is exactly what /api/puzzle would have sent, so nothing
// in play.html changes. What is different is where the answers live: each
// exported puzzle carries, per blank, a list of SHA-256 hashes of every tap
// sequence check() would accept (rebus-game.js acceptedTaps), and the reveal
// as base64. That is light obfuscation, not security -- the same trade-off a
// static Wordle made -- and the reason the export keeps the public and
// private halves separate is so a hosted version can keep the private half
// on a server without touching this file's contract.
(function () {
  const base = location.pathname.replace(/[^/]*$/, "");
  let index = null;   // { dates: {date: id}, ids: [id] }
  let puzzle = null;  // the loaded puzzle, private half included

  const load = async (url) => {
    const r = await fetch(url, { cache: "no-store" });
    if (!r.ok) throw new Error(r.status + " " + url);
    return r.json();
  };
  const today = () => new Date().toISOString().slice(0, 10);
  const canon = (taps) => (taps || []).map((t) => (t.op === "-" ? "-" : "+") + String(t.word || "").toUpperCase()).join("");
  async function sha256(text) {
    const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
    return [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, "0")).join("");
  }
  const dated = () => Object.keys(index.dates).sort();
  const neighbours = (date) => {
    if (!date) return { prev: null, next: null };
    const list = dated();
    const before = list.filter((d) => d < date), after = list.filter((d) => d > date);
    return { prev: before.length ? before[before.length - 1] : null, next: after.length ? after[0] : null };
  };
  const numberOf = (date) => (date ? dated().indexOf(date) + 1 || null : null);

  window.RebusStatic = {
    // q is "?id=..." or "?date=..." or "", as play.html builds it.
    async puzzle(q) {
      index = index || await load(base + "puzzles/index.json");
      const p = new URLSearchParams(q);
      const wantId = p.get("id");
      const date = wantId ? null : p.get("date") || today();
      const id = wantId || index.dates[date];
      if (!id || !index.ids.includes(id)) {
        const nav = neighbours(date);
        return { date, id: wantId, empty: true, prev: nav.prev, next: nav.next, total: dated().length };
      }
      puzzle = await load(base + "puzzles/" + encodeURIComponent(id) + ".json");
      const nav = neighbours(puzzle.date);
      // publicPuzzle's shape, with the private half stripped before the page sees it
      const { private: _priv, privateWords: _words, ...pub } = puzzle;
      return { ...pub, number: numberOf(puzzle.date), prev: nav.prev, next: nav.next };
    },
    async check(body) {
      const blank = puzzle && puzzle.private && (puzzle.private[body.round] || [])[body.blank || 0];
      if (!blank) return { ok: false, error: "no such round" };
      const taps = (body.tiles || []).filter((t) => t && t.word);
      if (!taps.length || taps[0].op === "-") return { ok: true, correct: false, heard: "" };
      const pool = new Set([...puzzle.pool.icons.map((i) => i.word), ...puzzle.pool.texts]);
      if (taps.some((t) => !pool.has(String(t.word).toUpperCase()))) return { ok: false, error: "tile not in pool" };
      const h = await sha256(canon(taps));
      if (blank.accept.includes(h)) {
        const r = JSON.parse(atob(blank.reveal));
        return { ok: true, correct: true, similarity: 1, word: r.word, heard: "" };
      }
      return { ok: true, correct: false, similarity: 0, heard: "" };
    },
    async reveal(body) {
      if (body.at != null) {
        const enc = puzzle && puzzle.privateWords && (puzzle.privateWords[body.round] || {})[body.at];
        return enc ? { ok: true, word: JSON.parse(atob(enc)) } : { ok: false, error: "not a drawn word" };
      }
      const blank = puzzle && puzzle.private && (puzzle.private[body.round] || [])[body.blank || 0];
      if (!blank) return { ok: false, error: "no such round" };
      const r = JSON.parse(atob(blank.reveal));
      return { ok: true, answer: r.answer, word: r.word };
    },
  };
})();
