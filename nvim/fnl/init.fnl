(module init
    {require {util util
              a    aniseed.core
              nvim aniseed.nvim
              nu   aniseed.nvim.util
              str  aniseed.string
              paq  paq-nvim}
     require-macros [macros]})

; (macro map* [mode opts binds]
;  (let [util (gensym)
;        binds (icollect [from to (pairs binds)]
;                `((. ,util :map) ,mode ,from ,to ,opts))]
;    `(let [,util (require :util)]
;      ,(values (unpack binds)))))

; (defn map* [mode opts binds]
;   "Set multiple bindings"
;   (each [from to (pairs binds)]
;     (util.map mode from to opts)))
(time

;; Nvim
(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")
(util.map :i :<M-Space> :<Leader>)

(a.assoc nvim.o
  :mouse      :a
  :timeout    false ;; don't timeout on key sequences
  :incsearch  true  ;; search while typing
  :hlsearch   true  ;; highlight search
  :gdefault   true  ;; global substitution by default (no need for /g flag)
  :splitbelow true  ;; open below instead of above
  :diffopt          ;; smarter diff
  (.. (or nvim.o.diffopt "") ",indent-heuristic,algorithm:histogram")
  :clipboard :unnamedplus
  :fillchars "fold: ,diff: "
  :inccommand :split
  :termguicolors true
  :foldlevelstart 99)

(a.assoc nvim.wo
  :colorcolumn :+1 ;; highlight column at textwidth+1
  :conceallevel 2
  :concealcursor :vn)


(defn set-indent [indent?]
  (let [indent (or indent? 4)]
    (a.assoc nvim.bo 
      :expandtab   true
      :shiftwidth  indent
      :tabstop     indent
      :softtabstop indent)))

(util.augroup :jv_buffer_setup
  [[:FileType "*" #(do (set-indent 4)
                       (a.assoc nvim.bo
                         :textwidth 80
                         :infercase true ;; infer case in search
                         :modeline true))]])

(util.map :n :<Leader>fs ":w")

;; Should-be-default
(use [:farmergreg/vim-lastplace
      :tpope/vim-repeat
      :tpope/vim-commentary
      :tpope/vim-unimpaired
      :junegunn/vim-easy-align
      :troydm/zoomwintab.vim
      :kana/vim-textobj-user
      :sgur/vim-textobj-parameter]
     (util.noremap :n "<M-;>" ":Commentary")
     (util.map     :v "<M-;>" :gcgv)

     (util.map     :n :<Leader>wm ":ZoomWinTabToggle")

     (util.map     :x :ga "<Plug>(EasyAlign)")
     (util.map     :n :ga "<Plug>(EasyAlign)")
     (set nvim.g.vim_textobj_parameter_mapping :a))

;; Missing syntax
(use [:sheerun/vim-polyglot
      :HarnoRanaivo/vim-mipssyntax])

;; Tree-Sitter (kinda slow: ~2ms)
(use (:nvim-treesitter/nvim-treesitter {:run (fn [] (nvim.ex.TSUpdate))})
     (local tree-sitter (require :nvim-treesitter.configs))
     (tree-sitter.setup 
         {:ensure_installed :all
          :ignore_install {}
          :highlight {:enable true
                      :disable {}}
          :incremental_selection {:enable true
                                  :keymaps {:init_selection "gnn"
                                            :node_incremental "grn"
                                            :scope_incremental "grc"
                                            :node_decremental "grm"}}
          :indent {:enable true}})
     (set nvim.wo.foldmethod :expr)
     (set nvim.wo.foldexpr "nvim_treesitter#foldexpr()"))

(defonce- *lsp-attach-hook* {})
;; LSP (using builtin)
(use [:neovim/nvim-lspconfig
      :kabouzeid/nvim-lspinstall
      :hrsh7th/vim-vsnip
      :hrsh7th/nvim-compe
      :RishabhRD/popfix]
     (defn- on-lsp-attach [client bufnr]
         ;; Mappings.
         (local opts {:noremap true :silent true :buffer bufnr})
         (map*
           :n opts
           {:gD    #(vim.lsp.buf.declaration)
            :gd    #(vim.lsp.buf.definition)
            :gr    #(vim.lsp.buf.references)
            :K     #(vim.lsp.buf.hover)
            :gi    #(vim.lsp.buf.implementation)
            :<C-k> #(vim.lsp.buf.signature_help)
            "[d" #(vim.lsp.diagnostic.goto_prev)
            "]d" #(vim.lsp.diagnostic.goto_next)
            :<LocalLeader>wa #(vim.lsp.buf.add_workspace_folder)
            :<LocalLeader>wr #(vim.lsp.buf.remove_workspace_folder)
            :<LocalLeader>wl #(a.pr (vim.lsp.buf.list_workspace_folders))
            :<LocalLeader>D  #(vim.lsp.buf.type_definition)
            :<LocalLeader>lr #(vim.lsp.buf.rename)
            :<LocalLeader>la #(vim.lsp.buf.code_action)
            :<LocalLeader>le #(vim.lsp.diagnostic.show_line_diagnostics)
            :<LocalLeader>lq #(vim.lsp.diagnostic.set_loclist)})

         ;; Set some keybinds conditional on server capabilities
         (if client.resolved_capabilities.document_formatting
           (util.map :n :<LocalLeader>lf #(vim.lsp.buf.formatting) opts))
         (if client.resolved_capabilities.document_range_formatting
           (util.map :v :<LocalLeader>lf #(vim.lsp.buf.range_formatting) opts))

         ;; Set autocommands conditional on server_capabilities
         (if client.resolved_capabilities.document_highlight
           (vim.api.nvim_exec
             "hi def link LspReferenceText CursorLine
             hi def link LspReferenceWrite CursorLine
             hi def link LspReferenceRead CursorLine

             augroup lsp_document_highlight
               autocmd! * <buffer>
               autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
               autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
             augroup END" false))
         
         (util.run-hook *lsp-attach-hook* client bufnr))

     ;; We have to initialize lsp-install to access the installed server configs
     ;; in lspconfig.
     (set util.*lsp-defer-pre*
       #(let [lsp-install (require :lspinstall)]
         (lsp-install.setup)))

     (util.defer-lsp-setup
       :jdtls ["java"]
       {:on_attach on-lsp-attach
        :cmd ["jdtls"]
        :root_dir #(let [lsp-config (require :lspconfig)]
                     (or ((lsp-config.util.root_pattern
                            "gradle.build" ".project" ".git") $1)
                         (vim.fn.getcwd)))})

     (util.defer-lsp-setup
       :cpp ["c" "cpp" "objc" "objcpp"]
       {:on_attach on-lsp-attach})

     ;; TODO: check back on https://github.com/hrsh7th/nvim-compe/issues/220
     ;; for startup performance improvements
     (let [compe (require :compe)]
       (compe.setup {:source {:path true
                              :buffer true
                              :calc true
                              :nvim_lsp true
                              :nvim_lua true
                              :vsnip true}}))

     (let [opts {:silent true :expr true :noremap true}]
         (map* 
             :i opts
             {:<C-Space> "compe#complete()"
              :<CR>      "compe#confirm('<CR>')"
              :<C-e>     "compe#close('<C-e>')"
              :<C-f>     "compe#scroll({ 'delta': +4 })"
              :<C-d>     "compe#scroll({ 'delta': -4 })"})))

;; Fennel
(use [(:Olical/conjure {:opt true})
      :Olical/fennel.vim]
     (util.augroup :jv_lazy_conjure
       [[:FileType "fennel"
         #(do (nvim.ex.packadd :conjure)
              ((. (require :conjure.mapping) :on-filetype)))]])
     (a.assoc nvim.g 
              :conjure#client#fennel#aniseed#aniseed_module_prefix
              "aniseed."))

;; Aniseed compile on file save
(util.augroup :jv_aniseed_compile_on_save
  [[:BufWritePost "~/*/*vim/*.fnl" #(let [e (require :aniseed.env)]
                                        (e.init))]])

(time
;; Color
(time
(use :norcalli/nvim-colorizer.lua
     (defn- toggle-attach-colorizer [attach?]
       (let [attach? (if (a.nil? attach?)
                         (not nvim.b.jv-colorizer-attached)
                         attach?)]
           (let [c (require :colorizer)]
             (c.setup)))))
)
(use :tomasr/molokai
     (nvim.ex.colorscheme :molokai)
     (nvim.ex.hi "Normal ctermbg=None guibg=None"))

(use :itchyny/lightline.vim
     (nu.fn-bridge :JvBufname :init :bufname)
     (defn bufname [] 
       (let [this (nvim.get_current_buf)
             this-name (nvim.fn.bufname this)]
         (if (str.blank? this-name)
           "[No Name]"
           (let [others (nvim.list_bufs)
                 components (nvim.fn.split this-name "/\\zs")]
             (var name (table.remove components))
             (a.run!
                 (fn [other] 
                     (if (and (not= other this)
                              (nvim.buf_is_valid other)
                              (a.get-in nvim.bo [other :buflisted] nil))
                         (let [other-name (nvim.fn.bufname other)]
                             (while (and (not= "" (nvim.fn.matchstr
                                                      other-name
                                                      (.. name "$")))
                                         (> (length components) 0))
                                 (set name (.. (table.remove components) name))))))
                 others)
             name))))

     (set nvim.g.lightline 
          {:colorscheme :molokai
           :active {:left  [[:mode :paste] [:readonly :filename :modified]]
                    :right [[] [:lineinfo] [:branch :filetype]]}
           :inactive {:left  [[:filename]]
                      :right [[] [:lineinfo]]}
           :component {:filename "%{JvBufname()}"
                       :branch "%{FugitiveHead()}"}}))
)

;; Util
(use [:tpope/vim-fugitive
      :rbong/vim-flog]
     (map* :n {}
        {:<Leader>gs ":tab Git"
         :<Leader>gl ":Flog -all -format=[%h]\\ (%ar)\\ %s%d\\ {%an}"}))
(use :lambdalisue/fern.vim
     (util.noremap :n :<Leader>tt ":Fern . -drawer -toggle -reveal=%"))

;; Tmux
(use :christoomey/vim-tmux-navigator
     (set nvim.g.tmux_navigator_no_mappings 1)
     (map*
         "" {:noremap true}
         {:<A-h> ":TmuxNavigateLeft"
          :<A-j> ":TmuxNavigateDown"
          :<A-k> ":TmuxNavigateUp"
          :<A-l> ":TmuxNavigateRight"})
     (map*
         :t {:noremap true}
         {:<A-h> :<C-\><C-n><Cmd>TmuxNavigateLeft<CR>
          :<A-j> :<C-\><C-n><Cmd>TmuxNavigateDown<CR>
          :<A-k> :<C-\><C-n><Cmd>TmuxNavigateUp<CR>
          :<A-l> :<C-\><C-n><Cmd>TmuxNavigateRight<CR>}))

;; Telescope
(use [:nvim-lua/popup.nvim
      :nvim-lua/plenary.nvim
      :nvim-telescope/telescope.nvim
      (:nvim-telescope/telescope-fzy-native.nvim 
          {:run "git submodule update --init --recursive"})]

     (let [; tele (require :telescope)
           builtin (lazy-require :telescope.builtin)
           dd #((. (require :telescope.themes) :get_dropdown) $...)]
       ;; The extension should be lazy loaded by telescope... hopefully
       ; (tele.load_extension :fzy_native)
       (map* 
           :n {:noremap true}
           {:<Leader>ff      #(builtin.find_files (dd))
                             ;; #(let-mod [b :telescope.builtin]
                             ;;   (b.find_files (dd)))
            :<Leader>fF      #(builtin.file_browser (dd))
            :<Leader>pf      #(builtin.git_files  (dd))
            :<Leader>ss      #(builtin.current_buffer_fuzzy_find (dd))
            :<Leader>ps      #(builtin.live_grep  (dd))
            :<Leader>bb      #(builtin.buffers    (dd {:show_all_buffers true}))
            :<Leader><Space> #(builtin.commands   (dd))
            :<Leader>hh      #(builtin.help_tags)
            :<Leader>hk      #(builtin.keymaps (dd))
            :<Leader>gb      #(builtin.git_branches (dd))})
       
       (util.add-hook
         *lsp-attach-hook*
         #(do
            (print "hook")
            (map*
                :n {:noremap true :silent true :buffer $2}
                {:gd                 #(builtin.lsp_definitions (dd))
                 :gr                 #(builtin.lsp_references (dd))
                 :<LocalLeader>ls    #(builtin.lsp_document_symbols (dd))
                 :<LocalLeader>lS    #(builtin.lsp_workspace_symbols (dd))
                 :<LocalLeader>la    #(builtin.lsp_code_actions (dd))
                 :<LocalLeader>le    #(builtin.lsp_document_diagnostics (dd))
                 :<LocalLeader>lE    #(builtin.lsp_workspace_diagnostics (dd))})
            (util.map
                :v :<LocalLeader>la    
                #(builtin.lsp_range_code_actions (dd))
                {:noremap true :silent true :buffer $2})))))

)
*module*
