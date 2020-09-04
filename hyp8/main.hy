(require [hy.contrib.walk [let]])

(import [hyp8.display [Display]])
(import [tkinter [Frame Menu Tk]])


(defclass Window [Frame]
  """
  Define the main application window. This class ties the GUI together with
  the actual emulator and, enables interaction with it in a meaningful way.
  """

  (defn __init__ [self parent]
    (.__init__ Frame self parent)
    (setv self.parent parent)
    (.init-window self)
    (.init-menubar self)
    (.init-emulator self))

  (defn init-window [self]
    (.title self.parent "Hyp-8")
    (.resizable self.parent False False)
    (.pack self))

  (defn init-menubar [self]
    (setv self.menubar (Menu self.parent))
    (.config self.parent :menu self.menubar)
    ;; TODO: add `:command` for remaining menu items
    (.create-menu self "File" ["Open" None]
                              ["Exit" exit])
    (.create-menu self "Edit" ["Reset"    None]
                              ["Settings" None])
    (.create-menu self "Help" ["About" None]))

  (defn create-menu [self menu-label &rest children]
    (let [menu (Menu self.menubar :tearoff False)]
      (for [[label command] children]
        (.add-command menu :label label :command command))
      (.add-cascade self.menubar :label menu-label :menu menu)))

  (defn init-emulator [self]
    (setv self.display (Display self))))


(defmain [&rest args]
  (let [root   (Tk)
        window (Window root)]
    (.mainloop root)))