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

;; Better scrolling
(setq scroll-margin 2)

;; Disable default startup message
(setq inhibit-startup-message t)

;; Recent Items
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
         (c-mode   . lsp-deferred))

  :init
  (setq lsp-keymap-prefix "C-c l")  ;; LSP commands under C-c l
  :config
  (setq lsp-enable-symbol-highlighting t
        lsp-enable-snippet t
        lsp-enable-on-type-formatting nil)) ;; format on save instead

;; LSP-ui package
(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Web Dev
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Web-mode package
(use-package web-mode
  :mode ("\\.html?\\'" "\\.ejs\\'")
  :hook ((web-mode . lsp-deferred)
	 (web-mode . emmet-mode))
   
  :config
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2))

;; Emmet-mode package
(use-package emmet-mode
  :hook ((html-mode . emmet-mode)
         (css-mode  . emmet-mode)))


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
;; Rebinding
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Rebind `make-frame-command`
(global-set-key (kbd "C-c n") `make-frame-command)
;; Unbind the orginal keybinding
(global-unset-key (kbd "C-x 52"))

;; Rebind `move-end-of-line`
(global-set-key (kbd "C-;") `move-end-of-line)
;; Unbind the original keybinding
(global-unset-key (kbd "C-e"))

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
 '(line-number ((t (:foreground "#4c4f69" :background "#232629"))))
 '(line-number-current-line ((t (:foreground "#eff0f1" :background "#232629" :weight bold))))
 '(minibuffer-prompt ((t (:foreground "#0d7b69" :weight bold))))
 '(mode-line ((t (:background "#232629" :foreground "#eff0f1" :box nil))))
 '(mode-line-inactive ((t (:background "#232629" :foreground "#4c4f69" :box nil))))
 '(region ((t (:background "#0d7b69" :foreground "#232629")))))

(provide 'init)
;;; init.el ends here
