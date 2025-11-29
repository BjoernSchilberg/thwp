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

#let grass = image("svg/grass.svg", width: image-w)
#let elephant-size = tile-w * 0.75
#let elephant = image("svg/hathi.svg", width: elephant-size)

// Platziere alle Gras-Kacheln
#for row in range(0, 5) {
  for col in range(0, 5) {
    let (cx, cy) = tile-pos(row, col)
    place(top + left, dx: cx - image-w / 2, dy: cy - image-h / 2, grass)
  }
}

// Platziere den Elefanten
#let (ex, ey) = tile-pos(0, 0)
#place(top + left, dx: ex - elephant-size * 0.5, dy: ey - elephant-size * 0.75, elephant)
