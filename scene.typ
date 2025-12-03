#import "hathi_world.typ": create-world

#set page(
  fill: rgb("#fcf7d5"),
)

// Level 1: Hauptszene
#let level1 = (
  "gtggtggttgtg",
  "hggggggggggg",
  "gwwwwwwwwwwg",
  "gTTTTTTTTTTg",
  "gbbbbbbbbbbg",
)

// Level 2: Mini-Szene
#let level2 = (
  "gtg",
  "grg",
  "ggg",
)

// Level 3: Noch eine Szene
#let level3 = (
  "ggg",
  "glg",
  "gFg",
)

// Platziere mehrere Welten auf der Seite
#create-world(level1, origin: (150pt, 60pt), scale: 1.0, banana-value: 1)
#create-world(level2, origin: (400pt, 40pt), scale: 0.8)
#create-world(level3, origin: (450pt, 180pt), scale: 0.7)
