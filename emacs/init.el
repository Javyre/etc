;; -*- lexical-binding: t; -*-
(require 'cl-lib)
(require 'xdg)

;; ============================================================================
;; strait.el

(setq straight-check-for-modifications '(check-on-save find-when-checking))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;; ============================================================================
;; modeline
(use-package emacs
  :after (all-the-icons)
  :init
  (defun jv/mode-line-align (left right)
    "Return a string of `window-width' length containing LEFT, and RIGHT aligned respectively."
    (let* ((available-width (- (window-total-width)
                               (+ (length (format-mode-line left))
                                  (length (format-mode-line right)))))
           (padding (format (format "%%%ds" available-width) "")))

      `(,left ,padding ,right)))

  (defun jv/color-multiply (color mult)
    "multiply the values of a color"
    (if (= mult 1.0) color
      (let ((values (x-color-values color)))
	(format "#%02x%02x%02x"
		(min (/ (* (car values)   255 mult) 65535) 255)
		(min (/ (* (cadr values)  255 mult) 65535) 255)
		(min (/ (* (caddr values) 255 mult) 65535) 255)))))

  (defvar jv/selected-window nil)
  (defun jv/update-selected-window (_windows)
    (when (not (minibuffer-window-active-p (frame-selected-window)))
      (setq jv/selected-window (selected-window))))

  (add-function :before pre-redisplay-function #'jv/update-selected-window)

  (defun jv/color-luminance (color)
    (let ((values (x-color-values color)))
      (/ (floor (+ (* (car values)   .3)
		   (* (cadr values)  .59)
		   (* (caddr values) .11))
		256)
	 255.0)))

  (defun jv/current-theme-dark-p ()
    (let ((lum (jv/color-luminance (face-attribute 'default :background))))
      (< lum 0.5)))

  (defvar jv/modeline-colors-alist nil)
  (defun jv/generate-modeline-colors ()
    ;; TODO: find other reliable source for colors or find out how to require only
    ;; the colors not the package
    (require 'term)
    (setq jv/modeline-colors-alist
          `((green   . ,(face-attribute 'term-color-green   :background))
            (red     . ,(face-attribute 'term-color-red     :background))
            (blue    . ,(face-attribute 'term-color-blue    :background))
            (yellow  . ,(face-attribute 'term-color-yellow  :background))
            (magenta . ,(face-attribute 'term-color-magenta :background))
            (black   . ,(face-attribute 'term-color-black   :background))
            (white   . ,(face-attribute 'term-color-white   :background)))))

  (defun jv/mode-line-evil-state ()
    (let* ((state evil-mode-line-tag)
	   (sel (eq jv/selected-window (get-buffer-window)))
	   (unsel-bg (face-attribute 'mode-line-inactive :background))
	   (unsel-fg (face-attribute 'mode-line-inactive :foreground))
	   (green   (if sel (alist-get 'green   jv/modeline-colors-alist) unsel-bg))
	   (red     (if sel (alist-get 'red     jv/modeline-colors-alist) unsel-bg))
	   (blue    (if sel (alist-get 'blue    jv/modeline-colors-alist) unsel-bg))
	   (yellow  (if sel (alist-get 'yellow  jv/modeline-colors-alist) unsel-bg))
	   (magenta (if sel (alist-get 'magenta jv/modeline-colors-alist) unsel-bg))
	   (black   (if sel (alist-get 'black   jv/modeline-colors-alist) unsel-fg))
	   (white   (if sel (alist-get 'white   jv/modeline-colors-alist) unsel-fg))
	   (common  `(:weight bold :foreground ,white)))
      (cond
       ((string= state " <E> ")
	(propertize " EMACS " 'face `(,@common :background ,yellow :foreground ,black)))
       ((string= state " <N> ")
	(propertize " NORMAL " 'face `(,@common :background ,blue)))
       ((string= state " <V> ")
	(propertize " VISUAL " 'face `(,@common :background ,magenta)))
       ((string= state " <Vl> ")
	(propertize " V-LINE " 'face `(,@common :background ,magenta)))
       ((string= state " <Vb> ")
	(propertize " V-BLCK " 'face `(,@common :background ,magenta)))
       ((string= state " <I> ")
	(propertize " INSERT " 'face `(,@common :background ,green :foreground ,black)))
       ((string= state " <R> ")
	(propertize " REPLAC " 'face `(,@common :background ,red)))
       ((string= state " <M> ")
	(propertize " MOTION " 'face `(,@common :background ,yellow :foreground ,black)))
       ((string= state " <O> ")
	(propertize " OBJECT " 'face `(,@common :background ,magenta)))
       ((string= state " <ME> ")
        (let ((iedit (if sel (face-attribute 'iedit-occurrence :foreground) unsel-bg)))
          (propertize " IEDIT " 'face `(,@common :background ,iedit :foreground ,black))))
       ((string= state " <MEi> ")
        (let ((iedit (if sel (face-attribute 'iedit-occurrence :foreground) unsel-bg)))
          (propertize " INSERT " 'face `(,@common :background ,iedit :foreground ,black))))
       (t state))))

  (jv/generate-modeline-colors)
  (setq-default
   mode-line-format
   '(:eval (jv/mode-line-align
            `("%e"
              (:eval (jv/mode-line-evil-state))
              mode-line-front-space

              ,@(if (display-graphic-p)
                    '((:eval (let ((stat (format-mode-line "%*")))
                               (cond
                                ((string= stat "*")
                                 (all-the-icons-faicon
                                  "chain-broken" :height 0.9 :v-adjust -0.1))
                                ((string= stat "-")
                                 (all-the-icons-faicon
                                  "link" :height 0.9 :v-adjust -0.1))
                                ((string= stat "%")
                                 (all-the-icons-octicon
                                  "lock" :height 0.9 :v-adjust -0.1)))))
                      ;; TODO: mode-line-remote equivalent
                      )
                    '(mode-line-mule-info
                      mode-line-client
                      mode-line-modified
                      mode-line-remote))
              ;; mode-line-frame-identification
              " "
              mode-line-buffer-identification
              ;; " "
              ;; mode-line-position
              (vc-mode vc-mode))
            '(;; mode-line-modes
              (:eval (when (bound-and-true-p winds-mode)
                       (format "%s⎪%s" (winds-get-cur-ws) (winds-get-cur-cfg))))
              " %m "
              (:eval (propertize "%5l:" 'face 'bold))
              "%5c "
              mode-line-misc-info
              " "
              mode-line-end-spaces
              )))))

;; ============================================================================
;; Keys

(use-package evil
  :straight t
  :custom
  ;; these two are necessary for evil-collection
  (evil-want-integration t)
  (evil-want-keybinding nil)

  :config (evil-mode 1))

(use-package evil-lion
  :straight t
  :config
  (evil-lion-mode))

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-magit
  :straight t
  :after (evil magit))

(use-package evil-org
  :straight t
  :after (evil org)
  :hook ((org-mode . evil-org-mode)
         (evil-org-mode . (lambda () (evil-org-set-key-theme
                                      '(textobjects
                                        insert navigation
                                        additional shift
                                        todo heading)))))
  :config
  (use-package evil-org-agenda
    :config
    (evil-org-agenda-set-keys)))

(use-package which-key
  :straight t
  :custom (which-key-idle-delay 0.5)
  :config (which-key-mode 1))

(use-package general
  :straight t
  :after (evil which-key)
  :config
  (general-create-definer leader-def
    :states '(normal insert emacs motion)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "M-SPC") 

  (leader-def
    ;; "TAB" '
    "f s" 'save-buffer
    
    "w h" 'evil-window-left
    "w j" 'evil-window-down
    "w k" 'evil-window-up
    "w l" 'evil-window-right

    ;; "w [" 'winner-undo
    ;; "w ]" 'winner-redo

    "w '" 'window-configuration-to-register
    "w ;" 'jump-to-register))

(use-package emacs
  :config
  (define-key key-translation-map (kbd "ESC") (kbd "C-g")))

;; ============================================================================
;; Colors


(use-package color-theme-sanityinc-tomorrow
  :straight t)

(use-package doom-themes
  :straight t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  ;; (load-theme 'doom-molokai t)
  )

(use-package doom-themes
  :after org
  :config
  (doom-themes-org-config))

(use-package modus-vivendi-theme
  :straight t
  :custom
  (modus-vivendi-theme-completions 'moderate)
  (modus-vivendi-theme-prompts 'subtle)
  (modus-vivendi-theme-intense-paren-match t)
  (modus-vivendi-theme-diffs 'desaturated)
  (modus-vivendi-theme-slanted-constructs t)
  (modus-vivendi-theme-bold-constructs t)
  (modus-vivendi-theme-org-blocks 'greyscale)
  :config
  (load-theme 'modus-vivendi t))
(use-package modus-operandi-theme
  :straight t
  :custom
  (modus-operandi-theme-completions 'moderate)
  (modus-operandi-theme-prompts 'subtle)
  (modus-operandi-theme-intense-paren-match t)
  (modus-operandi-theme-diffs 'desaturated)
  (modus-operandi-theme-slanted-constructs t)
  (modus-operandi-theme-bold-constructs t)
  (modus-operandi-theme-org-blocks 'greyscale))

;; ============================================================================
;; Completion

(use-package hydra
  :straight t)

(defvar jv/completion-engine)
(defun jv/completion-helm-p () (eql jv/completion-engine 'helm))
(defun jv/completion-ivy-p () (eql jv/completion-engine 'ivy))
(setq jv/completion-engine 'ivy)

(when (jv/completion-helm-p)
  (use-package helm
    :straight t
    :after (evil evil-collection general)
    :general
    (leader-def
      "s s" 'helm-occur
      "s k" 'helm-show-kill-ring
      "f r" 'helm-recentf
      "f f" 'helm-find-files
      "b b" 'helm-buffers-list
      "p f" 'helm-browse-projectprojectile-find-file
      "h" 'helm-resume

      "SPC" 'helm-M-x)

    :init
    (evil-collection-helm-setup)
    :config
    (require 'helm-config)

    (general-define-key

     :keymaps '(helm-map helm-find-files-map helm-M-x-map helm-grep-map helm-read-file-map helm-generic-files-map helm-browse-project-map)

     ;; "C-h" 'helm-beginning-of-buffer
     "C-j" 'helm-next-line
     "C-k" 'helm-previous-line
     "C-l" 'helm-execute-persistent-action
     ;; "C-g" 'helm-beginning-of-buffer
     "C-S-g" 'helm-end-of-buffer

     "C-n" 'helm-next-line
     "C-p" 'helm-previous-line

     "C-S-n" 'helm-next-source
     "C-S-p" 'helm-previous-source

     "C-S-k" 'helm-scroll-other-window-down
     "C-S-j" 'helm-scroll-other-window
     "C-S-c" 'helm-recenter-top-bottom-other-window

     "C-<space>" 'helm-toggle-visible-mark
     "C-t" 'helm-toggle-all-marks
     "C-S-u" 'helm-unmark-all

     "C-S-h" 'helm-help
     "C-s" 'helm-buffer-help

     "C-v" 'helm-execute-persistent-action
     "C-d" 'helm-persistent-delete-marked
     "C-y" 'helm-yank-selection
     "C-w" 'helm-toggle-resplit-and-swap-windows
     "C-f" 'helm-follow-mode

     "<return>" 'helm-maybe-exit-minibuffer)

    (general-define-key
     :keymaps '(helm-find-files-map helm-read-file-map)
     "C-h" 'helm-find-files-up-one-level
     "C-<backspace>" 'helm-find-files-up-one-level
     "C-S-l" 'helm-find-files-down-last-level
     )

    (helm-mode 1)

    ;; variants that dont ask for confirmation on actions on marked entries
    (defun jv/helm-persistent-delete-marked ()
      "Kill buffer without quitting helm."
      (interactive)
      (if (equal (cdr (assoc 'name (helm-get-current-source)))
		 "Buffers")
	  (with-helm-alive-p
	    (helm-attrset 'kill-action
			  '(jv/helm-persistent-kill-buffers . never-split))
	    (helm-execute-persistent-action 'kill-action))
	(user-error "Only works for buffers")))

    (defun jv/helm-persistent-kill-buffers (_buffer)
      (unwind-protect
	  (dolist (b (helm-marked-candidates))
	    (helm-buffers-persistent-kill-1 b))
	(with-helm-buffer
	  (setq helm-marked-candidates nil
		helm-visible-mark-overlays nil))
	(helm-force-update (helm-buffers--quote-truncated-buffer
			    (helm-get-selection)))))))

(when (jv/completion-ivy-p)
  (use-package ivy
    :straight t
    :general
    (:keymaps 'ivy-minibuffer-map
              "TAB"   'ivy-partial
              "<C-tab>" 'ivy-partial-or-done
              "C-j"   'ivy-next-line
              "C-k"   'ivy-previous-line

              "M-j"   'ivy-next-line
              "M-k"   'ivy-previous-line
              "M-l"   'ivy-partial
              "M-o"   'ivy-dispatching-done

              "M-J" 'ivy-next-line-and-call
              "M-K" 'ivy-previous-line-and-call
              "M-O" 'ivy-dispatching-call
              "M-d" 'kill-line)
    (:keymaps 'ivy-switch-buffer-map
              "C-k" 'ivy-previous-line ;; override the default of kill buffer
              "M-D" 'ivy-switch-buffer-kill)
    :custom
    (ivy-initial-inputs-alist '((nil . nil)))
    :config
    (add-hook 'desktop-after-read-hook
              (lambda ()
                (setq ivy-initial-inputs-alist '((nil . nil)))))
    (ivy-mode 1))

  (use-package prescient
    :straight t
    :custom
    (prescient-filter-method '(literal regexp))
    :config
    (prescient-persist-mode 1))

  (use-package ivy-prescient
    :straight t
    :after (prescient ivy)
    :config
    (ivy-prescient-mode 1))

  (use-package counsel
    :straight t
    :after helpful
    :general
    (:keymaps 'counsel-ag-map
              "M-l" 'ivy-call-and-recenter)
    :custom
    (counsel-describe-function-function #'helpful-callable)
    (counsel-describe-variable-function #'helpful-variable)
    (counsel-recentf-include-xdg-list t)
    ;; Switch to ripgrep instead of grep
    (counsel-grep-base-command
     "rg -i -M 120 --no-heading --line-number --color never %s %s")
    :config
    (counsel-mode 1))

  (use-package counsel-projectile
    :straight t
    :after (counsel projectile)
    :general
    (leader-def
      "p f" 'counsel-projectile-find-file
      "p s" 'counsel-projectile-rg
      "p b" 'counsel-projectile-switch-to-buffer))

  (use-package ivy-rich
    :straight t
    :after ivy
    :init
    ;; recommended in the README
    (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
    :config
    (ivy-rich-mode 1))

  (use-package emacs
    :after (general ivy counsel projectile)
    :general
    (leader-def
      "h"   'ivy-resume
      "s k" 'counsel-yank-pop
      "f f" 'counsel-find-file
      "f r" 'counsel-recentf
      "b b" 'counsel-switch-buffer
 
      "SPC" 'counsel-M-x))

  (use-package swiper
    :straight t
    :after ivy
    :general
    (leader-def
      "s s" 'swiper-isearch
      "s *" 'swiper-thing-at-point
      "*" 'swiper-thing-at-point
      "s a" 'swiper-all)))

;; ============================================================================
;; Misc

(use-package emacs
  :custom
  (auth-sources (list (concat user-emacs-directory "authinfo.gpg")))
  ;; use gpg1 since gpg2 uses an incompatible curses-based pinentry
  (epg-gpg-program "gpg"))

(use-package emacs
  :init
  (defun jv/fyrepc-zzz ()
    (interactive)
    (let ((default-directory "/ssh:fyrepc:"))
      (shell-command
       (format "echo %s | sudo -S zzz"
               (read-passwd "Password: "))))))

(use-package gnus
  :custom (gnus-init-file (concat user-emacs-directory "gnus")))
;; (use-package all-the-icons-gnus
;;   :straight t
;;   :after (gnus all-the-icons)
;;   :config
;;   (all-the-icons-gnus-setup))

;; (use-package mu4e
;;   ;; NOTE: not straight, system package mu4e installed!
;;   :custom
;;   ;; use mu4e for e-mail in emacs
;;   (mail-user-agent 'mu4e-user-agent)

;;   (mu4e-drafts-folder "/gmail/Drafts")
;;   (mu4e-sent-folder   "/gmail/[Gmail]/Sent Mail")
;;   (mu4e-trash-folder  "/gmail/Trash")

;;   ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
;;   (mu4e-sent-messages-behavior 'delete)

;;   (mu4e-maildir-shortcuts
;;    '( (:maildir "/gmail/Inbox"              :key ?i)
;;       (:maildir "/gmail/[Gmail]/Sent Mail"  :key ?s)
;;       (:maildir "/gmail/Trash"              :key ?t)
;;       (:maildir "/gmail/[Gmail]/All Mail"   :key ?a)))

;;   ;; allow for updating mail using 'U' in the main view:
;;   (mu4e-get-mail-command
;;    (format "mbsync -c %s/isync/mbsyncrc gmail" (xdg-config-home)))

;;   (user-mail-address      "javi.po.123@gmail.com")
;;   (user-full-name         "Javier A. Pollak")
;;   (mu4e-compose-signature "Javier A. Pollak")

;;   ;; (require 'smtpmail)
;;   (message-send-mail-function 'smtpmail-send-it)
;;   (smtpmail-stream-type 'starttls)
;;   (smtpmail-default-smtp-server "smtp.gmail.com")
;;   (smtpmail-smtp-server "smtp.gmail.com")
;;   (smtpmail-smtp-service 587)

;;   ;; don't keep message buffers around
;;   (message-kill-buffer-on-exit t)

;;   :config
;;   (require 'smtpmail)
;;   ;; (mail-user-agent)
;;   )

(use-package avy
  :straight t
  :general
  (leader-def
    "a w" #'evil-avy-goto-word-0
    "a c" #'evil-avy-goto-char
    "a o" #'evil-avy-goto-char-timer))

(use-package ispell
  :custom
  (ispell-program-name "aspell"))

(use-package bufler
  :straight t
  :general
  (:keymaps 'bufler-list-mode-map
   :states '(normal)
   "<tab>"     'magit-section-cycle
   "<backtab>" 'magit-section-cycle-global
   "g ?"       'hydra:bufler/body
   "g r"       'bufler
   "RET"       'bufler-list-buffer-switch
   "M-l"       'bufler-list-buffer-peek
   "M-k"       'magit-section-backward
   "M-j"       'magit-section-forward
   "k"         'magit-section-backward
   "j"         'magit-section-forward
   "D"         'bufler-list-buffer-kill
   "C-p"       'magit-section-backward
   "C-n"       'magit-section-forward
   "q"         'quit-window))

(use-package desktop
  :config
  (desktop-save-mode))

(use-package zygospore
  :straight t
  :general
  ("C-x 1" 'zygospore-toggle-delete-other-windows)
  (leader-def
    "w m" '(zygospore-toggle-delete-other-windows :wk "zoom in/out")))

(use-package vterm
  :straight t)
(use-package vterm
  :after ivy
  :general
  (leader-def
    :keymaps 'vterm-mode-map
    ", p" (lambda () (interactive)
              (let ((path (read-file-name "Enter file name:")))
                (vterm-send-string (format "'%s'" path))))
    ", c c" (lambda () (interactive)
              (let ((path (read-file-name "Enter file name:")))
                (vterm-send-string (format "catt cast '%s'" path))
                (vterm-send-return)))))

(use-package helpful
  :straight t
  :general
  ([remap describe-key] 'helpful-key)
  ([remap describe-function] 'helpful-callable)
  ([remap describe-variable] 'helpful-variable))

;; (use-package zones
;;   :straight t)

(use-package narrow-indirect
  :straight t
  :general
  (leader-def
    "n d" '(ni-narrow-to-defun-indirect-other-window  :wk "narrow defun other window")
    "n n" '(ni-narrow-to-region-indirect-other-window :wk "narrow region other window")
    "n p" '(ni-narrow-to-page-indirect-other-window   :wk "narrow page other window")))

;; (use-package eyebrowse
;;   :straight t
;;   :custom
;;   (eyebrowse-mode-line-style 'current)
;;   :general
;;   (leader-def
;;     "w n" '(eyebrowse-next-window-config :wk "ws next")
;;     "w p" '(eyebrowse-prev-window-config :wk "ws prev")
;;     "w 0" '(eyebrowse-switch-to-window-config-0 :wk "ws 0")
;;     "w 1" '(eyebrowse-switch-to-window-config-1 :wk "ws 1")
;;     "w 2" '(eyebrowse-switch-to-window-config-2 :wk "ws 2")
;;     "w 3" '(eyebrowse-switch-to-window-config-3 :wk "ws 3")
;;     "w 4" '(eyebrowse-switch-to-window-config-4 :wk "ws 4")
;;     "w 5" '(eyebrowse-switch-to-window-config-5 :wk "ws 5")
;;     "w 6" '(eyebrowse-switch-to-window-config-6 :wk "ws 6")
;;     "w 7" '(eyebrowse-switch-to-window-config-7 :wk "ws 7")
;;     "w 8" '(eyebrowse-switch-to-window-config-8 :wk "ws 8")
;;     "w 9" '(eyebrowse-switch-to-window-config-9 :wk "ws 9"))
;;   :config
;;   (eyebrowse-mode 1))

(use-package winds
  :straight (winds :type git :host github :repo "Javyre/winds.el")
  :custom
  (winds-default-ws 1)
  (winds-default-cfg 1)
  :config
  ;; (with-eval-after-load 'desktop (winds-enable-desktop-save))
  (winds-mode)
  (winds-history-mode)
  :general
  (leader-def
    "w [" 'winds-history-undo
    "w ]" 'winds-history-redo
    "w w n" 'winds-next
    "w w p" 'winds-prev
    "w w c" 'winds-close
    "w w TAB" 'winds-last
    "w n" 'winds-cfg-next
    "w p" 'winds-cfg-prev
    "w c" 'winds-cfg-close
    "w TAB" 'winds-cfg-last
    "w o" 'winds-pos-last
    "w w 0" (lambda () (interactive) (winds-goto :ws 10))
    "w w 1" (lambda () (interactive) (winds-goto :ws 1))
    "w w 2" (lambda () (interactive) (winds-goto :ws 2))
    "w w 3" (lambda () (interactive) (winds-goto :ws 3))
    "w w 4" (lambda () (interactive) (winds-goto :ws 4))
    "w w 5" (lambda () (interactive) (winds-goto :ws 5))
    "w w 6" (lambda () (interactive) (winds-goto :ws 6))
    "w w 7" (lambda () (interactive) (winds-goto :ws 7))
    "w w 8" (lambda () (interactive) (winds-goto :ws 8))
    "w w 9" (lambda () (interactive) (winds-goto :ws 9))
    "w 0" (lambda () (interactive) (winds-goto :cfg 10))
    "w 1" (lambda () (interactive) (winds-goto :cfg 1))
    "w 2" (lambda () (interactive) (winds-goto :cfg 2))
    "w 3" (lambda () (interactive) (winds-goto :cfg 3))
    "w 4" (lambda () (interactive) (winds-goto :cfg 4))
    "w 5" (lambda () (interactive) (winds-goto :cfg 5))
    "w 6" (lambda () (interactive) (winds-goto :cfg 6))
    "w 7" (lambda () (interactive) (winds-goto :cfg 7))
    "w 8" (lambda () (interactive) (winds-goto :cfg 8))
    "w 9" (lambda () (interactive) (winds-goto :cfg 9)))
  ("M-0" (lambda () (interactive) (winds-goto :cfg 10))
   "M-1" (lambda () (interactive) (winds-goto :cfg 1))
   "M-2" (lambda () (interactive) (winds-goto :cfg 2))
   "M-3" (lambda () (interactive) (winds-goto :cfg 3))
   "M-4" (lambda () (interactive) (winds-goto :cfg 4))
   "M-5" (lambda () (interactive) (winds-goto :cfg 5))
   "M-6" (lambda () (interactive) (winds-goto :cfg 6))
   "M-7" (lambda () (interactive) (winds-goto :cfg 7))
   "M-8" (lambda () (interactive) (winds-goto :cfg 8))
   "M-9" (lambda () (interactive) (winds-goto :cfg 9))))

(use-package ace-window
  :straight t
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-scope 'visible)
  :general
  (leader-def
    "k" 'ace-window))

(use-package evil-multiedit
  :straight t
  :config
  (evil-multiedit-default-keybinds))

(use-package evil-mc
  :straight t
  :general
  (:prefix "gz"
   :states '(visual)
   "A" #'evil-mc-make-cursor-in-visual-selection-end
   "I" #'evil-mc-make-cursor-in-visual-selection-beg)
  (:prefix "gz"
   :states '(normal visual)
   "u" #'evil-mc-undo-all-cursors
   "n" #'evil-mc-make-and-goto-next-match
   "p" #'evil-mc-make-and-goto-prev-match
   "N" #'evil-mc-make-and-goto-last-match
   "P" #'evil-mc-make-and-goto-first-match)
  :config
  (global-evil-mc-mode 1))

(use-package ripgrep
  :straight t)

(use-package wgrep
  :straight t)

(use-package projectile-ripgrep
  :straight t
  :after projectile)

(when (jv/completion-ivy-p)
  (use-package projectile
    :straight t
    :after ivy
    :custom (projectile-completion-system 'ivy)))
(when (jv/completion-helm-p)
  (use-package projectile
    :straight t
    :after helm
    :custom (projectile-completion-system 'helm)))

(use-package magit
  :straight t
  :general
  (leader-def "g s" 'magit-status))

;; (use-package dashboard
;;   :straight t
;;   :custom
;;   (dashboard-startup-banner "~/.emacs.d/snowlabs.png")
;;   ;; (initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
;;   :config
;;   (dashboard-setup-startup-hook))

(use-package company
  :straight t
  :custom
  (company-tooltip-align-annotations t)
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 1)
  (company-dabbrev-downcase nil)
  (company-backends '((company-bbdb     :with company-dabbrev-code)
                      ;; (company-eclim    :with company-dabbrev-code)
                      (company-semantic :with company-dabbrev-code)
                      (company-clang    :with company-dabbrev-code)
                      ;; (company-xcode    :with company-dabbrev-code)
                      (company-cmake    :with company-dabbrev-code)
                      (company-capf     :with company-dabbrev-code)
                      (company-files    :with company-dabbrev-code)
                      (company-dabbrev-code company-gtags company-etags company-keywords)
                      company-oddmuse
                      company-dabbrev))
  :general
  (:states 'insert "TAB" #'company-indent-or-complete-common)
  :config
  (global-company-mode))

(use-package slime-company
  :straight t
  :after (company slime)
  :custom (slime-company-completion 'fuzzy))

;; (use-package treemacs
;;   :straight t
;;   :custom
;;   (treemacs-width 22)
;;   :general
;;   (leader-def
;;     "t" 'treemacs
;;     "M-t f" 'treemacs-find-file)
;;   :config
;;   (treemacs-resize-icons 20))
;; (use-package treemacs-evil       :after treemacs evil       :straight t)
;; (use-package treemacs-projectile :after treemacs projectile :straight t)  
;; (use-package treemacs-magit      :after treemacs magit      :straight t)

;; dired-sidebar uses dired-hacks and dired-subtree
(use-package dired-sidebar
  :straight t
  :general
  (leader-def
    "t s" 'dired-sidebar-toggle-sidebar))

(use-package dired
  :general
  (:map 'dired-mode-map
        "M-j" 'dired-next-subdir
        "M-k" 'dired-prev-subdir
        "M-i" 'dired-kill-subdir)
  :hook ((dired-mode . dired-hide-details-mode)))

(use-package all-the-icons
  :straight t
  :custom
  ;; Helps performance but increases memory footprint
  (inhibit-compacting-cont-caching t))

;; ============================================================================
;; Langs

(use-package flycheck :straight t)

(setq lsp-keymap-prefix "SPC l")
(use-package lsp-mode
  :straight t
  :after (web-mode which-key)
  :hook ((web-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :custom
  (lsp-eslint-server-command
   '("node" "/home/javier/.local/opt/vscode-eslint/server/out/eslintServer.js" "--stdio"))
  (typescript-indent-level 2)
  (lsp-eslint-run "onSave")
  :general
  (leader-def "l" lsp-command-map))
(use-package lsp-ui :straight t :after lsp-mode :commands lsp-ui-mode)
(use-package lsp-ivy :straight t :after (lsp-mode ivy) :commands lsp-ivy-workspace-symbol)

(use-package js2-mode
  :straight t
  :custom
  (js2-basic-offset 2))

(use-package elixir-mode
  :straight t)

(use-package package-lint
  :straight t)

(use-package rust-mode
  :straight t
  :general
  (leader-def :keymaps '(rust-mode-map)
    ", ," 'rust-run
    ", e" 'next-error)
  :general
  (:keymaps '(rust-mode-map)
   "C-c C-c" 'rust-run))

(use-package racer
  :straight t
  :after rust-mode
  :hook ((rust-mode-hook . racer-mode)
         (racer-mode-hook . eldoc-mode)))

(use-package web-mode
  :straight t
  :mode "\\.[jt]sx?\\'"

  :general
  (leader-def web-mode-map
    "F" 'jv/prettier-format-buff)

  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-enable-auto-quoting nil)

  :config
  (defun jv/prettier-format-buff ()
    (interactive)
    (let ((orig (point)))
      (shell-command-on-region
       (point-min) (point-max) "prettier" nil t)
      (goto-char orig))

    ;; web-mode gets confused after buff gets replaced
    (web-mode-buffer-highlight)))

(use-package impatient-mode
  :straight t)

(use-package csharp-mode
  :straight t
  :init
  (defun jv/csharp-mode-hook ()
    (electric-pair-local-mode 1))
  :gfhook
  #'jv/csharp-mode-hook)

(use-package slime
  :straight t
  :general
  (leader-def lisp-mode-map
    ", S" 'jv/qlot-slime-start)

  :custom
  (slime-contribs '(slime-fancy slime-company))

  :config
  (defun jv/qlot-slime-start (dir)
    (interactive (list (read-directory-name "Qlot project root:")))
    (slime-start :program "ros"
               :program-args '("exec" "qlot" "exec" "ros" "-S" "." "run")
               :directory dir
               :name 'qlot
               :env (list (concat "PATH=" (mapconcat 'identity exec-path ":"))))))

;; (use-package emacs
;;   :init
;;   (defun jv/dired-default-directory-on-left ()
;;     "Display `default-directory' in side window on left, hiding details."
;;     (interactive)
;;     (let ((buffer (dired-noselect default-directory))
;;           (parameters '(window-parameters . ((no-other-window . t)
;;                                              (no-delete-other-windows . t)))))
;;       (with-current-buffer buffer (dired-hide-details-mode t))
;;       (display-buffer-in-side-window
;;        buffer `((side . left) (slot . 0)
;;                 (window-width . fit-window-to-buffer)
;;                 (preserve-size . (t . nil)) ,parameters)))))

(use-package emacs
  :custom
  (sql-oracle-program "~/.local/opt/oracle/instantclient_19_5/run")
  (sql-database "198.168.52.73:1522/pdborad12c.dawsoncollege.qc.ca")
  (sql-product 'oracle))

(use-package markdown-mode
  :straight t)

(use-package org
  :general
  (leader-def
    "o c" 'counsel-org-capture
    "o a" 'org-agenda)
  ;; (:keymaps 'org-mode-map :states '(normal insert emacs motion)
  ;;        "M-h" 'org-metaleft
  ;;        "M-j" 'org-metadown
  ;;        "M-k" 'org-metaup
  ;;        "M-l" 'org-metaright
  ;;        "M-H" 'org-shiftmetaleft
  ;;        "M-J" 'org-shiftmetadown
  ;;        "M-K" 'org-shiftmetaup
  ;;        "M-L" 'org-shiftmetaright)
  :custom
  (org-hide-emphasis-markers t)
  (org-ellipsis " ⏷ ")
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)

  (org-directory (concat (xdg-data-home) "/emacs/org"))
  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-agenda-files (list org-directory))
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "" "To Do") "** TODO %?\n   %i\n   %a" :prepend t)
     ("i" "Idea" entry (file+headline "" "Ideas") "** %?\n   %i\n   %a"      :prepend t)))
  (org-agenda-custom-commands
   '(("h" "Agenda & Homework" ((agenda "+dawson")
			       (tags-todo "+dawson")))
     ("n" "Agenda & All TODOs" ((agenda "")
				(alltodo "")))))

  ;; enable prompt-free code running
  (org-confirm-babel-evaluate nil)      ;; for running code blocks
  (org-confirm-elisp-link-function nil) ;; for elisp links
  (org-confirm-shell-link-function nil) ;; for shell links
  :config
  (setf (alist-get 'system org-file-apps-defaults-gnu) "xdg-open %s")

  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 2.0)))

(use-package org-bullets
  :straight t
  :hook ((org-mode . org-bullets-mode))
  :custom
  (org-bullets-bullet-list '("⬢" "■" "◆" "▲")))

(use-package writeroom-mode :straight t)
(use-package centered-cursor-mode :straight t)

(use-package pdf-tools :straight t)

;; ============================================================================
;; Emacs

;; Smoother scrolling (still glitchy on trackpad)
(use-package emacs
  :custom
  (mouse-wheel-scroll-amount '(1))
  (mouse-wheel-progressive-speed nil)
  (scroll-conservatively 101))

;; garbage files
(use-package emacs
  :custom
  (backup-directory-alist
   `(("." . ,(concat (xdg-data-home) "/emacs/backups"))))
  (delete-old-versions t)
  (autosave-dir (concat (xdg-data-home) "/emacs/autosave/"))
  (auto-save-list-file-prefix autosave-dir)
  (auto-save-file-name-transforms `((".*"  ,autosave-dir t)))
  (tramp-backup-directory-alist backup-directory-alist))

;; Show paren
(use-package emacs
  :custom (show-paren-delay 0)
  :config (show-paren-mode t))

;; Misc
(use-package emacs
  :custom
  (inhibit-startup-screen 'dont)

  (x-gtk-use-system-tooltips nil)
  (use-dialog-box nil)

  (tab-width 4)
  (indent-tabs-mode nil)

  ;; bug in emacs 26 causes lag with helm
  ;; https://github.com/emacs-helm/helm/issues/1976
  (x-wait-for-event-timeout nil)

  (enable-recursive-minibuffers t)
  :init
  (when (equal (getenv "TERM") "st-256color")
    (setq xterm-extra-capabilities nil)
    (require 'term/xterm)
    (tty-run-terminal-initialization (selected-frame) "xterm"))

  ;; Add color formatting to *compilation* buffer
  (add-hook 'compilation-filter-hook
            (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

  ;; Use a hook so the message doesn't get clobbered by other messages.
  (add-hook 'emacs-startup-hook
            (lambda ()
              (message "Emacs ready in %s with %d garbage collections."
                       (format "%.2f seconds"
                               (float-time
                                (time-subtract after-init-time before-init-time)))
                       gcs-done)))
  :config
  (blink-cursor-mode 0)
  (save-place-mode t)
  (winner-mode 1)

  ;; automatically reload file on changed from elsewhere
  (global-auto-revert-mode))

;; ;; FIXME: broken (does not display in headerline
;; (use-package which-func
;;   :custom
;;   (which-func-modes '(lisp-mode))
;;   :init
;;   (setq mode-line-format (delete (assoc 'which-func-mode
;;                                         mode-line-format) mode-line-format)
;;         which-func-header-line-format '(which-func-mode ("" which-func-format)))
;;   (defadvice which-func-ff-hook (after header-line activate)
;;     (when which-func-mode
;;       (setq mode-line-format (delete (assoc 'which-func-mode
;;                                             mode-line-format) mode-line-format)
;;             header-line-format which-func-header-line-format)))
;;   )
;;   ;; :config
;;   ;; ;; (which-function-mode 1)
;;   ;; (setq mode-line-misc-info (assq-delete-all 'which-func-mode mode-line-misc-info)))


;; ============================================================================
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(beacon-color "#cc6666")
 '(compilation-message-face 'default)
 '(counsel-describe-function-function 'helpful-callable)
 '(counsel-describe-variable-function 'helpful-variable)
 '(custom-safe-themes
   '("a038af4fff7330f27f4baec145ef142f8ea208648e65a4b0eac3601763598665" "d71aabbbd692b54b6263bfe016607f93553ea214bc1435d17de98894a5c3a086" "774aa2e67af37a26625f8b8c86f4557edb0bac5426ae061991a7a1a4b1c7e375" "e456955baadeba1eae3f32bf1dc65a2c69a561a714aae84e3278e1663454fe31" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "d5f8099d98174116cba9912fe2a0c3196a7cd405d12fa6b9375c55fc510988b5" "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94" "1c8171893a9a0ce55cb7706766e57707787962e43330d7b0b6b0754ed5283cda" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "a339f231e63aab2a17740e5b3965469e8c0b85eccdfb1f9dbd58a30bdad8562b" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "e1ecb0536abec692b5a5e845067d75273fe36f24d01210bf0aa5842f2a7e029f" "285efd6352377e0e3b68c71ab12c43d2b72072f64d436584f9159a58c4ff545a" "229c5cf9c9bd4012be621d271320036c69a14758f70e60385e87880b46d60780" "4daff0f7fb02c7a4d5766a6a3e0931474e7c4fd7da58687899485837d6943b78" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "0fe9f7a04e7a00ad99ecacc875c8ccb4153204e29d3e57e9669691e6ed8340ce" "b60f08ddc98a95485ec19f046a81d5877b26ab80a67782ea5b91a00ea4f52170" "4b0b568d63b1c6f6dddb080b476cfba43a8bbc34187c3583165e8fb5bbfde3dc" "5e0b63e0373472b2e1cf1ebcc27058a683166ab544ef701a6e7f2a9f33a23726" "e47c0abe03e0484ddadf2ae57d32b0f29f0b2ddfe7ec810bd6d558765d9a6a6c" "a4fa3280ffa1f2083c5d4dab44a7207f3f7bcb76e720d304bd3bd640f37b4bef" "c6b93ff250f8546c7ad0838534d46e616a374d5cb86663a9ad0807fd0aeb1d16" "bbb2b9b5d248ef6666abe409a58b75024121de77c27df09f188bfc29d8384433" "f7b230ac0a42fc7e93cd0a5976979bd448a857cd82a097048de24e985ca7e4b2" "1ca1f43ca32d30b05980e01fa60c107b02240226ac486f41f9b790899f6f6e67" "2c4222fc4847588deb57ce780767fac376bbf5bdea5e39733ff5e380a45e3e46" "e7666261f46e2f4f42fd1f9aa1875bdb81d17cc7a121533cad3e0d724f12faf2" "32fd809c28baa5813b6ca639e736946579159098d7768af6c68d78ffa32063f4" "dc677c8ebead5c0d6a7ac8a5b109ad57f42e0fe406e4626510e638d36bcc42df" default))
 '(delete-old-versions t)
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(epg-gpg-program "gpg")
 '(evil-want-integration t)
 '(evil-want-keybinding nil)
 '(eyebrowse-mode-line-style 'current)
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'dark)
 '(helm-completion-style 'emacs)
 '(helm-external-programs-associations '(("docx" . "lowriter") ("pdf" . "evince")))
 '(helm-mode t)
 '(highlight-changes-colors '("#FD5FF0" "#AE81FF"))
 '(highlight-tail-colors
   '(("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100)))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen 'dont)
 '(ivy-mode nil)
 '(magit-diff-use-overlays nil)
 '(monokai-background nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount '(1))
 '(org-agenda-custom-commands
   '(("h" "Agenda & Homework"
      ((agenda "+dawson")
       (tags-todo "+dawson")))
     ("n" "Agenda & All TODOs"
      ((agenda "")
       (alltodo "")))) t)
 '(org-capture-templates
   '(("t" "Todo" entry
      (file+headline "" "To Do")
      "** TODO %?
   %i
   %a" :prepend t)
     ("i" "Idea" entry
      (file+headline "" "Ideas")
      "** %?
   %i
   %a" :prepend t)) t)
 '(org-confirm-babel-evaluate nil t)
 '(org-confirm-elisp-link-function nil t)
 '(org-confirm-shell-link-function nil t)
 '(package-selected-packages
   '(esup evil-org slime helpful counsel doom-themes monokai-theme monokai swoop eyebrowse evil-collection avy ivy use-package which-key general projectile color-theme-sanityinc-tomorrow evil))
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color nil)
 '(projectile-completion-system 'helm)
 '(scroll-conservatively 101)
 '(show-paren-delay 0)
 '(slime-company-completion 'fuzzy)
 '(slime-contribs '(slime-fancy) t)
 '(sql-database "198.168.52.73:1522/pdborad12c.dawsoncollege.qc.ca" t)
 '(sql-oracle-program "~/.local/opt/oracle/instantclient_19_5/run" t)
 '(sql-product 'oracle t)
 '(treemacs-width 22 t)
 '(use-dialog-box nil)
 '(web-mode-code-indent-offset 2 t)
 '(web-mode-css-indent-offset 2 t)
 '(web-mode-enable-auto-quoting nil t)
 '(web-mode-markup-indent-offset 2 t)
 '(weechat-color-list
   '(unspecified nil "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))
 '(which-func-modes '(lisp-mode))
 '(which-function-mode t)
 '(which-key-idle-delay 0.5)
 '(window-divider-mode nil)
 '(x-gtk-use-system-tooltips nil)
 '(x-wait-for-event-timeout nil t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ============================================================================
;;
(put 'narrow-to-region 'disabled nil)
