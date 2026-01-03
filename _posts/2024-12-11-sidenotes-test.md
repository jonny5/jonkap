---
layout: post
title: Testing Sidenotes
date: 2024-12-11 21:50:00 -0700
section: Meditation
categories: test sidenotes
published: true
---

This is a test post to demonstrate the new sidenote functionality[^1] inspired by gwern.net.

Sidenotes are superior to traditional footnotes[^2] because they allow readers to view additional context without breaking their reading flow. On wide screens, they appear in the margin. On mobile devices, they become interactive popups.

The implementation handles multiple footnotes gracefully[^3], ensuring they don't overlap and remain positioned near their references in the text.

You can hover over a footnote reference to see it highlighted[^4], and the corresponding sidenote in the margin will also highlight. This makes it easy to visually connect references to their notes.

The system is responsive[^5] and adapts to different screen sizes automatically. Try resizing your browser window to see how the footnotes transform between sidenotes and traditional footnotes.

[^1]: Sidenotes are marginal notes that appear alongside the main text, positioned near their references.

[^2]: Traditional footnotes require readers to scroll to the bottom of the page, breaking concentration and flow. Endnotes are even worse, often requiring navigation to a different page entirely.

[^3]: The positioning algorithm ensures adequate spacing between sidenotes, preventing overlap while keeping them as close as possible to their references.

[^4]: This bidirectional highlighting helps readers quickly identify which note corresponds to which reference, especially useful when there are many footnotes.

[^5]: Below 1200px viewport width, sidenotes automatically convert to traditional footnotes or popup displays, ensuring accessibility on all devices.
