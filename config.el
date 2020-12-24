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

(defmacro get-first-available-font (font-list default-font-name)
  ;; Gets a font-list and checks if that font is available in a graphical environment
  ;; Otherwise, it returns default-font-name
  ;; If emacs is running in a terminal, returns default-font-name also.
  (if (display-graphic-p)
      (cl-loop for font in font-list
               when (find-font (font-spec :name font))
               return font
               finally return default-font-name)
    default-font-name))

(setq sggutier/monospace-font
      (get-first-available-font
       ("BlexMono Nerd Font Mono"
        "Hack" "Source Code Pro" "Fira Code"
        "Cascadia" "Monaco" "DejaVu Sans Mono" "Consolas")
       "monospace"))

(setq sggutier/serif-font
      (get-first-available-font
       ("Hack" "VictorMono Nerd Font Mono" "IBM Plex Sans" "Consolas" "Monaco")
       nil))

(setq sggutier/sans-font
      (get-first-available-font
       ("Noto Sans" "IBM Plex Sans" "Helvetica")
       "sans"))


(setq doom-font (font-spec :family sggutier/monospace-font :size 14
                           ;;:weight 'semi-light
                           )
      ;; Font below is used in zen-mode and in treemacs
      doom-variable-pitch-font (font-spec :family sggutier/sans-font :size 16)
                                        ; doom-unicode-font (font-spec :family "Hack")
      doom-serif-font (font-spec :family sggutier/serif-font :size 14
                           ;;:weight 'semi-light
                           )
      doom-big-font (font-spec :family sggutier/monospace-font :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)
(setq doom-themes-treemacs-theme "doom-colors")
(setq-default cursor-type 'bar)

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

;; Misc. Keybindings
(map! :g "C-<f2>" 'calc)

;; I hate it when MacOs thinks different
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'control)
  (setq mac-right-option-modifier 'none))

;; Swap "C-t" and "C-x", so it's easier to type on Dvorak layout
(keyboard-translate ?\C-t ?\C-x)
(keyboard-translate ?\C-x ?\C-t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  Org-mode stuff 
(after! org
  (require 'org-habit)
  (setq org-latex-pdf-process'
        ("pdflatex -interaction nonstopmode -output-directory %o %f"
         "biber %b"
         "pdflatex -interaction nonstopmode -output-directory %o %f"
         "pdflatex -interaction nonstopmode -output-directory %o %f"))
  (setq org-agenda-files
        (list "~/org/todo.org"
              "~/org/gp.org"
              "~/org/projects.org"
              )
        org-capture-templates
        (list
         '("t" "todo" entry
           (file "~/org/capture.org")
           "* TODO %?\n %U\n")
         ;; "* TODO %?\n")
         )
        org-agenda-custom-commands
        '(("c" . "My Custom Agendas")
          ("cu" "Unscheduled TODO"
           ((todo ""
                  ((org-agenda-overriding-header "\nUnscheduled TODO")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))))
           nil
           nil))
        ;; org-startup-indented t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-ellipsis (if (char-displayable-p ?⤵) " ⤵" nil)
        org-refile-targets (quote ((org-agenda-files :level . 1)))
        ;; org-pretty-entities nil
        org-hide-emphasis-markers t
        )
  (setq org-log-done 'time)
  (define-key global-map (kbd "S-<f12>") 'org-agenda)
  (define-key global-map (kbd "<f12>") 'org-capture)
  )

(use-package! org-journal
  :custom
  (org-journal-dir "~/org/roam/")
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%Y-%m-%d")
  (org-journal-enable-agenda-integration t)
  )

(after! org-roam
  (setq org-roam-graph-viewer "firefox-dev")
  (setq +org-roam-open-buffer-on-find-file nil)
  )

(use-package! org-ref
  :custom
  (org-ref-bibliography-notes "~/Dokumentoj/bibliography/notes.org")
  (org-ref-default-bibliography '("~/Dokumentoj/bibliography/references.bib"))
  (org-ref-pdf-directory "~/Dokumentoj/bibliography/bibtex-pdfs/")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Lorem Ipsum
(use-package! lorem-ipsum)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Web
(after! web-mode
  (setq web-mode-auto-close-style 2)
  )

;; This modifies the matching tag automatically
;; (use-package! auto-rename-tag
;;   :config
;;   (add-hook 'web-mode-hook (lambda () (auto-rename-tag-mode t)))
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Multiple Cursors
(map! :g "C-S-<mouse-1>" #'mc/add-cursor-on-click)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Competitive Programming
(defun single-g++-compile()
  (interactive)
  (let* ((src (file-name-nondirectory (buffer-file-name)))
        (exe (file-name-sans-extension src)))
    (compile (concat "g++ -std=c++17 -Wall -g " src " -o " exe ".bin && ./" exe ".bin") t)
    (switch-to-buffer-other-window "*compilation*")))

(after! cc-mode
  (map! :map c++-mode-map "<f5>" #'single-g++-compile)
  (setf (alist-get 'c++-mode c-default-style) "k&r")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; LSP
;;;; Various lsp settings
(after! lsp-python-ms
  (set-lsp-priority! 'mspyls 1))

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "/home/sggutier/.emacs.d/.local/etc/lsp/mspyls/Microsoft.Python.LanguageServer")
                    :major-modes '(python-mode)
                    :remote? t
                    :notification-handlers (lsp-ht ("python/languageServerStarted" 'lsp-python-ms--language-server-started-callback)
                                                   ("telemetry/event" 'ignore)
                                                   ("python/reportProgress" 'lsp-python-ms--report-progress-callback)
                                                   ("python/beginProgress" 'lsp-python-ms--begin-progress-callback)
                                                   ("python/endProgress" 'lsp-python-ms--end-progress-callback))
                    :initialization-options 'lsp-python-ms--extra-init-params
                    :initialized-fn (lambda (workspace)
                                      (with-lsp-workspace workspace
                                                          (lsp--set-configuration (lsp-configuration-section "python"))))
                    :server-id 'mspyls-remote))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection '("intelephense" "--stdio"))
                    :major-modes '(php-mode)
                    :remote? t
                    :priority -1
                    :notification-handlers (ht ("indexingStarted" #'ignore)
                                               ("indexingEnded" #'ignore))
                    :initialization-options (lambda ()
                                              (list :storagePath lsp-intelephense-storage-path
                                                    :licenceKey lsp-intelephense-licence-key
                                                    :clearCache lsp-intelephense-clear-cache))
                    :completion-in-comments? t
                    :server-id 'iph-remote))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "html-languageserver")
                    :major-modes '(html-mode sgml-mode mhtml-mode web-mode)
                    :remote? t
                    :priority -4
                    :completion-in-comments? t
                    :server-id 'html-ls
                    :initialized-fn (lambda (w)
                                      (with-lsp-workspace w
                                                          (lsp--set-configuration
                                                           (lsp-configuration-section "html"))))
                    :download-server-fn (lambda (_client callback error-callback _update?)
                                          (lsp-package-ensure
                                           'html-language-server callback
                                           error-callback))))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection '("css-languageserver" "--stdio"))
                    :major-modes '(css-mode less-mode less-css-mode sass-mode scss-mode)
                    :remote? t
                    :priority -1
                    :action-handlers (lsp-ht ("_css.applyCodeAction" #'lsp-clients-css--apply-code-action))
                    :server-id 'css-ls))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Tramp Config
(use-package! tramp
  :config
  (appendq! tramp-remote-path
            '("/home/sggutier/bin/"
              "/home/sggutier/.local/bin/"
              "/home/sggutier/.local/share/bin/"
              "/home/sggutier/.config/composer/vendor/bin"
              "/home/sggutier/.npm-global/bin/"
              "/snap/bin/"
              "/something/that/doesnt/exist/"))
  )
