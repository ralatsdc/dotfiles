;;; early-init.el --- Early initialization  -*- lexical-binding: t; -*-

;;; Commentary:
;; Runs before init.el.  Sets up package archives and frame defaults.

;;; Code:

;; Package archives
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; Prefer GNU/NonGNU over MELPA when versions match
(setq package-archive-priorities
      '(("gnu"    . 10)
        ("nongnu" . 5)
        ("melpa"  . 0)))

;; Frame defaults — set early to avoid flicker
(setq default-frame-alist
      '((top    . 1)
        (left   . 100)
        (width  . 130)
        (height . 65)))

;; Suppress the startup screen
(setq inhibit-startup-screen t)

;;; early-init.el ends here
