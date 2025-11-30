#set page(
  width: 520pt,
  height: 320pt,
  margin: 0pt,
  fill: rgb("#fcf7d5"),
)

#let image-w = 125pt
#let image-h = image-w * 2
#let tile-w = image-w * 0.8
#let tile-h = image-h * 0.2

#let origin-x = 260pt
#let origin-y = 80pt

#let tile-pos = (row, col) => (
  origin-x + (col - row) * tile-w / 2,
  origin-y + (col + row) * tile-h / 2,
)

// Lade alle Objekte
#let tiles = (
  g: image("svg/grass.svg", width: image-w),
  w: image("svg/water.svg", width: image-w),
)

#let objects = (
  h: (img: image("svg/hathi.svg", width: tile-w * 0.75), size: tile-w * 0.75, offset: 0.25),
  b: (img: image("svg/bananas.svg", width: tile-w * 1), size: tile-w * 1, offset: 0),
  t: (img: image("svg/tree.svg", width: tile-w * 1), size: tile-w * 1, offset: 0),
  r: (img: image("svg/rock.svg", width: tile-w * 1), size: tile-w * 1, offset: 0),
  s: (img: image("svg/squash.svg", width: tile-w * 1), size: tile-w * 1, offset: 0),
  l: (img: image("svg/lion_0.svg", width: tile-w * 1.25), size: tile-w * 1.25, offset: 0),
  c: (img: image("svg/crate.svg", width: tile-w * 1.25), size: tile-w * 1.25, offset: 0),
  C: (img: image("svg/crate_closed.svg", width: tile-w * 1.25), size: tile-w * 1.25, offset: 0),
  f: (img: image("svg/flag.svg", width: tile-w * 1.25), size: tile-w * 1.25, offset: 0),
  F: (img: image("svg/flag_hoisted.svg", width: tile-w * 1.25), size: tile-w * 1.25, offset: 0),
)

// Level-Definition
#let level = (
  "hggFw",
  "gCtbw",
  "scgbw",
  "lggrw",
  "wwwww",
)

// Hilfsfunktion: Platziere ein Objekt auf einer Kachel
#let place-on-tile(row, col, obj, obj-width, offset-y: 0pt) = {
  let (cx, cy) = tile-pos(row, col)
  place(top + left, dx: cx - obj-width / 2, dy: cy - obj-width + offset-y, obj)
}

// Rendere das Level
#for (row, line) in level.enumerate() {
  for (col, char) in line.clusters().enumerate() {
    // Platziere Basis-Kachel (g oder w)
    let tile-char = if char in ("l", "h", "b", "t", "r", "s","c","C","f","F") { "g" } else { char }
    if tile-char in tiles {
      let (cx, cy) = tile-pos(row, col)
      place(top + left, dx: cx - image-w / 2, dy: cy - image-h / 2, tiles.at(tile-char))
    }
    
    // Platziere Objekt (h oder b) falls vorhanden
    if char in objects {
      let obj = objects.at(char)
      place-on-tile(row, col, obj.img, obj.size, offset-y: obj.size * obj.offset)
    }
  }
}
