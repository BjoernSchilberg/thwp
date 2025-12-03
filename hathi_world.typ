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
  origin: none,
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

  // Level-Dimensionen für automatische Positionierung
  let rows = level.len()
  let cols = level.fold(0, (max, line) => calc.max(max, line.clusters().len()))
  let obj-overhang = image-h * 0.0625 // Puffer für hohe Objekte (Bäume, Flaggen)
  let world-width = (rows + cols) * tile-w / 2 + tile-w * 0.5
  let world-height = (rows + cols) * tile-h / 2 + image-h + obj-overhang

  // Origin berechnen (intern bei none, sonst extern)
  let (origin-x, origin-y) = if origin == none {
    (world-width / 2, rows * tile-h / 2 + obj-overhang)
  } else {
    origin
  }

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
    T: (
      img: image(assets-path + "tomato.svg", width: tile-w * 0.35),
      size: tile-w * 0.3,
      offset: 0,
    ),
  )

  // Liste der Objekt-Codes (für automatisches Gras darunter)
  let object-codes = ("l", "h", "b", "t", "r", "s", "c", "C", "f", "F","T")

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
  let render-content = {
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

  // Bei automatischer Positionierung in Box wrappen, sonst direkt rendern
  if origin == none {
    box(width: world-width, height: world-height, render-content)
  } else {
    render-content
  }
}
