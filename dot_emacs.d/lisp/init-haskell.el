;;; init-haskell.el --- Haskell configuration  -*- lexical-binding: t; -*-

;;; Code:

(use-package haskell-mode)

(use-package flycheck-haskell
  :hook (haskell-mode . flycheck-haskell-setup))

(provide 'init-haskell)
;;; init-haskell.el ends here
