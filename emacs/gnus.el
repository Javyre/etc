;; ============================================================================
;; Generic email

(setq user-mail-address "javi.po.123@gmail.com"
      user-full-name    "Javier A. Pollak")

;; Send email through SMTP
(setq send-mail-function           'smtpmail-send-it
      message-send-mail-function   'smtpmail-send-it
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service        587)

;; auto-complete emacs address using bbdb command, optional
(add-hook 'message-mode-hook
          '(lambda ()
             (flyspell-mode t)
             (local-set-key (kbd "TAB") 'bbdb-complete-name)))

(use-package gmail2bbdb
  :straight t
  :after (gmail)
  :custom
  (gmail2bbdb-bbdb-file bbdb-file))



;; ============================================================================
;; Gnus Sources
(setq gnus-select-method '(nntp "news.gwene.org"))

;; ask encryption password once
(setq epa-file-cache-passphrase-for-symmetric-encryption t)

(add-to-list 'gnus-secondary-select-methods
             '(nnimap "gmail"
                      (nnimap-address "imap.gmail.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)
                      (nnir-search-engine imap)
                      ; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
                      ;; press 'E' to expire email
                      (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
                      (nnmail-expiry-wait 90)))

(add-to-list 'nnir-imap-search-arguments '("gmail" . "X-GM-RAW"))
(setq nnir-imap-default-search-key "gmail")

;; ============================================================================
;; Gnus Custom

(use-package gnus
  :custom
  (gnus-thread-sort-functions
   '(gnus-thread-sort-by-most-recent-date
     (not gnus-thread-sort-by-number)))

  (gnus-use-cache t)

  ;; News hierarchies, which are really gatewayed mailing lists.
  (gnus-mailing-list-groups
   (rx bol (opt "nntp" (1+ nonl) ":") (or "gmane."
                                          "linux."
                                          "mozilla.")))

  :config
  ;; Warn if replying from a newsgroup:
  (defadvice gnus-summary-reply (around asjo-reply-in-news activate)
    (interactive)
    (when (or (not (gnus-news-group-p gnus-newsgroup-name))
              (y-or-n-p "Really reply? (this is a newsgroup and you probably mean to reply to all) "))
      ad-do-it))

  :general
  (:keymaps 'gnus-group-mode-map
    :states 'normal
    ;; press "o" to view all groups
    ;; list all the subscribed groups even they contain zero un-read messages
    "o" (lambda ()
            "List all subscribed groups with or without un-read messages"
            (interactive)
            (gnus-group-list-all-groups 5)))

  (:keymaps 'gnus-summary-mode-map
    :states 'normal
    "D" (lambda ()
          (interactive)
          (gnus-summary-move-article nil "nnimap+gmail:[Gmail]/Trash"))))



(use-package bbdb
  :straight t
  :custom
  (bbdb/mail-auto-create-p t)
  (bbdb/news-auto-create-p t)
  :config
  (bbdb-initialize 'message 'gnus 'sendmail)
  (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus))

;; open attachment
(eval-after-load 'mailcap '(mailcap-parse-mailcaps))

;; tree view for groups.
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; ;; show only toplevel message of each thread
;; (setq gnus-thread-hide-subtree t)
;; (setq gnus-thread-ignore-subject t)

;; apparently for performance, but may be obsolete
(setq gnus-use-correct-string-widths nil)

(setq gnus-sum-thread-tree-indent " "
      gnus-sum-thread-tree-root "● "
      gnus-sum-thread-tree-false-root "◯ "
      gnus-sum-thread-tree-single-indent "◎ "
      gnus-sum-thread-tree-leaf-with-other "├─>"
      gnus-sum-thread-tree-vertical "│"
      gnus-sum-thread-tree-single-leaf "╰─>")

(setq gnus-face-9 'font-lock-warning-face)
(setq gnus-face-10 'shadow)

(setq gnus-summary-line-format
      (concat
       "%U%R%10{│%}"
       "%16&user-date;%10{│%}"
       "%(%3t:%-23,23f%)%10{│%}"
       "%* %3{%B%}%s\n"))

;; ============================================================================
;; Gnus Topics

;; it's dependent on `gnus-topic-mode'. (aka Topics view in Group buffer)
(eval-after-load 'gnus-topic
  '(progn
     (setq gnus-message-archive-group '((format-time-string "sent.%Y")))

     (setq gnus-server-alist `(("archive" nnfolder "archive"
                                (nnfolder-directory
                                 ,(concat (xdg-data-home) "/gnus/archive"))
                                (nnfolder-active-file
                                 ,(concat (xdg-data-home) "/gnus/archive/active"))
                                (nnfolder-get-new-mail nil)
                                (nnfolder-inhibit-expiry t))))

     (setq gnus-topic-topology '(("Gnus" visible)
                                 (("misc" visible))
                                 (("gmail" visible nil nil))))

     ;; each topic corresponds to a public imap folder
     (setq gnus-topic-alist '(("gmail" ; the key of topic
                               "nnimap+gmail:INBOX"
                               "nnimap+gmail:[Gmail]/All Mail"
                               "nnimap+gmail:[Gmail]/Sent Mail"
                               "nnimap+gmail:[Gmail]/Trash"
                               "nnimap+gmail:Drafts")
                              ("misc" ; the key of topic
                               "nnfolder+archive:sent.2018"
                               "nnfolder+archive:sent.2019"
                               "nndraft:drafts")
                              ("Gnus")))

     ;; see latest 200 mails in topic hen press Enter on any group
     (gnus-topic-set-parameters "gmail" '((display . 200)))))
