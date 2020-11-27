(menu-bar-mode -1)
(tool-bar-mode -1)
(show-paren-mode 1)
(xclip-mode 1)
(xterm-mouse-mode 1)
(toggle-scroll-bar -1)
(set-default 'truncate-lines t)

;; helm
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;; do not use tabs
(setq-default indent-tabs-mode nil)

;; Windmove default for moving between buffers with shift + arrow
(windmove-default-keybindings)

;; Override defaukt to work in terminal
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


(global-display-line-numbers-mode 1)
(setq neo-show-hidden-files t)
(global-set-key (kbd "C-x g") 'magit-status)
(global-whitespace-mode 1)

(set-face-attribute 'default nil :height 100)

;; example of setting env var named “path”, by appending a new path to existing path
(setenv "FZF_DEFAULT_COMMAND"
   "rg --files"
   )

(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq require-final-newline t)

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


          ;; Add lsp which key mode integration (help command text at bottom)
          (which-key-mode)
	  ))

(require 'lsp-mode)
(setq-default lsp-signature-render-documentation nil)
(setq-default lsp-rust-analyzer-cargo-watch-command "clippy")
(setq-default lsp-rust-analyzer-cargo-watch-enable t)
(setq-default lsp-rust-analyzer-cargo-all-targets t)
(setq-default lsp-rust-all-features t)
(setq-default lsp-rust-all-targets t)

(setq-default lsp-pyls-plugins-pylint-enabled t)
(setq-default lsp-pyls-plugins-flake8-enabled t)

(add-hook 'python-mode-hook #'lsp)
(add-hook 'elm-mode-hook #'lsp)
(add-hook 'elm-mode-hook 'elm-format-on-save-mode)
(add-hook 'python-mode-hook 'blacken-mode)

(require 'rust-mode)
(add-hook 'rust-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq lsp-rust-server 'rust-analyzer)
            (lsp)))

(add-hook 'before-save-hook (lambda () (when (eq 'rust-mode major-mode)
                                           (lsp-format-buffer))))

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

;; add hook for which-key-mode
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))
