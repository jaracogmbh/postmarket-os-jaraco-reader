# Contributor: you <you@example.invalid>
# Maintainer: you <you@example.invalid>

pkgname=jaraco-reader
pkgver=0.1.0
pkgrel=7
pkgdesc="Simple EPUB reader for postmarketOS"
url="https://example.invalid/jaraco-reader"
arch="noarch"
license="MIT"
depends="python3 py3-gobject3 gtk+3.0 webkit2gtk-4.1"
makedepends=""
source=""
builddir="$startdir"
options="!check"

package() {
	install -Dm755 "$startdir/app/jaraco-reader" "$pkgdir/usr/bin/jaraco-reader"
	install -Dm644 "$startdir/data/io.jaraco.Reader.desktop" \
		"$pkgdir/usr/share/applications/io.jaraco.Reader.desktop"
	install -Dm644 "$startdir/data/io.jaraco.Reader.appdata.xml" \
		"$pkgdir/usr/share/metainfo/io.jaraco.Reader.appdata.xml"
	install -Dm644 "$startdir/data/io.jaraco.Reader.svg" \
		"$pkgdir/usr/share/icons/hicolor/scalable/apps/io.jaraco.Reader.svg"
}
