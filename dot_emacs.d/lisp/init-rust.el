;;; init-rust.el --- Rust configuration  -*- lexical-binding: t; -*-

;;; Code:

(use-package rust-mode)

(use-package flycheck-rust
  :hook (rust-mode . flycheck-rust-setup))

(provide 'init-rust)
;;; init-rust.el ends here
