// Hathi World - Isometrisches Kachel-Rendering-Modul
// Version 0.1.0

/// Erstellt eine isometrische Spielwelt aus einem Level-Array.
/// - level: Array von Strings mit Kachel-Codes (z.B. ("ggggh", "gwwwg"))
/// - origin: Ursprungspunkt (x, y) der Welt auf der Seite
/// - scale: Skalierungsfaktor (1.0 = Standard)
/// - tile-size: Basis-Kachelgröße
/// - assets-path: Pfad zu den SVG-Dateien (relativ zum importierenden Dokument)
#let create-world(
  level,
  origin: (260pt, 80pt),
  scale: 1.0,
  tile-size: 25pt,
  assets-path: "svg/",
  banana-value: 9999,
) = {
  // Berechnete Größen
  let image-w = tile-size * scale
  let image-h = image-w * 2
  let tile-w = image-w * 0.8
  let tile-h = image-h * 0.2

  let (origin-x, origin-y) = origin

  // Position einer Kachel berechnen
  let tile-pos = (row, col) => (
    origin-x + (col - row) * tile-w / 2,
    origin-y + (col + row) * tile-h / 2,
  )

  // Lade Basis-Kacheln
  let tiles = (
    g: image(assets-path + "grass.svg", width: image-w),
    w: image(assets-path + "water.svg", width: image-w),
  )

  // Lade Objekte mit Größe und Offset
  let objects = (
    h: (
      img: image(assets-path + "hathi.svg", width: tile-w * 0.75),
      size: tile-w * 0.75,
      offset: 0.25,
    ),
    b: {
      let svg = read(assets-path + "bananas.svg")
      let modified = svg.replace("9999", str(banana-value))
      (
        img: image(bytes(modified), format: "svg", width: tile-w * 1),
        size: tile-w * 1,
        offset: 0,
      )
    },
    t: (
      img: image(assets-path + "tree.svg", width: tile-w * 1),
      size: tile-w * 1,
      offset: 0,
    ),
    r: (
      img: image(assets-path + "rock.svg", width: tile-w * 1),
      size: tile-w * 1,
      offset: 0,
    ),
    s: (
      img: image(assets-path + "squash.svg", width: tile-w * 1),
      size: tile-w * 1,
      offset: 0,
    ),
    l: (
      img: image(assets-path + "lion_0.svg", width: tile-w * 1.25),
      size: tile-w * 1.25,
      offset: 0,
    ),
    c: (
      img: image(assets-path + "crate.svg", width: tile-w * 1.25),
      size: tile-w * 1.25,
      offset: 0,
    ),
    C: (
      img: image(assets-path + "crate_closed.svg", width: tile-w * 1.25),
      size: tile-w * 1.25,
      offset: 0,
    ),
    f: (
      img: image(assets-path + "flag.svg", width: tile-w * 1.25),
      size: tile-w * 1.25,
      offset: 0,
    ),
    F: (
      img: image(assets-path + "flag_hoisted.svg", width: tile-w * 1.25),
      size: tile-w * 1.25,
      offset: 0,
    ),
  )

  // Liste der Objekt-Codes (für automatisches Gras darunter)
  let object-codes = ("l", "h", "b", "t", "r", "s", "c", "C", "f", "F")

  // Hilfsfunktion: Platziere ein Objekt auf einer Kachel
  let place-on-tile(row, col, obj, obj-width, offset-y: 0pt) = {
    let (cx, cy) = tile-pos(row, col)
    place(
      top + left,
      dx: cx - obj-width / 2,
      dy: cy - obj-width + offset-y,
      obj,
    )
  }

  // Rendere das Level
  {
    for (row, line) in level.enumerate() {
      for (col, char) in line.clusters().enumerate() {
        // Platziere Basis-Kachel (g oder w)
        let tile-char = if char in object-codes { "g" } else { char }
        if tile-char in tiles {
          let (cx, cy) = tile-pos(row, col)
          place(
            top + left,
            dx: cx - image-w / 2,
            dy: cy - image-h / 2,
            tiles.at(tile-char),
          )
        }

        // Platziere Objekt falls vorhanden
        if char in objects {
          let obj = objects.at(char)
          place-on-tile(
            row,
            col,
            obj.img,
            obj.size,
            offset-y: obj.size * obj.offset,
          )
        }
      }
    }
  }
}
