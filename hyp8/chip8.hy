"""
Chip-8 Emulation
http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.0
"""

(require [hy.contrib.walk [let]])

(import [hyp8.display [Display]])
(import [hyp8.keyboard [Keyboard]])


(defclass Chip8 []
  """
  TODO: document me
  """

  (setv *memory-size*  4096
        *bottom-addr*  0x000
        *top-addr*     0xFFF
        *program-addr* 0x200
        *eti-addr*     0x600)
  (setv memory [])

  (setv *num-gp-regs* 16)
  (setv V  []
        I  0
        pc *program-addr*
        sp 0
        delay_timer 0
        sound_timer 0)

  (setv *stack-size* 16)
  (setv stack [])

  (setv draw-flag False)

  (defn __init__ [self window]
    ;; Initialize the various emulation modules and reset the internal state
    ;; of the emulated device.
    (setv self.display (Display window))
    (setv self.keyboard (Keyboard window.root))
    (.reset self))

  (defn reset [self]
    ;; Reset the memory, stack, registers, and timers.
    (setv self.memory (* [0] self.*memory-size*))
    (setv self.stack (* [0] self.*stack-size*))
    (._init-registers self)
    (._init-timers self)
    ;; Load the font set into memory.
    (let [flatten (fn [l] (reduce + l))]
      (._load-bytes self self.*bottom-addr* (flatten self.display.*font-set*)))
    ;; Reset the draw flag and clear the display.
    (setv self.draw-flag False)
    (.clear self.display))

  (defn load-program [self program]
    (._load-bytes self self.*program-addr* program))

  (defn _init-registers [self]
    (setv self.V  (* [0] self.*num-gp-regs*))
    (setv self.I  0)
    (setv self.pc self.*program-addr*)
    (setv self.sp 0))

  (defn _init-timers [self]
    (setv self.delay_timer 0)
    (setv self.sound_timer 0))

  (defn _load-bytes [self start-addr bytes]
    (for [[i byte] (enumerate bytes)]
      (setv (get self.memory (+ i start-addr)) byte))))
