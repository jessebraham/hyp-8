"""
Keyboard
http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.3
"""

(defclass Keyboard []
  """
  The computers which originally used the Chip-8 Language had a 16-key
  hexadecimal keypad. The original keypad layout and the corresponding
  keyboard layour can be found below:

    keypad        keyboard
    ----------------------
    1 2 3 C        1 2 3 4
    4 5 6 D        Q W E R
    7 8 9 E        A S D F
    A 0 B F        Z X C V
  """

  (setv *num-keys* 16)
  (setv key-states [])

  ;; Maps from a keyboard character to the corresponding hex keypad digit.
  ;; Eventually I would like for this to be configurable by the user.
  (setv *keymap* {"1" 0x1  "2" 0x2  "3" 0x3  "4" 0xC
                  "q" 0x4  "w" 0x5  "e" 0x6  "r" 0xD
                  "a" 0x7  "s" 0x8  "d" 0x9  "f" 0xE
                  "z" 0xA  "x" 0x0  "c" 0xB  "v" 0xF})

  (defn __init__ [self root]
    """
    Initialize the key states, which are represented by boolean values
    indicating if a particular key is currently pressed. Additionally set up
    the key-related event handlers.
    """
    (setv self.key-states (* [False] self.*num-keys*))
    ;; Forcing `char` to lowercase ensures this will continue to work when
    ;; caps lock is enabled.
    (.bind root "<Key>" (fn [e] (.press self (.lower e.char))))
    (.bind root "<KeyRelease>" (fn [e] (.release self (.lower e.char)))))

  (defn presssed? [self key]
    (if* (in key self.*keymap*)
      (get self.key-states (get self.*keymap* key))
      False))

  (defn press [self key]
    (._set-key self key True))

  (defn release [self key]
    (._set-key self key False))

  (defn _set-key [self key state]
    (if (in key self.*keymap*)
      (setv (get self.key-states (get self.*keymap* key)) state))))
