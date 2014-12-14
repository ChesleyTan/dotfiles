(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
)

;; check if gui running
;; (if window-system
    ;; if gui running, load solarized theme
    ;; (load-theme 'solarized-dark t)
    ;; if not gui running, load monokai theme
    ;; (load-theme 'monokai t))

(load-theme 'monokai t)

;; load evil
(require 'evil)
(evil-mode 1)
;; load evil-tabs
(global-evil-tabs-mode t)

;; show line numbers
(require 'linum)
(global-linum-mode 1)
(setq linum-format "%4d\u2502")

;; enable Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
