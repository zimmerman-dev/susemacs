;;; init.el --- Personal Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration.
;; Organized by feature using use-package.
;; Designed for C++, web development, and general programming workflows.

;;; Code:

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

;; Doom Themes package
(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config)) ;; Optional: org-mode styles

;; Set default font (only if available)
(when (member "ZedMono Nerd Font Mono" (font-family-list))
  (set-face-attribute 'default nil :font "ZedMono Nerd Font Mono" :height 140))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI Tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Line numbers
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(global-hl-line-mode 1)

;; Disable default startup message
(setq inhibit-startup-message t)

;; Recent Items
(defvar recentf-max-saved-items)

(recentf-mode 1)
(with-eval-after-load 'recentf
  (setq recentf-max-saved-items 100))

;; Save position in file
(save-place-mode 1)

;; Background transparency (used by KDE compositor for blur)
;;(set-frame-parameter nil 'alpha-background 90)
;;(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Default window size
(setq initial-frame-alist
      '((top . 100)     ;; vertical offset from top
        (left . 100)   ;; horizontal offset from left
        (width . 80)
        (height . 60)))

(setq initial-frame-alist default-frame-alist)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Scroll Behavior
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Comfier scroll
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101)
(setq scroll-margin 0)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Avy package
(use-package avy
  :ensure t
  :bind
  ;; Jump to visible text quickly
  ("M-j" . avy-goto-char-timer))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pulsar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Pulsar package
(use-package pulsar
  :ensure t
  :init
  ;; 1. Customize how the pulse looks
  (setq pulsar-pulse t)
  (setq pulsar-delay 0.055)          ; How long the pulse lasts
  (setq pulsar-iterations 10)        ; Number of pulse cycles

  ;; 2. Use the generic pulse face
  (setq pulsar-face 'pulsar-generic)

  ;; 3. Customize the pulse color
  (custom-set-faces
   '(pulsar-generic ((t (:background "#89D2DC" :extend t)))))

  ;; 4. Choose when Pulsar activates
  (setq pulsar-pulse-functions
        '(recenter-top-bottom
          move-to-window-line-top-bottom
          reposition-window

          ;; Window navigation
          other-window
          delete-window
          delete-other-windows

          ;; Buffer navigation
          next-buffer
          previous-buffer

          ;; Goto line / jumping
          goto-line
          consult-goto-line
          imenu
          xref-find-definitions
          xref-go-back

          ;; Scrolling
          scroll-up-command
          scroll-down-command))

  :config
  ;; Enable Pulsar globally across all buffers
  (pulsar-global-mode 1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Startup Behavior
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Startup Behavior
(add-hook 'emacs-startup-hook
          (lambda ()
            (dolist (buf '("*scratch*"))
              (when (get-buffer buf)
                (kill-buffer buf)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Splash Screen / Dashboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Projectile package
(use-package projectile
  :init
  (setq projectile-project-search-path '("~/projects/"))
  (setq projectile-completion-system 'auto)
  (projectile-mode +1))

;; Dashboard package
(use-package dashboard
  :config
  ;; Banner image
  (setq dashboard-startup-banner "~/.emacs.d/assets/hmacs.png")

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
;; Org Mode Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Org mode package
(use-package org
  :config
  (setq org-agenda-files '("~/Documents/Notes/todo.org")))

;; Word Wrap
(add-hook 'org-mode-hook #'visual-line-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal Integration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; VTerm package
(use-package vterm
  :commands vterm
  :custom
  (vterm-always-compile-module t)
  :bind
  ("<f7>" . vterm))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; LSP-mode package
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c++-mode . lsp-deferred)
         (c-mode   . lsp-deferred)
	 (web-mode . lsp-deferred)
	 (js2-mode . lsp-deferred))
  
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
;; Web dev
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Web-mode package
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode))
  :config
  (setq web-mode-enable-auto-quoting nil))

;; Emmet-mode package
(use-package emmet-mode
  :hook (web-mode css-mode)
  :config
  (setq emmet-self-closing-tag-style " /"))

;; Javascript (js2-mode) package
(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode))
  :interpreter "node"
  :config
  (setq js2-basic-offset 2))


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
;; Rebinding
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Rebind `make-frame-command`
(global-set-key (kbd "C-c n") `make-frame-command)
;; Unbind the orginal keybinding
(global-unset-key (kbd "C-x 52"))

;; Rebind `move-end-of-line`
(global-set-key (kbd "C-;") `move-end-of-line)
;; Unbind the original keybinding
;; (global-unset-key (kbd "C-e"))

;; Rebind `other-frame`
(global-set-key (kbd "C-c f") `other-frame)
;; Unbind the original keybinding
(global-unset-key (kbd "C-x 5o"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Buffer Navigation - Toggle Mode
(defun my/buffer-toggle-map ()
  "Transient keymap where `n` and `p` navigate buffers."
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'next-buffer)
    (define-key map (kbd "p") #'previous-buffer)
    map))

(defun my/enter-buffer-toggle-mode ()
  "Enter transient buffer navigation mode with `n` and `p`."
  (interactive)
  (message "Buffer Toggle Mode: [n] next | [p] previous | [any other key] exit")
  (set-transient-map (my/buffer-toggle-map) t))

(global-set-key (kbd "C-x t") #'my/enter-buffer-toggle-mode)

;; New line above current line
(defun open-line-above ()
  "Insert an empty line above the current line without moving point."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (open-line 1)))

(global-set-key (kbd "C-M-o") #'open-line-above)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Face Settings (auto-generated)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(avy company dashboard doom-themes emmet-mode flycheck js2-mode
	 lsp-ui projectile pulsar rainbow-mode ultra-scroll vterm
	 web-mode yaml-mode yasnippet-snippets)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#232629" :foreground "#eff0f1"))))
 '(cursor ((t (:background "#0d7b69"))))
 '(font-lock-builtin-face ((t (:foreground "#0b0" :weight bold))))
 '(font-lock-comment-face ((t (:foreground "#4c4f69" :slant italic))))
 '(font-lock-function-name-face ((t (:foreground "#0d7b69"))))
 '(font-lock-keyword-face ((t (:foreground "#0d7b69" :weight bold))))
 '(font-lock-string-face ((t (:foreground "#0b0"))))
 '(font-lock-type-face ((t (:foreground "#0b0" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#eff0f1"))))
 '(font-lock-warning-face ((t (:foreground "#f67400" :weight bold))))
 '(fringe ((t (:background "#232629"))))
 '(highlight ((t (:background "#0d7b69" :foreground "#232629"))))
 '(hl-line ((t (:background "#0d7b69"))))
 '(line-number ((t (:foreground "#4c4f69" :background "#232629"))))
 '(line-number-current-line ((t (:foreground "#eff0f1" :background "#232629" :weight bold))))
 '(minibuffer-prompt ((t (:foreground "#0d7b69" :weight bold))))
 '(mode-line ((t (:background "#232629" :foreground "#eff0f1" :box nil))))
 '(mode-line-inactive ((t (:background "#232629" :foreground "#4c4f69" :box nil))))
 '(pulsar-generic ((t (:background "#0d7b69" :extend t))))
 '(region ((t (:background "#0d7b69" :foreground "#232629")))))

(provide 'init)
;;; init.el ends here
