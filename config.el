;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Niankun Rao"
      user-mail-address "niankun_rao@selinc.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'atom-one-dark)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;
;;

;; setup tab
(setq-default indent-tabs-mode nil)
(setq-default default-tab-width 3)
(setq-default c-default-style "linux"
              c-basic-offset 3)

;; Format the code on save
(defun clang-format-on-save ()
  (add-hook 'before-save-hook #'clang-format-buffer nil 'local))
(add-hook 'c++-mode-hook 'clang-format-on-save)
(add-hook 'c-mode-hook 'clang-format-on-save)

(defun vhdl-beautify-on-save ()
  (add-hook 'before-save-hook #'vhdl-beautify-buffer nil 'local)
  )
(add-hook 'vhdl-mode-hook 'vhdl-beautify-on-save)

;; 80 column marker
;; Activate column indicator in prog-mode and text-mode
(add-hook 'prog-mode-hook 'turn-on-fci-mode)
(add-hook 'text-mode-hook 'turn-on-fci-mode)

;; flycheck setup
(require 'flycheck)
(setq-default flycheck-disabled-checkers '(c/c++-clang))
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'vhdl-mode-hook 'flycheck-mode)
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "gnu++17")))
(add-hook 'c-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++17")))
;; (add-hook 'c++-mode-hook (lambda () (setq flycheck-cppcheck-checks "all")))
;; (add-hook 'c++-mode-hook (lambda () (setq flycheck-cppcheck-standards "c++17")))

(add-hook 'vhdl-mode-hook (lambda () (setq flycheck-ghdl-language-standard "93")))
(add-hook 'vhdl-mode-hook (lambda () (setq flycheck-ghdl-ieee-library "synopsys")))

;; auto package update
(require 'auto-package-update)
(auto-package-update-maybe)

;; enable indent guide
(require 'indent-guide)
(indent-guide-global-mode)

;; diff highlight
(global-git-commit-mode t)

'(version-control :variables
                version-control-diff-tool 'diff-hl)
'(version-control :variables
                version-control-diff-side 'left)
'(version-control :variables
                version-control-global-margin t)
(global-diff-hl-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; maximize window at startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; configuration of auto-complete
;; (ac-config-default)

;; company configuration
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.2
      company-minimum-prefix-length 3)

;; vivado mode for .xdc files
(setq auto-mode-alist (cons '("\\.xdc\\'" . vivado-mode) auto-mode-alist))
(add-hook 'vivado-mode-hook '(lambda () (font-lock-mode 1)))
(autoload 'vivado-mode "vivado-mode")

;; Setup evil-multiedit
(require 'evil-multiedit)
;; Highlights all matches of the selection in the buffer.
(define-key evil-visual-state-map "R" 'evil-multiedit-match-all)

;; Match the word under cursor (i.e. make it an edit region). Consecutive presses will
;; incrementally add the next unmatched match.
(define-key evil-normal-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
;; Match selected region.
(define-key evil-visual-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
;; Insert marker at point
(define-key evil-insert-state-map (kbd "M-d") 'evil-multiedit-toggle-marker-here)

;; Same as M-d but in reverse.
(define-key evil-normal-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
(define-key evil-visual-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)

;; OPTIONAL: If you prefer to grab symbols rather than words, use
;; `evil-multiedit-match-symbol-and-next` (or prev).

;; Restore the last group of multiedit regions.
(define-key evil-visual-state-map (kbd "C-M-D") 'evil-multiedit-restore)

;; RET will toggle the region under the cursor
(define-key evil-multiedit-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)

;; ...and in visual mode, RET will disable all fields outside the selected region
(define-key evil-motion-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)

;; For moving between edit regions
(define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
(define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev)

;; Ex command that allows you to invoke evil-multiedit with a regular expression, e.g.
(evil-ex-define-cmd "ie[dit]" 'evil-multiedit-ex-match)

;; keybinding for helm-projectile-ag
(map!
 (:leader
   (:desc "M-x"                   :n "SPC" #'execute-extended-command)
   (:desc "helm-projectile-ag"    :n "/"   #'helm-projectile-ag)
   (:desc "Switch to last buffer" :n "TAB" #'switch-to-prev-buffer)
 )
)
;; (global-set-key (kbd "M-s") 'helm-projectile-ag)