;;; init-python.el --- Python configuration  -*- lexical-binding: t; -*-

;;; Code:

(use-package python
  :ensure nil  ; built-in
  :custom
  (python-indent-offset 4))

;; Virtual environment support
(use-package pyvenv
  :config
  (pyvenv-mode 1))

(provide 'init-python)
;;; init-python.el ends here
