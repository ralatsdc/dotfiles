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

;; Ruff integration via python-lsp-server
;; Install with: pip install python-lsp-ruff
;; pylsp delegates linting and formatting to ruff while still
;; providing completions, hover, and go-to-definition.
(setq-default eglot-workspace-configuration
              '(:pylsp (:plugins (:ruff (:enabled t :formatEnabled t)
                           :jedi_signature_help (:enabled :json-false)))))

;; Format with ruff (via pylsp) on save
(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
(add-hook 'python-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)))

(provide 'init-python)
;;; init-python.el ends here
