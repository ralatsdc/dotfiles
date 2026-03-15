;;; init.el --- Main Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Modernized configuration using use-package (built into Emacs 29+),
;; eglot (built-in LSP client), and corfu (in-buffer completion).
;; Replaces the previous init-*.el / .emacs-*.el dual-config system.

;;; Code:

;;;; Bootstrap ----------------------------------------------------------------

;; Ensure use-package installs missing packages automatically
(require 'use-package)
(setq use-package-always-ensure t)

;; Inherit PATH and environment from the shell
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;;;; General settings ---------------------------------------------------------

(setq-default fill-column 79
              indent-tabs-mode nil
              tab-width 4)

;; Dired
(setq default-directory (expand-file-name "~/Projects"))

;; Ispell via MacPorts aspell
(setq ispell-program-name "/opt/local/bin/aspell")

;; Abbrev
(setq abbrev-file-name (expand-file-name "abbrev_defs" user-emacs-directory))

;; Org-babel languages
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell  . t)
     (python . t)
     (R      . t))))

;;;; Completion (corfu + cape + orderless) ------------------------------------

;; Load language-specific and tool configuration from lisp/
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  :init
  (global-corfu-mode))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

;;;; Version control ----------------------------------------------------------

(use-package magit
  :bind ("C-x g" . magit-status))

;;;; Syntax checking ----------------------------------------------------------

(use-package flycheck
  :init (global-flycheck-mode))

;;;; Snippets -----------------------------------------------------------------

(use-package yasnippet
  :config (yas-global-mode 1))

;;;; Minibuffer completion (vertico + consult + marginalia) -------------------

(use-package vertico
  :init
  (vertico-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("M-x"     . execute-extended-command)  ; uses vertico automatically
         ("C-x C-f" . find-file)                 ; uses vertico automatically
         ("C-x b"   . consult-buffer)
         ("M-s l"   . consult-line)              ; search lines in current buffer
         ("M-s g"   . consult-grep)              ; grep across files
         ("M-s r"   . consult-ripgrep)           ; ripgrep across files
         ("M-g g"   . consult-goto-line)
         ("M-g M-g" . consult-goto-line)))

;;;; LSP via eglot (built-in since Emacs 29) ----------------------------------

(use-package eglot
  :ensure nil  ; built-in
  :hook ((python-mode    . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (rust-mode      . eglot-ensure)
         (rust-ts-mode   . eglot-ensure)
         (js-mode        . eglot-ensure)
         (js-ts-mode     . eglot-ensure)
         (java-mode      . eglot-ensure)
         (java-ts-mode   . eglot-ensure)
))

;;;; JSON formatting -----------------------------------------------------------

(defun my/json-format-buffer-before-save ()
  "Format JSON buffer before saving."
  (add-hook 'before-save-hook #'json-pretty-print-buffer nil t))

(add-hook 'json-mode-hook    #'my/json-format-buffer-before-save)
(add-hook 'json-ts-mode-hook #'my/json-format-buffer-before-save)

;;;; Language modes ------------------------------------------------------------

(require 'init-python)
(require 'init-javascript)
(require 'init-rust)
(require 'init-java)
(require 'init-r)
(require 'init-yaml)
(require 'init-matlab)

;;; init.el ends here
