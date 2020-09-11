;; -*- lexical-binding: t; -*-

;; Init performance
;; From https://github.com/hlissner/doom-emacs/blob/develop/docs/faq.org#how-does-doom-start-up-so-quickly

;; Avoid garbage collection at startup
(defvar jv/gc-cons-threshold 16777216) ; 16Mib
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold jv/gc-cons-threshold
                  gc-cons-percentage 0.1)))

;; Avoid garbage collection during minibuffer
(defun jv/defer-garbage-collection-h ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun jv/restore-garbage-collection-h ()
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold jv/gc-cons-threshold))))

(add-hook 'minibuffer-setup-hook #'jv/defer-garbage-collection-h)
(add-hook 'minibuffer-exit-hook #'jv/restore-garbage-collection-h)

;; Unset file-name-handler-alist temporarily
(defvar jv/--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
  (lambda ()
    (setq file-name-handler-alist jv/--file-name-handler-alist)))

;; Make sure package.el is not initialized
(setq package-enable-at-startup nil ; don't auto-initialize!
      package--init-file-ensured t)

;; ============================================================================
;; Emacs

;; Cosmetic

;; to get currect frame params: (frame-parameters)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

(push '(font-parameter . "MesloLGS Nerd Font Mono-13") default-frame-alist)
(push '(font . "-PfEd-MesloLGS Nerd Font Mono-normal-normal-normal-*-17-*-*-*-m-0-iso10646-1")
      default-frame-alist)
