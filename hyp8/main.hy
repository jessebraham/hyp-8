(require [hy.contrib.walk [let]])

(import [hyp8.chip8 [Chip8]])
(import [tkinter [filedialog messagebox Frame Menu Tk]])


(defclass Window [Frame]
  """
  Define the main application window. This class ties the GUI together with
  the actual emulator and enables interaction with it in a meaningful way.

  Handles loading ROMs from the filesystem, then loading their bytes into the
  emulated device memory.
  """

  (defn __init__ [self root]
    (.__init__ Frame self root)
    (setv self.root root)
    (.init-window self)
    (.init-menubar self)
    (setv self.chip8 (Chip8 self)))

  (defn init-window [self]
    (.title self.root "Hyp-8")
    (.resizable self.root False False)
    (.pack self))

  (defn init-menubar [self]
    (setv self.menubar (Menu self.root))
    (.config self.root :menu self.menubar)
    ;; TODO: add `:command` for remaining menu items
    (.create-menu self "File" ["Open" self.open-file-dialog]
                              ["Exit" exit])
    (.create-menu self "Edit" ["Reset"    None]
                              ["Settings" None])
    (.create-menu self "Help" ["About" None]))

  (defn create-menu [self menu-label &rest children]
    (let [menu (Menu self.menubar :tearoff False)]
      (for [[label command] children]
        (.add-command menu :label label :command command))
      (.add-cascade self.menubar :label menu-label :menu menu)))

  (defn open-file-dialog [self]
    (let [filetypes [["Chip-8 Programs" "*.ch8"]]
          file      (.askopenfilename filedialog :filetypes filetypes)]
      (when file
        (.load-rom self file))))

  (defn load-rom [self file]
    (.reset self.chip8)
    (try
      (with [f (open file "rb")]
        (.load-program self.chip8 (.read f)))
        (.game-loop self)
      (except [e Exception]
        (.showerror messagebox :title "Error" :message (str e)))))

  (defn game-loop [self]
    (let [fps   30
          delta (int (* (/ 1 fps) 1000))]
      (.cycle self.chip8)
      (.after self.root delta self.game-loop))))


(defmain [&rest args]
  (let [root   (Tk)
        window (Window root)]
    (.mainloop root)))
