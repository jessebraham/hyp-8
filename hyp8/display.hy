"""
Display
http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.4
"""

(require [hy.contrib.walk [let]])

(import [tkinter [Canvas Frame]])


;; Programs may refer to a group of sprites representing the hexadecimal
;; digits 0 through F. These sprites are 5 bytes long, or 8x5 pixels. The data
;; should be stored in the interpreter area of Chip-8 memory (0x000 to 0x1FF).
(setv *font-set* [0xF0 0x90 0x90 0x90 0xF0   ; 0x0
                  0x20 0x60 0x20 0x20 0x70   ; 0x1
                  0xF0 0x10 0xF0 0x80 0xF0   ; 0x2
                  0xF0 0x10 0xF0 0x10 0xF0   ; 0x3
                  0x90 0x90 0xF0 0x10 0x10   ; 0x4
                  0xF0 0x80 0xF0 0x10 0xF0   ; 0x5
                  0xF0 0x80 0xF0 0x90 0xF0   ; 0x6
                  0xF0 0x10 0x20 0x40 0x40   ; 0x7
                  0xF0 0x90 0xF0 0x90 0xF0   ; 0x8
                  0xF0 0x90 0xF0 0x10 0xF0   ; 0x9
                  0xF0 0x90 0xF0 0x90 0x90   ; 0xA
                  0xE0 0x90 0xE0 0x90 0xE0   ; 0xB
                  0xF0 0x80 0x80 0x80 0xF0   ; 0xC
                  0xE0 0x90 0x90 0x90 0xE0   ; 0xD
                  0xF0 0x80 0xF0 0x80 0xF0   ; 0xE
                  0xF0 0x80 0xF0 0x80 0x80]) ; 0xF


(defclass Display []
  """
  Emulate the original display (64x32 monochrome) using a Canvas element.
  Allow for arbitrary scaling of the interface, defaulting to a (sane?) value
  of 10, resulting in a resolution of 640x320.
  """

  (setv *height* 32
        *width*  64)
  (setv gfx [])

  (defn __init__ [self window &optional [scale 10]]
    ;; Initialize the video memory, and store the scale (as we need it pretty
    ;; much whenever we interact with the display).
    (setv self.gfx (* [0] (* self.*height* self.*width*)))
    (setv self.scale scale)
    ;; Create the canvas element within a frame.
    (let [height (* self.*height* scale)
          width  (* self.*width* scale)
          frame  (Frame window)
          canvas (Canvas frame :bg "white" :height height :width width)]
      ;; Both the frame and canvas need to be packed.
      (.pack frame :fill "both" :expand True :padx 5 :pady 5)
      (.pack canvas)
      (setv self.canvas canvas)))

  (defn clear [self]
    (.delete self.canvas "all")))
