(module util
  {require {a       aniseed.core
            nvim    aniseed.nvim
            nu      aniseed.nvim.util}})

;; Keymap

(defonce *targ-fns* {})

(defn- escape-vim-keys [s]
  (s:gsub "<" "<lt>"))

(defn- func-to-cmd [f ident]
  (match (type f)
    :function (let [ident (match (type ident)
                            :function (ident)
                            _ ident)]
                (a.assoc *targ-fns* ident f)
                (string.format "lua require'%s'['*targ-fns*']['%s']()"
                               *module-name* ident))
    :string   f))

(defn- func-to-keys [f mode from bufnr buffer-local] 
  (match (type f)
    :function (let [ident (string.format 
                            "%s-%s-%s"
                            (if buffer-local (string.format "b-%s" bufnr) :g)
                            mode from)]
                (.. ":" (escape-vim-keys (func-to-cmd f ident))))
    :string   f))

(defn- wrap-cmd [s]
  (match (s:sub 1 1)
    ":" (string.format "<Cmd>%s<CR>" (s:sub 2 -1))
    _   s))

(defn map [mode from to opts]
  "Sets a global mapping with opts.
  
  TO can be a string mapping or a lua function"
  (let [bufnr (a.get opts :buffer)
        buffer-local (= (type bufnr) :number)
        to (-> to
               (func-to-keys mode from bufnr buffer-local)
               (wrap-cmd))]
    (if buffer-local
      (nvim.buf_set_keymap
        bufnr mode from to (a.assoc (vim.deepcopy opts) :buffer nil))
      (nvim.set_keymap
        mode from to (or opts {})))))

(defn noremap [mode from to opts]
  "Sets a global mapping with {:noremap true}."
  (let [opts (a.assoc (or (vim.deepcopy opts) {}) :noremap true)]
    (map mode from to opts)))

(defn map* [mode opts binds]
  "Set multiple bindings"
  (each [from to (pairs binds)]
    (map mode from to opts)))

(defn augroup [name ...]
  (nvim.ex.augroup name)
  (nvim.ex.autocmd!)
  (each [_ [event pat cmd] (ipairs ...)]
    (let [cmd (func-to-cmd cmd #(.. name event pat))]
      (nvim.ex.autocmd event pat cmd)))
  (nvim.ex.augroup :END))
