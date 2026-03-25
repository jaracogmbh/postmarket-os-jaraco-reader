**Titel: Jaraco Reader – ein mobiler Linux-Reader für Markdown mit Mermaid und EPUB**

Wer auf Linux liest, kennt das Problem: Auf dem Desktop funktionieren viele Markdown- und EPUB-Reader wirklich gut, aber auf mobilen Geräten wird es schnell unbequem. Genau aus diesem Grund haben wir `jaraco-reader` entwickelt.

Die Idee war klar: Ein Reader, der auf postmarketOS sauber läuft, Markdown-Dokumente inklusive Mermaid-Diagrammen rendert und EPUB-Bücher einfach lesbar macht, ohne Desktop-Workflows auf dem Smartphone zu erzwingen.

**Warum dieses Projekt entstanden ist**

Bestehende Reader sind oft auf Desktop-Nutzung optimiert:
- große Fensterlogik statt Touch-first-Bedienung
- unklare Navigation auf kleineren Displays
- schwache Unterstützung für technische Markdown-Inhalte mit Diagrammen

`jaraco-reader` wurde deshalb als pragmatische Mobile-Lösung gebaut. Ziel war nicht ein theoretischer Showcase, sondern ein Tool, mit dem man technische Dokumente und Bücher im Alltag wirklich lesen kann.

Die Kernmotivation in einem Satz:
Dieses Reader-Projekt wurde entwickelt, weil bestehende Markdown- und EPUB-Reader im Desktop-Modus hervorragend funktionieren, auf mobilen Geräten aber nicht so gut. Deshalb haben wir `jaraco-reader` gebaut, um Markdown-Dokumente mit Mermaid-Diagrammen und EPUB-Bücher deutlich einfacher lesen zu können.

**Projektüberblick: Wie `jaraco-reader` arbeitet**

Die Anwendung basiert auf GTK3 + WebKit2GTK 4.1 und nutzt Python als Laufzeit. Dadurch kombiniert sie native App-Steuerung mit robustem HTML/CSS-Rendering.

Was der Reader konkret leistet:
- EPUB-Inhalte werden entpackt, Kapitel zusammengeführt und als durchgehende Leseseite angezeigt.
- Markdown wird zu HTML konvertiert, inklusive fenced code blocks, Tabellen und Inhaltsstruktur.
- Mermaid-Blöcke werden automatisch erkannt und als Diagramme gerendert.
- Bilder und relative Assets werden korrekt aufgelöst.
- Leseposition und Schriftgröße werden pro Buch gespeichert und beim nächsten Öffnen wiederhergestellt.

**Wichtige Funktionen für mobile Nutzung**

Damit der Reader auf einem Smartphone wirklich praktisch ist, wurden bewusst einfache, direkte Interaktionen umgesetzt:
- Edge-Buttons für schnelles Vor/Zurück-Seiten
- Go-to-Page-Dialog für direkten Sprung
- Zoom in/Zoom out für anpassbare Lesbarkeit
- Recent-Liste (bis zu 5 Bücher) beim Start
- Tap auf leere Ansicht öffnet den Datei-Dialog
- stabile Nutzung in Portrait und Landscape

Damit entsteht genau der Unterschied, der bei vielen Desktop-zentrierten Readern fehlt: kurze Wege, klare Touch-Bedienung und verlässliches Verhalten auf kleinen Displays.

**Technischer Kern in Kurzform**

Die Pipeline lässt sich kompakt so beschreiben:

1. Datei öffnen (`.epub`, `.md`, `.markdown`)
2. Inhalt normalisieren (EPUB-Parsing oder Markdown-Rendering)
3. HTML in `WebKit2.WebView` laden
4. Scroll-Position periodisch erfassen und als Fraction speichern
5. Beim Wiederöffnen Position + Zoom reproduzieren

Zusätzlich wird EPUB-Content in `~/.cache/jaraco-reader/` abgelegt, damit Assets lokal sauber verfügbar sind. Zustände wie `recent`, `last_book`, `fraction` und `font_size` landen in `~/.config/jaraco-reader/positions.json`.

**Warum das auf postmarketOS gut passt**

postmarketOS gibt uns ein echtes Alpine-Linux-System auf dem Smartphone. Das bedeutet:
- nachvollziehbare Paketierung mit `APKBUILD` + `abuild`
- direkte Installation und Tests auf dem Gerät
- keine proprietäre Sonderplattform für einen einfachen Reader

`jaraco-reader` bleibt dadurch bewusst nah an klassischer Linux-Entwicklung: transparent, paketierbar und wartbar.

**Fazit**

`jaraco-reader` ist aus einem konkreten Pain Point entstanden: Desktop-Reader sind stark, mobile Lesbarkeit technischer Inhalte ist oft schwach. Mit GTK, WebKit2GTK, Markdown-Rendering und Mermaid-Unterstützung liefert das Projekt genau die Funktionen, die auf mobilen Linux-Geräten fehlen.

Für uns ist das zentrale Ergebnis nicht nur „ein weiterer Reader“, sondern ein praxisnahes Werkzeug, das Markdown-Dokumente mit Diagrammen und EPUB-Bücher auf postmarketOS deutlich einfacher lesbar macht.

**Warum maßgeschneiderte Software wichtig ist**

Viele Anwendungen heute sind sehr generalistisch. Sie decken alles irgendwie ab, machen im Alltag aber oft zu viel auf einmal oder an entscheidenden Stellen zu wenig. Genau daraus entstehen Reibungsverluste: mehr Klicks, mehr Kompromisse, weniger Fokus.

Spezifische Tools, die exakt deinen Workflow unterstützen, sind heute erreichbar. Wenn du vor ähnlichen Problemen stehst und dich fragst, ob es nicht eine passgenauere Lösung gibt: Kontaktiere uns. Wir unterstützen dich gerne.

**Appendix: Relevante Befehle**

- `./app/jaraco-reader /path/to/book.epub`
Startet den Reader direkt mit einer EPUB-Datei.

- `./app/jaraco-reader /path/to/doc.md`
Öffnet ein Markdown-Dokument mit HTML-Rendering und Mermaid-Support.

- `abuild -F`
Baut das APK-Paket aus `APKBUILD`.

- `apk add --allow-untrusted /home/user/packages/projects/aarch64/jaraco-reader-<version>.apk`
Installiert das gebaute Paket auf dem Gerät.
