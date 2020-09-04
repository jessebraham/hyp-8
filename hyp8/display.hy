"""
Display
http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.4
"""

(require [hy.contrib.walk [let]])

(import [tkinter [Canvas Frame]])


(defclass Display []
  """
  Emulate the original display (64x32 monochrome) using a Canvas element.
  Allow for arbitrary scaling of the interface, defaulting to a (sane?) value
  of 10, resulting in a resolution of 640x320.
  """

  (setv *height* 32)
  (setv *width* 64)
  
  (defn __init__ [self parent &optional [scale 10]]
    ;; We need the scale pretty much whenever we interact with the display.
    (setv self.scale scale)
    (let [height (* self.*height* scale)
          width  (* self.*width* scale)
          frame  (Frame parent)
          canvas (Canvas frame :bg "white" :height height :width width)]
      ;; Both the frame and canvas need to be packed.
      (.pack frame :fill "both" :expand True :padx 5 :pady 5)
      (.pack canvas)
      (setv self.canvas canvas)))

  (defn clear [self]
    (.delete self.canvas "all")))
