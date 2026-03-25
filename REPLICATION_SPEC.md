# Jaraco Reader Replication Spec

## 1. Objective

Replicate `jaraco-reader`, a GTK-based mobile-friendly reader for postmarketOS/Alpine Linux that:
- Opens `.epub`, `.md`, and `.markdown` files.
- Renders EPUB and Markdown content in a WebKit view.
- Supports Mermaid diagrams in Markdown documents.
- Preserves reading position and font size per book.
- Provides touch-friendly navigation for mobile devices.

## 2. Scope

In scope:
- Single-process Python application (`app/jaraco-reader`).
- GTK3 + WebKit2GTK UI.
- EPUB parsing + extraction to cache.
- Markdown-to-HTML rendering with Mermaid integration.
- Local state persistence (`positions.json`).
- Alpine APK packaging via `APKBUILD`.
- Desktop integration (`.desktop`, appdata, icon, post-install defaults).

Out of scope:
- Cloud sync.
- Annotation/highlight features.
- DRM-protected EPUB support.
- Network content fetching.

## 3. Target Environment

- OS: postmarketOS (preferred) or Alpine Linux.
- Runtime:
  - `python3`
  - `py3-gobject3`
  - `py3-markdown`
  - `gtk+3.0`
  - `webkit2gtk-4.1`
  - `adwaita-icon-theme`
- Build tooling:
  - `abuild`
  - `alpine-sdk`

Install prerequisites:

```bash
apk add abuild alpine-sdk python3 py3-gobject3 py3-markdown gtk+3.0 webkit2gtk-4.1 adwaita-icon-theme
```

## 4. Source Layout

Required files and purpose:
- `app/jaraco-reader`: Main executable Python app.
- `data/mermaid.min.js`: Bundled Mermaid runtime loaded by Markdown renderer.
- `data/io.jaraco.Reader.desktop`: Desktop launcher + MIME registration.
- `data/io.jaraco.Reader.appdata.xml`: Software metadata.
- `data/io.jaraco.Reader.svg`: App icon.
- `APKBUILD`: Alpine packaging recipe.
- `jaraco-reader.post-install`: Post-install MIME defaults hook.

### 4.1 Mermaid JS Download Instructions

`jaraco-reader` expects Mermaid at `data/mermaid.min.js` during build, which is then installed to:

- `/usr/share/jaraco-reader/mermaid.min.js`

Recommended source:
- jsDelivr CDN (Mermaid v10 distribution):
  - `https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js`

Download command (run from repository root):

```bash
curl -L -o data/mermaid.min.js "https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"
```

Optional verification:

```bash
ls -lh data/mermaid.min.js
```

Notes:
- Keep the filename exactly `mermaid.min.js`.
- If this file is missing, Markdown still opens, but Mermaid diagrams will not render.

## 5. Functional Requirements

### 5.1 File Open and Rendering

- Accept optional CLI path argument.
- If no file is provided:
  - Attempt to open last-read book.
  - Else show prompt with recent books and browse option.
- `.epub`:
  - Read `META-INF/container.xml`, find OPF rootfile.
  - Parse manifest/spine.
  - Extract archive to cache directory.
  - Merge chapter bodies into a single HTML document.
  - Resolve relative links/images to `file://` absolute paths.
- `.md` / `.markdown`:
  - Convert Markdown to HTML with extensions:
    - `fenced_code`
    - `tables`
    - `toc`
    - `sane_lists`
  - Convert mermaid fenced blocks to `<div class="mermaid">...`.
  - Inject Mermaid JS (`/usr/share/jaraco-reader/mermaid.min.js`) if present.

### 5.2 Reading UX

- Header controls:
  - Open file
  - Zoom out
  - Zoom in
  - Go to page
- Overlay edge buttons:
  - Previous page
  - Next page
- Page scroll movement per action: `~0.9 * viewport height`.
- Click/tap behavior:
  - Empty state click opens file prompt.

### 5.3 Persistence

- Config path: `~/.config/jaraco-reader/positions.json`.
- Cache path: `~/.cache/jaraco-reader/`.
- Persist per book:
  - `fraction` (scroll position ratio)
  - `font_size`
- Persist global:
  - `_last_book`
  - `_recent` (max 5 entries)
- Restore `fraction` and `font_size` on reopen.

## 6. Non-Functional Requirements

- Mobile-friendly interaction on small screens.
- No network dependency for rendering Mermaid (local JS file).
- Works in portrait and landscape.
- Robust against malformed EPUB files (fail gracefully with visible error in title area).

## 7. Implementation Notes

- GI versions:
  - `Gtk` = `3.0`
  - `WebKit2` = `4.1`
  - `Gdk` = `3.0`
- Keep JavaScript enabled in WebKit settings.
- Poll scroll state on timer (~1000ms) and debounce config writes (~500ms).
- Use atomic config writes (`tmp` + `os.replace`).
- Use SHA-256(path) prefix as EPUB extraction directory key.

## 8. Packaging Requirements (APK)

`APKBUILD` must:
- Install executable to `/usr/bin/jaraco-reader`.
- Install desktop file to `/usr/share/applications/io.jaraco.Reader.desktop`.
- Install appdata to `/usr/share/metainfo/io.jaraco.Reader.appdata.xml`.
- Install icon to `/usr/share/icons/hicolor/scalable/apps/io.jaraco.Reader.svg`.
- Install Mermaid JS to `/usr/share/jaraco-reader/mermaid.min.js`.
- Declare runtime dependencies listed in section 3.

Post-install (`jaraco-reader.post-install`) must:
- Register default app for:
  - `application/epub+zip`
  - `text/markdown`
  - `text/x-markdown`
- Run `update-desktop-database` when available.

## 9. Build and Install Procedure

Build:

```bash
abuild -F
```

Expected package output path:

```text
/home/user/packages/projects/aarch64/
```

Install:

```bash
apk add --allow-untrusted /home/user/packages/projects/aarch64/jaraco-reader-<version>-r<rel>.apk
```

Run:

```bash
jaraco-reader /path/to/book.epub
jaraco-reader /path/to/doc.md
```

## 10. Verification Checklist

1. Open EPUB with images; confirm content renders end-to-end.
2. Open Markdown with Mermaid fenced block; confirm diagram renders.
3. Change zoom, close app, reopen same file; confirm zoom restored.
4. Scroll mid-document, close/reopen; confirm position restored.
5. Open >5 files over time; confirm recent list is capped to 5.
6. Test page jump + edge navigation controls.
7. Start without argument; confirm recent/browse startup dialog behavior.
8. Confirm app is available from launcher and opens associated `.epub`/`.md`.

## 11. Acceptance Criteria

Replication is successful when:
- All functional requirements in section 5 pass.
- Packaging and installation steps in section 9 produce installable APK.
- Verification checklist in section 10 passes on target device.
