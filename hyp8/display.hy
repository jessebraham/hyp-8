(require [hy.contrib.walk [let]])

(import [tkinter [Canvas Frame]])


(defclass Display []
  """
  http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.4

  The original Chip-8 implementation used a monochrome display with a
  resolution of 64x32. The position (0, 0) is in the top-left corner of the
  display.

  Chip-8 draws graphics through the use of sprites. A sprite is a group of
  bytes which are a binary representation of the desired picture. Chip-8
  sprites may be up to 15 bytes, for a possible sprite size of 8x15. Sprites
  are XORed onto the screen.

  Programs may also refer to a group of sprites representing the hexadecimal
  digits 0 through F. These sprites are 5 bytes long, or 8x5 pixels. The data
  should be stored in the interpreter area of Chip-8 memory (0x000 to 0x1FF).
  """

  (setv *height* 32
        *width*  64)
  (setv gfx [])

  (setv *font-set* [[0xF0 0x90 0x90 0x90 0xF0]   ; 0x0
                    [0x20 0x60 0x20 0x20 0x70]   ; 0x1
                    [0xF0 0x10 0xF0 0x80 0xF0]   ; 0x2
                    [0xF0 0x10 0xF0 0x10 0xF0]   ; 0x3
                    [0x90 0x90 0xF0 0x10 0x10]   ; 0x4
                    [0xF0 0x80 0xF0 0x10 0xF0]   ; 0x5
                    [0xF0 0x80 0xF0 0x90 0xF0]   ; 0x6
                    [0xF0 0x10 0x20 0x40 0x40]   ; 0x7
                    [0xF0 0x90 0xF0 0x90 0xF0]   ; 0x8
                    [0xF0 0x90 0xF0 0x10 0xF0]   ; 0x9
                    [0xF0 0x90 0xF0 0x90 0x90]   ; 0xA
                    [0xE0 0x90 0xE0 0x90 0xE0]   ; 0xB
                    [0xF0 0x80 0x80 0x80 0xF0]   ; 0xC
                    [0xE0 0x90 0x90 0x90 0xE0]   ; 0xD
                    [0xF0 0x80 0xF0 0x80 0xF0]   ; 0xE
                    [0xF0 0x80 0xF0 0x80 0x80]]) ; 0xF

  (defn __init__ [self window &optional [scale 10]]
    (let [height (* self.*height* scale)
          width  (* self.*width*  scale)
          frame  (Frame window)
          canvas (Canvas frame :bg "white" :height height :width width)]
      (setv self.canvas canvas)
      (setv self.scale scale)
      (._reset-memory self)
      ;; Both the frame and canvas need to be packed.
      (.pack frame :fill "both" :expand True :padx 5 :pady 5)
      (.pack canvas)))

  (defn clear [self]
    (._reset-memory self)
    (.draw self))

  (defn draw [self]
    (lfor
      y (range self.*height*)
      x (range self.*width*)
      (let [enabled (get self.gfx (+ (* y self.*width*) x))]
        (._set-pixel self x y enabled))))

  (defn render-sprite [self sprite x y]
    (for [[i byte] (enumerate sprite)]
      (._render-byte self byte x (+ y i))))

  (defn _reset-memory [self]
    (setv self.gfx (* [0] (* self.*height* self.*width*))))

  (defn _set-pixel [self x y enabled]
    (let [offset 2 ; why is this offset required? who the fuck knows!
          fill   (if enabled "white" "black")
          x0     (+ (* self.scale x) offset)
          y0     (+ (* self.scale y) offset)
          x1     (+ x0 self.scale)
          y1     (+ y0 self.scale)]
      (.create-rectangle self.canvas x0 y0 x1 y1 :fill fill :outline "")))

  (defn _render-byte [self byte x y]
    (lfor i (range 4) ; only read the top nybble
      (let [shift   (- 7 i)
            bit     (& (>> byte shift) 1)
            enabled (int (= bit 1))]
        (._xor-pixel self enabled (+ x i) y))))

  (defn _xor-pixel [self pixel x y]
    (let [i       (+ (* y self.*width*) x)
          current (get self.gfx i)]
      (setv (get self.gfx i) (int (xor current pixel))))))
