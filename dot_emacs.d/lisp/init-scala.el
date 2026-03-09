;;; init-scala.el --- Scala configuration  -*- lexical-binding: t; -*-

;;; Code:

(use-package scala-mode
  :interpreter ("scala" . scala-mode))

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(provide 'init-scala)
;;; init-scala.el ends here
