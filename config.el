;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Saúl Germán Gutiérrez Calderón"
      user-mail-address "me@sggc.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;(setq doom-font (font-spec :family "Blex Mono NF" :size 12 :weight 'semi-light)
                                        ;
;;      doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "BlexMono Nerd Font Mono" :size 14
                           ;;:weight 'semi-light
                           )
      doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 16)
                                        ; doom-unicode-font (font-spec :family "Hack")
      doom-big-font (font-spec :family "BlexMono Nerd Font Mono" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load heavy stuff
(load! "Snippets/dragndropPersonal.el")

;; Calculator map
(map! :g "C-<f2>" 'calc)

;; Swap "C-t" and "C-x", so it's easier to type on Dvorak layout
(keyboard-translate ?\C-t ?\C-x)
(keyboard-translate ?\C-x ?\C-t)


(after! lsp-python-ms
  (set-lsp-priority! 'mspyls 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  Org-mode stuff 
(after! org-mode
  :config
  (require 'org-habit)
  (setq org-agenda-files (list "~/org/todo.org"
                               "~/org/gp.org"
                               ;; "~/org/work.org"
                               "~/org/school.org"
                               ;; "~/org/home.org"
                               ;; "~/org/tech.org"
                               ;; "~/org/personal.org"
                               ))

  (setq org-agenda-custom-commands
        '(("c" . "My Custom Agendas")
          ("cu" "Unscheduled TODO"
           ((todo ""
                  ((org-agenda-overriding-header "\nUnscheduled TODO")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))))
           nil
           nil)))
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-refile-targets (quote ((org-agenda-files :level . 1))))
  )

(use-package! org-journal
  :custom
  (org-journal-dir "~/org/roam/")
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y")
  (org-journal-enable-agenda-integration t)
  )

(use-package! org-roam
  :custom
  (org-roam-graph-viewer "firefox-dev")
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Deft
;;;; This is somehow used for org-mode
(use-package! deft
  :after org
  :custom
  (deft-recursive t)
  (deft-directory "~/org/roam/"))

(setq ispell-dictionary "es")


