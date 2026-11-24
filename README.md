# Folio — Attention Is All You Need

A clean academic reader for using the real LexiSnap app and taking screenshots.

## Paper

**Attention Is All You Need**, Vaswani et al., Advances in Neural Information Processing Systems 30 (2017).

- Official conference PDF (11 pages): https://papers.nips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf
- Official arXiv HTML version: https://arxiv.org/html/1706.03762v7
- Paper record: https://arxiv.org/abs/1706.03762

The reader embeds the conference PDF directly from the proceedings site. It does not copy or rehost the paper, and it does not claim a CC BY license for the paper. The arXiv version is linked separately because it can differ from the conference edition. Authors: Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Łukasz Kaiser, and Illia Polosukhin.

## Use

Open `index.html` in a browser. An internet connection to the official paper host is required.

- Select text in the PDF and use your usual LexiSnap shortcut or gesture.
- If your browser's PDF viewer does not work with the app, **Read as HTML** opens the official selectable HTML article.
- **Focus** hides the reader's sidebar and toolbar. Hover over the top-right corner to reveal **Exit focus**. Escape also exits when keyboard focus is in the outer reader; keys inside the cross-origin PDF viewer are handled by that viewer.
- The page menu requests a jump to a page; it does not track manual scrolling within the PDF.
- The zoom menu and PDF toolbar suppression use browser PDF URL parameters. Their support varies by browser.
- Bookmarks persist only in your current browser. No analytics, external scripts, or simulated definition window.
- `?focus=1` opens directly in screenshot mode. `?page=2&zoom=125&focus=1` additionally requests page 2 and 125% zoom.

The browser must permit inline PDFs and reach the proceedings website. Direct PDF and HTML links remain available if the embed is blocked. The page shell is responsive, but the PDF retains the publisher's fixed page layout.

## Publish to GitHub Pages

Run `bash publish.sh` in this directory from your own Mac terminal.

The script uses existing `gh` authentication to clone `Max-Hongzhen2026/reader` into a temporary directory, commit the four reader files, push normally without force, and configure GitHub Pages to use the default branch's root. Other repository files are preserved. No credentials are printed or copied. The temporary checkout is removed on exit.

The script verifies that the live HTML matches the local file before reporting success. A timeout means the source was uploaded but publication has not been verified; inspect the repository's Actions page.

Target repository: https://github.com/Max-Hongzhen2026/reader

Expected URL after successful publication: https://max-hongzhen2026.github.io/reader/

## Validation

The HTML IDs and fragment links, JavaScript syntax, and publishing script syntax were checked locally. Browser rendering, PDF embedding and LexiSnap interoperability need to be confirmed in the user's browser; the execution environment does not allow the local preview server.
