;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package System & Bootstrapping
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-enable-at-startup nil) ;; Prevent double-init

;; Add MELPA
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Install and require use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme & Font Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Load Doom Themes
(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config)) ;; Optional: org-mode styles

;; Set default font (only if available)
(when (member "JetBrainsMono Nerd Font Mono" (font-family-list))
  (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 140))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI Tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Line numbers
(global-display-line-numbers-mode 1)
(column-number-mode 1)

;; Better scrolling
(setq scroll-margin 2)

;; Disable default startup message
(setq inhibit-startup-message t)

;; Recent Items
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Save position in file
(save-place-mode 1)

;; Background transparency (used by KDE compositor for blur)
;;(set-frame-parameter nil 'alpha-background 90)
;;(add-to-list 'default-frame-alist '(alpha-background . 90))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :config
  (setq org-agenda-files '("~/Documents/Notes/todo.org")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal Integration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vterm
  :commands vterm
  :custom
  (vterm-always-compile-module t)
  :bind
  ("<f7>" . vterm))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Splash Screen / Dashboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Projectile
(use-package projectile
  :init
  (setq projectile-project-search-path '("~/projects/"))
  (setq projectile-completion-system 'auto)
  (projectile-mode +1))

;; Dashboard
(use-package dashboard
  :config
  ;; Banner image
  (setq dashboard-startup-banner "~/.emacs.d/assets/SUSEmacs1.png")

  ;; Show these sections
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)
                          (agenda   . 5)))

  ;; Force the correct project backend
  (setq dashboard-projects-backend 'projectile)

  ;; Visual extras
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)

  ;; Initialize dashboard on startup
  (dashboard-setup-startup-hook))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; LSP-mode package
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c++-mode . lsp-deferred)
         (c-mode   . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Optional: LSP commands under C-c l
  :config
  (setq lsp-enable-symbol-highlighting t
        lsp-enable-snippet t
        lsp-enable-on-type-formatting nil)) ;; we’ll format on save instead

;; LSP-ui package
(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Company package
(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-tooltip-align-annotations t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Diagnostics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Flycheck package
(use-package flycheck
  :hook (prog-mode . flycheck-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Snippets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Yasnippet package
(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto-Pairs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(electric-pair-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Color Codes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Rainbow-mode package
(use-package rainbow-mode
  :ensure t
  :hook ((prog-mode . rainbow-mode)
	 (css-mode . rainbow-mode)
	 (emacs-lisp-mode . rainbow-mode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Face Settings (auto-generated)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#232629" :foreground "#eff0f1"))))
 '(cursor ((t (:background "#0d7b69"))))
 '(font-lock-comment-face ((t (:foreground "#4c4f69" :slant italic))))
 '(font-lock-function-name-face ((t (:foreground "#0d7b69"))))
 '(font-lock-keyword-face ((t (:foreground "#0d7b69" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "#0b0" :weight bold))))
 '(font-lock-string-face ((t (:foreground "#0b0"))))
 '(font-lock-type-face ((t (:foreground "#0b0" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#eff0f1"))))
 '(font-lock-warning-face ((t (:foreground "#f67400" :weight bold))))
 '(fringe ((t (:background "#232629"))))
 '(highlight ((t (:background "#0d7b69" :foreground "#232629"))))
 '(line-number ((t (:foreground "#4c4f69" :background "#232629"))))
 '(line-number-current-line ((t (:foreground "#eff0f1" :background "#232629" :weight bold))))
 '(minibuffer-prompt ((t (:foreground "#0d7b69" :weight bold))))
 '(mode-line ((t (:background "#232629" :foreground "#eff0f1" :box nil))))
 '(mode-line-inactive ((t (:background "#232629" :foreground "#4c4f69" :box nil))))
 '(region ((t (:background "#0d7b69" :foreground "#232629")))))

