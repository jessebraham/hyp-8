"""
Chip-8 Emulation
http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.0
"""

(require [hy.contrib.walk [let]])

(import [hyp8.display [*font-set* Display]])
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
    ;; Initialize the various emulation modules.
    (setv self.display (Display window))
    (setv self.keyboard (Keyboard window.root))
    ;; Reset the internal state of the emulated device.
    (.reset self))

  (defn reset [self]
    ;; Reset the memory and stack.
    (setv self.memory (* [0] self.*memory-size*))
    (setv self.stack (* [0] self.*stack-size*))
    ;; Reset the registers and timers.
    (.init-registers self)
    (.init-timers self)
    ;; Reset the draw flag and clear the display. Load the font set into
    ;; memory.
    (setv self.draw-flag False)
    (.clear self.display)
    (.load-bytes self self.*bottom-addr* *font-set*))

  (defn init-registers [self]
    (setv self.V  (* [0] self.*num-gp-regs*))
    (setv self.I  0)
    (setv self.pc 0)
    (setv self.sp 0))

  (defn init-timers [self]
    (setv self.delay_timer 0)
    (setv self.sound_timer 0))

  (defn load-program [self program]
    (.load-bytes self self.*program-addr* program))

  (defn load-bytes [self start-addr bytes]
    (for [[i byte] (enumerate bytes)]
      (setv (get self.memory (+ i start-addr)) byte))))
