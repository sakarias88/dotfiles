(menu-bar-mode -1)
(tool-bar-mode -1)
(show-paren-mode 1)
(xclip-mode 1)
(xterm-mouse-mode 1)
(toggle-scroll-bar -1)
(set-default 'truncate-lines t)

;; Automatically reload files when they change on disk
(setq auto-revert-check-vc-info t)
(setq auto-revert-avoid-polling t)
(global-auto-revert-mode t)

;; Used for snippets, for example auto complete an implementation for an interface
(require 'yasnippet)
(yas-global-mode 1)

;;set gdb debugger to use separate window
(setq gdb-many-windows t gdb-use-separate-io-buffer t)

;;highlight current line number
(setq column-number-mode t)

;;scroll window up/down by one line
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

;; dap mode debugging
(require 'dap-lldb)
(dap-auto-configure-mode 1)
(set-default 'dap-lldb-degub-program "lldb-vscode")

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
	  (neotree-dir (getenv "PWD"))
	  (projectile-mode +1)
	  (global-set-key (kbd "C-x p") 'fzf)
	  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
	  (global-set-key [f8] 'neotree-toggle)
	  (neotree-hide)
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

;; Add rainbow delimiters for rust language
(add-hook 'rust-mode-hook #'rainbow-delimiters-mode)

;; Add rainbow delimiters for most languages
;;(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(require 'rust-mode)
(add-hook 'rust-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq lsp-rust-server 'rust-analyzer)
            (cargo-minor-mode)
            (lsp)))

(add-hook 'c-mode-hook
          (lambda ()
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

;;Clojure

;; Format on save
(add-hook 'before-save-hook
          (lambda ()
            (when (or
                   (eq 'clojure-mode major-mode)
                   (eq 'clojurescript-mode major-mode))
              (lsp-format-buffer))))

;; Add rainbow delimiters for lsp
(add-hook 'lsp-mode-hook #'rainbow-delimiters-mode)

(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-minimum-prefix-length 1
      lsp-signature-auto-activate nil
      ; lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      )
