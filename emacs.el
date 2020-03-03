(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(windmove-default-keybindings)
(global-display-line-numbers-mode 1)
(setq neo-show-hidden-files t)
(global-set-key (kbd "C-x g") 'magit-status)
(global-whitespace-mode 1)

(set-face-attribute 'default nil :height 100)

;; example of setting env var named “path”, by appending a new path to existing path
(setenv "FZF_DEFAULT_COMMAND"
   "rg --files"
)

(add-hook 'after-init-hook (lambda ()
          (load-theme 'nord t)
	  (neotree-dir "~/code")
	  (projectile-mode +1)
	  (global-set-key (kbd "C-x p") 'fzf)
	  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
	  (global-set-key [f8] 'neotree-toggle)
	  
	  (require 'yaml-mode)
	  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
	  (require 'protobuf-mode)
	  ))

(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)
(add-hook 'elm-mode-hook #'lsp)
(add-hook 'elm-mode-hook 'elm-format-on-save-mode)
(add-hook 'python-mode-hook 'blacken-mode)

(require 'rust-mode)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(eval-after-load 'flymake
  (progn
    (require 'flymake-diagnostic-at-point)
    (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)))

(add-hook 'neo-after-create-hook
(lambda (&rest _) (display-line-numbers-mode -1)))

;; Put auto save files somewhere else which is surprisingly hard to do
(setq backup-directory-alist '((".*" . "~/.skit")))
(setq auto-save-file-name-transforms '((".*" "~/.skit/\\1" t)))
(setq create-lockfiles nil)


;; protobuff
  (defconst my-protobuf-style
    '((c-basic-offset . 2)
      (indent-tabs-mode . nil)))

  (add-hook 'protobuf-mode-hook
    (lambda () (c-add-style "my-style" my-protobuf-style t)))
