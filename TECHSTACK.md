# Tech Stack

## Runtime

- **Python 3**: Main application logic.
- **PyGObject (py3-gobject3)**: GObject introspection bindings for GTK and WebKit.
- **GTK 3**: Application UI framework.
- **WebKit2GTK 4.1**: HTML/CSS renderer for EPUB content.
- **Adwaita Icon Theme**: Standard system icons.

## Packaging

- **APKBUILD**: Alpine package recipe used by `abuild`.
- **abuild / alpine-sdk**: Tooling for building APKs on device.

## Storage

- **User config**: `~/.config/jaraco-reader/positions.json`
- **Cache**: `~/.cache/jaraco-reader/` (extracted EPUB contents)

## UI Components

- **Gtk.ApplicationWindow** with **Gtk.Overlay**
- **Gtk.HeaderBar** with icon buttons
- **WebKit2.WebView** for reading view
- **Gtk.Dialog** for open/recent and go-to-page

## Key Behaviors

- Reading position saved as scroll fraction and restored on reopen.
- Recent books list stored in positions JSON (max 5).
- Tap/click on empty view opens the book selector.
