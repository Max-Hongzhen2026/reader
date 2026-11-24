# Folio — LexiSnap academic reader

A clean white English reading page with a paper switcher, real selectable text, font controls, an example highlight, per-paper bookmarks, and Focus mode.

## Default paper — full inline HTML

Pastötter B and Bäuml K-HT (2014). **Retrieval practice enhances new learning: the forward effect of testing.** Frontiers in Psychology 5:286.

- DOI: https://doi.org/10.3389/fpsyg.2014.00286
- Source and license: https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2014.00286/full
- Copyright: © 2014 Pastötter and Bäuml. Creative Commons Attribution (CC BY), as stated in the original publication.

The complete abstract, main text, acknowledgments, conflict statement, and 53 references are included as selectable HTML. No network request is needed to display the article. Author, publication, source, and license attribution appear on the page. Layout, paragraph breaks, navigation and highlighting are adapted; the Introduction heading is editorial. The article wording is retained. This paper does not endorse LexiSnap.

## Second paper — Attention Is All You Need

Use the top paper selector to switch to **Attention Is All You Need** (Vaswani et al., 2017).

- Read the official HTML: https://arxiv.org/html/1706.03762v7
- Download a personal PDF: https://arxiv.org/pdf/1706.03762
- Record: https://arxiv.org/abs/1706.03762

Choose the downloaded PDF in the reader. It opens from a browser-local blob URL, not an external embedded website. The file is never uploaded or saved to the repository. It stays open when switching between papers within the same tab; choose it again after refreshing. PDF rendering, text selection, and zoom use your browser's built-in viewer and may vary by browser. If needed, open the PDF separately or use the official HTML link.

No copy of this paper is bundled or publicly rehosted. It is not labeled CC BY. Authors: Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Łukasz Kaiser, and Illia Polosukhin.

## Screenshots

1. Read the default article or switch papers using the top selector.
2. Select a word and use the actual LexiSnap app to display its real definition window.
3. Click **Focus** to hide the sidebar and toolbar. Hover over the top-right corner to reveal **Exit focus**. Escape also works when focus is in the HTML reader; keys inside the PDF viewer are handled by the viewer.

The marker button toggles **elaborative** in the default paper's introduction. The reader does not intercept text selection or copy events, and does not simulate a LexiSnap popup.

Useful URLs:

- Default article: `/reader/`
- Clean introduction: `/reader/?focus=1#introduction`
- Attention paper mode: `/reader/?paper=attention`

Font size, highlighting and bookmarks are saved locally in the browser. No analytics, third-party JavaScript, remote fonts, or automatically loaded remote iframes.

## Publish

Run `bash publish.sh` from this directory in your own terminal. It uses your existing GitHub CLI authentication, commits the four reader files to `Max-Hongzhen2026/reader` without force pushing, preserves other repository files, configures GitHub Pages, and verifies that the live HTML matches this file. It never prints or copies credentials.

Expected URL: https://max-hongzhen2026.github.io/reader/

The publication script must run in an environment that can reach GitHub and access your existing gh login.

## Validation

Checked HTML IDs and links, complete references, both selector options, absence of active remote iframes, and JavaScript/shell syntax. Browser visual verification and LexiSnap interoperability remain unverified because this execution environment blocks the local preview server.
