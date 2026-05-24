(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Home-manager symlinks init.el into /nix/store/ which is read-only.
;; Redirect auto-save files, backups, and custom-file to writable locations.
(let ((auto-save-dir (concat user-emacs-directory "auto-save/"))
      (backup-dir (concat user-emacs-directory "backups/")))
  (unless (file-directory-p auto-save-dir)
    (make-directory auto-save-dir t))
  (unless (file-directory-p backup-dir)
    (make-directory backup-dir t))
  (setq auto-save-file-name-transforms
        `((".*" ,auto-save-dir t)))
  (setq backup-directory-alist
        `(("." . ,backup-dir))))
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setq use-package-always-defer t
      use-package-always-ensure t)

(defun my/set-terminal-title (title)
  "Set the terminal tab title via OSC 30 (Konsole) and OSC 2 (standard)."
  (when (not (display-graphic-p))
    (send-string-to-terminal (format "\e]30;%s\e\\" title))
    (send-string-to-terminal (format "\e]2;%s\e\\" title))))

(set-face-attribute 'default nil :height 100)

;; Prefer side-by-side (left/right) splits over top/bottom
(setq split-height-threshold nil)
(setq split-width-threshold 80)

;; When displaying a buffer in another window, reuse an existing one
;; instead of creating new splits
(setq display-buffer-base-action
      '((display-buffer-reuse-window display-buffer-use-some-window)))

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package nord-theme
  :init
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook
                (lambda () (load-theme 'nord t)))
    (load-theme 'nord t)))


(setq comint-prompt-read-only t)
(use-package shell
  :ensure nil
  :config
  (setq shell-kill-buffer-on-exit t))

(use-package eat
  :demand t
  :bind ("C-c t" . eat-new)
  :config
  (defun eat-new ()
    "Open a new eat terminal buffer every time."
    (interactive)
    (let ((buf (generate-new-buffer "*eat*")))
      (pop-to-buffer-same-window buf)
      (eat-mode)
      (eat-exec buf (buffer-name buf) "/usr/bin/env" nil
                (list "sh" "-c" (or explicit-shell-file-name
                                    (getenv "ESHELL")
                                    shell-file-name)))))

  (setq eat-kill-buffer-on-exit t
        eat-term-name "xterm-256color"
        eat-enable-blinking-text t)
  (setenv "COLORTERM" "truecolor")

  ;; Map the 16 ANSI colors to your Emacs theme (Nord) so terminal
  ;; output matches the rest of Emacs
  (custom-set-faces
   '(eat-term-color-0  ((t (:foreground "#3B4252" :background "#3B4252"))))  ; black
   '(eat-term-color-1  ((t (:foreground "#BF616A" :background "#BF616A"))))  ; red
   '(eat-term-color-2  ((t (:foreground "#A3BE8C" :background "#A3BE8C"))))  ; green
   '(eat-term-color-3  ((t (:foreground "#EBCB8B" :background "#EBCB8B"))))  ; yellow
   '(eat-term-color-4  ((t (:foreground "#81A1C1" :background "#81A1C1"))))  ; blue
   '(eat-term-color-5  ((t (:foreground "#B48EAD" :background "#B48EAD"))))  ; magenta
   '(eat-term-color-6  ((t (:foreground "#88C0D0" :background "#88C0D0"))))  ; cyan
   '(eat-term-color-7  ((t (:foreground "#E5E9F0" :background "#E5E9F0"))))  ; white
   '(eat-term-color-8  ((t (:foreground "#4C566A" :background "#4C566A"))))  ; bright black
   '(eat-term-color-9  ((t (:foreground "#BF616A" :background "#BF616A"))))  ; bright red
   '(eat-term-color-10 ((t (:foreground "#A3BE8C" :background "#A3BE8C"))))  ; bright green
   '(eat-term-color-11 ((t (:foreground "#EBCB8B" :background "#EBCB8B"))))  ; bright yellow
   '(eat-term-color-12 ((t (:foreground "#81A1C1" :background "#81A1C1"))))  ; bright blue
   '(eat-term-color-13 ((t (:foreground "#B48EAD" :background "#B48EAD"))))  ; bright magenta
   '(eat-term-color-14 ((t (:foreground "#8FBCBB" :background "#8FBCBB"))))  ; bright cyan
   '(eat-term-color-15 ((t (:foreground "#ECEFF4" :background "#ECEFF4")))))); bright white



(setq use-short-answers t
      confirm-kill-emacs #'yes-or-no-p
      enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq-default fill-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(global-hl-line-mode 1)

(electric-pair-mode 1)
(delete-selection-mode 1)

(use-package diff-hl
  :demand t
  :bind
  ("C-c g n" . diff-hl-next-hunk)
  ("C-c g p" . diff-hl-previous-hunk)
  :config
  (global-diff-hl-mode 1)
  ;; Update indicators after magit operations
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

(use-package magit
  :demand t
  :config
  ;; Open files/hunks in the same window (replacing the magit buffer)
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (define-key magit-hunk-section-map (kbd "RET") #'magit-diff-visit-file)
  (define-key magit-file-section-map (kbd "RET") #'magit-diff-visit-file)


  ;; When switching projects with C-x p p, open magit + dirvish sidebar
  (defun my/project-switch-magit (project-dir)
    "Open magit-status and dirvish-side for PROJECT-DIR."
    (interactive (list (project-root (project-current t))))
    (let ((default-directory project-dir))
      (magit-status project-dir)
      (let ((main-window (selected-window)))
        (dirvish-side project-dir)
        (select-window main-window))
      ;; Set the Konsole tab title to the project name
      (my/set-terminal-title
       (file-name-nondirectory (directory-file-name project-dir)))))

  (setq project-switch-commands #'my/project-switch-magit)

  ;; Open files from a magit buffer and track them for consult
  (defvar my/magit-diff-files nil
    "List of file buffers opened from the last magit diff.")

  (defun my/first-changed-line (file)
    "Get the first changed line number in FILE compared to HEAD using git diff."
    (let* ((default-directory (magit-toplevel))
           (output (shell-command-to-string
                    (format "git diff --unified=0 -- %s" file)))
           (hunk-lines (split-string output "\n"))
           first-line)
      (dolist (line hunk-lines)
        (when (string-match "^@@ -[0-9]*,+[0-9]* \\+\\([0-9]*\\)," line)
          (let ((line-num (string-to-number (match-string 1 line))))
            (unless (zerop line-num)
              (if first-line
                  (setq first-line (min first-line line-num))
                (setq first-line line-num))))))
      first-line))

  (defun my/magit-prepare-file-buffer (file topdir)
    "Load FILE relative to TOPDIR, jump to first changed line.
Adds the buffer to `my/magit-diff-files'.  Does not display it."
    (let* ((full-path (expand-file-name file topdir))
           (buf (find-file-noselect full-path))
           (first-line (my/first-changed-line file)))
      (cl-pushnew buf my/magit-diff-files)
      (with-current-buffer buf
        (when (fboundp 'diff-hl-update)
          (diff-hl-update))
        (when first-line
          (goto-char (point-min))
          (forward-line (max 0 (- first-line 1 10)))))
      buf))

  (defun my/magit-open-at-point (&optional other-window)
    "Open the file(s) or stash at point in a magit buffer.
If a region of file sections is selected, open all of them.
If point is on a file or hunk section, open that file.
If point is on a stash, show the stash diff.
Otherwise, stay on the current magit buffer.
With prefix argument OTHER-WINDOW, display in the other window."
    (interactive "P")
    (unless (derived-mode-p 'magit-diff-mode 'magit-status-mode
                             'magit-revision-mode 'magit-merge-preview-mode)
      (user-error "Not in a magit buffer"))
    (let* ((topdir (magit-toplevel))
           (section (magit-current-section))
           (type (and section (oref section type)))
           ;; Check for region-selected files first
           (region-files (magit-region-values 'file t))
           (display-fn (if other-window
                           #'switch-to-buffer-other-window
                         #'switch-to-buffer)))
      (cond
       ;; Multiple files selected via region
       (region-files
        (let (last-buf)
          (dolist (file region-files)
            (setq last-buf (my/magit-prepare-file-buffer file topdir)))
          ;; Only display the last buffer
          (funcall display-fn last-buf))
        (message "Opened %d files (use C-x b < d to navigate)"
                 (length region-files)))
       ;; Single file or hunk section
       ((magit-file-at-point)
        (funcall display-fn
                 (my/magit-prepare-file-buffer (magit-file-at-point) topdir)))
       ;; Stash section
       ((eq type 'stash)
        (magit-stash-show (oref section value)))
       ;; Nothing specific
       (t
        (message "No file at point")))))

  ;; Highlight the file under cursor in the dirvish sidebar.
  ;; Uses post-command-hook to work with all navigation (n/p, arrows, etc.)
  (defvar my/magit-dirvish--last-file nil
    "Last file highlighted in dirvish, to avoid redundant updates.")

  (defun my/magit-highlight-in-dirvish ()
    "Update the dirvish sidebar to highlight the file at point in magit."
    (when (and (derived-mode-p 'magit-status-mode 'magit-diff-mode
                               'magit-revision-mode)
               (fboundp 'dirvish-side--session-visible-p))
      (let ((file (magit-file-at-point t)))
        (when (and file (not (equal file my/magit-dirvish--last-file))
                   (file-exists-p file))
          (setq my/magit-dirvish--last-file file)
          (when-let* ((side-win (dirvish-side--session-visible-p)))
            (with-selected-window side-win
              (let ((buffer-list-update-hook nil)
                    (window-buffer-change-functions nil)
                    (dir (file-name-directory file)))
                (or (cl-loop for (d . _) in dired-subdir-alist
                             if (string-prefix-p d (expand-file-name dir))
                             return (dired-goto-subdir d))
                    (dirvish--find-entry 'find-alternate-file dir))
                (dirvish-winbuf-change-h side-win)
                (ignore-errors
                  (if (fboundp 'dirvish-subtree-expand-to)
                      (dirvish-subtree-expand-to file)
                    (dired-goto-file file)))
                (dirvish--redisplay))))))))

  (add-hook 'post-command-hook #'my/magit-highlight-in-dirvish)

  :bind ((:map magit-diff-mode-map
          ("C-c o" . my/magit-open-at-point))
         (:map magit-status-mode-map
          ("C-c o" . my/magit-open-at-point))))

(use-package opencode
  :vc (:url "https://codeberg.org/sczi/opencode.el.git" :rev :newest)
  :bind ("C-c a" . opencode)
  :config
  (setq opencode-server-url "http://127.0.0.1:4096")
  (add-to-list 'display-buffer-alist
               '("\\*OpenCode" (display-buffer-same-window)))
  ;; Use anthropic/claude-opus-4-6 by default
  (setq opencode-last-model '((providerID . "scaleway")
                              (modelID . "qwen3.6-35b-a3b"))))

(use-package nerd-icons)
(use-package nerd-icons-completion
  :hook
  (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :init
  (nerd-icons-completion-mode 1))

(use-package dired
  :ensure nil
  :config
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  ;; this command is useful when you want to close the window of `dirvish-side'
  ;; automatically when opening a file
  (put 'dired-find-alternate-file 'disabled nil))

(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("m" "/mnt/"                       "Drives")
     ("s" "/ssh:my-remote-server")      "SSH server"
     ("e" "/sudo:root@localhost:/etc")  "Modify program settings"
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  :config
  ;; (dirvish-peek-mode)             ; Preview files in minibuffer
  (dirvish-side-follow-mode)        ; sidebar follows the current buffer's directory
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  ;; open large directory (over 20000 files) asynchronously with `fd' command
  (setq dirvish-large-directory-threshold 20000)
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish)
   ("C-c s" . dirvish-side)
   :map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
   (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
   ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
   ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("f"   . dirvish-file-info-menu)    ; [f]ile info
   ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
   ("s"   . dirvish-quicksort)         ; [s]ort flie list
   ("r"   . dirvish-history-jump)      ; [r]ecent visited
   ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
   ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
   ("*"   . dirvish-mark-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-e" . dirvish-emerge-menu)))

(use-package corfu
  :bind
  (:map
   corfu-map
   ([remap next-line] . nil)
   ([remap previous-line] . nil)
   ("<up>" . nil)
   ("<down>" . nil)
   ("RET" . nil)
   ("M-<" . corfu-first)
   ("M->" . corfu-last)
   ("C-SPC" . corfu-insert-separator)
   ("C-M-m" . corfu-move-to-minibuffer)
   ("C-M-g" . corfu-quit))
  :config
  (setq corfu-cycle t
        corfu-auto t
        corfu-on-exact-match nil
        corfu-max-width 200
        corfu-popupinfo-max-width 200
        tab-always-indent 'complete)

  (defun corfu-move-to-minibuffer ()
    (interactive)
    (pcase completion-in-region--data
      (`(,beg ,end ,table ,pred ,extras)
       (let ((completion-extra-properties extras)
             completion-cycle-threshold completion-cycling)
         (consult-completion-in-region beg end table pred)))))

  (add-to-list 'corfu-continue-commands #'corfu-move-to-minibuffer)

  (setq global-corfu-minibuffer t)

  ;; NOTE: the upstream version tries to scroll the other window. This does not
  ;; make much sense since we have another keybinding configured for that.
  (defun my/corfu-popupinfo-scroll-up (&optional n)
    "Scroll text of info popup window upward N lines.

If ARG is omitted or nil, scroll upward by a near full screen.
See `scroll-up' for details.  If the info popup is not visible,
the other window is scrolled."
    (interactive "p")
    (when (corfu-popupinfo--visible-p)
      (with-selected-frame corfu-popupinfo--frame
        (with-current-buffer " *corfu-popupinfo*"
          (scroll-up n)))))

  (advice-add #'corfu-popupinfo-scroll-up :override #'my/corfu-popupinfo-scroll-up)

  ;; Eshell configuration.
  (defun corfu-send-eshell (&rest _)
    "Send completion candidate when inside comint/eshell."
    (cond
     ((and (derived-mode-p 'eshell-mode) (fboundp 'eshell-send-input))
      (eshell-send-input))
     ((and (derived-mode-p 'comint-mode)  (fboundp 'comint-send-input))
      (comint-send-input))))

  (advice-add #'corfu-insert :after #'corfu-send-eshell)

  (dolist (hook '(shell-mode-hook eshell-mode-hook))
    (add-hook hook
              (lambda ()
                (setq-local corfu-auto nil)
                (corfu-mode 1))))
  :init
  (if (daemonp)
      (dolist (fn '(global-corfu-mode corfu-history-mode corfu-popupinfo-mode))
        (add-hook 'server-after-make-frame-hook fn))
    (global-corfu-mode 1)
    (corfu-history-mode 1)
    (corfu-popupinfo-mode 1)))

(use-package nerd-icons-corfu
  :after corfu
  :demand t
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package orderless
  :demand t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)

  ;; When inside a project, default C-x b to project-narrowed view (< p)
  (defun my/consult-buffer-project-narrow (orig-fn &optional sources)
    "Advice for `consult-buffer' that pre-narrows to project when in one."
    (if (and (not sources) (consult--project-root))
        (let ((consult--customize-alist
               (append `((consult-buffer :initial-narrow ?p))
                       consult--customize-alist)))
          (funcall orig-fn sources))
      (funcall orig-fn sources)))
  (advice-add #'consult-buffer :around #'my/consult-buffer-project-narrow)

  ;; Buffer source for files opened from magit diff
  (defvar consult--source-magit-diff-files
    `(:name "Diff Files"
      :narrow ?d
      :category buffer
      :state ,#'consult--buffer-state
      :items ,(lambda ()
                (when (bound-and-true-p my/magit-diff-files)
                  (delq nil
                        (mapcar (lambda (buf)
                                  (and (buffer-live-p buf)
                                       (buffer-name buf)))
                                my/magit-diff-files)))))
    "Consult buffer source for magit diff files.")

  (add-to-list 'consult-buffer-sources 'consult--source-magit-diff-files 'append)
)

(use-package recentf
  :ensure nil
  :demand t
  :config
  (setq recentf-max-saved-items 200)
  (recentf-mode 1))

(use-package simple
  :ensure nil
  :bind
  ("C-x k" . kill-current-buffer)
  ;; Use consult-recent-file to restore killed buffers
  ("C-x K" . consult-recent-file))

;; Taken from 'https://github.com/protesilaos/dotfiles.git'.
(defun my/keyboard-quit-dwim (top-level)
  "DWIM `keyboard-quit', it handles iedit and unfocused minibuffers.

With universal prefix arg, abort at TOP-LEVEL.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'.

ORIG-FUN will be wrapped by this advice."
  (interactive "P")
  (cond
   (top-level
    (when (bound-and-true-p iedit-mode)
      (iedit-mode -1))
    (top-level))
   ((bound-and-true-p multiple-cursors-mode)
    (funcall #'mc/keyboard-quit))
   ((region-active-p)
    (funcall #'keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   ((bound-and-true-p iedit-mode)
    (iedit-mode -1))))

(define-key global-map (kbd "C-M-g") #'my/keyboard-quit-dwim)

(use-package window
  :ensure nil
  :bind
  ([remap split-window-right] . my/split-window-right)
  ([remap split-window-below] . my/split-window-below)
  :config
  (defun my/split-window-right (&optional size window-to-split)
    (interactive `(,(when current-prefix-arg
                      (prefix-numeric-value current-prefix-arg))
                   ,(selected-window)))
    (select-window (split-window-right size window-to-split))
    (balance-windows))

  (defun my/split-window-below (&optional size window-to-split)
    (interactive `(,(when current-prefix-arg
                      (prefix-numeric-value current-prefix-arg))
                   ,(selected-window)))
    (select-window (split-window-below size window-to-split))
    (balance-windows)))

(use-package buffer-move
  :bind
  ("C-c w <left>"  . buf-move-left)
  ("C-c w <right>" . buf-move-right)
  ("C-c w <up>"    . buf-move-up)
  ("C-c w <down>"  . buf-move-down))

(winner-mode 1)
(windmove-default-keybindings 'meta)

(use-package modern-tab-bar
  :vc (:url "https://github.com/aaronjensen/emacs-modern-tab-bar.git" :rev :newest)
  :init
  (setq tab-bar-show t
        tab-bar-new-button nil
        tab-bar-close-button-show nil)

  (with-eval-after-load 'modern-tab-bar
    ;; Spacing between tabs
    (setq modern-tab-bar-separator (propertize "   " 'face 'modern-tab-bar-separator)
          modern-tab-bar-tab-horizontal-padding 4)

    (custom-set-faces
     '(modern-tab-bar ((t (:inherit default
                           :box nil
                           :background unspecified
                           :underline "#3B4252"))))
     '(modern-tab-bar-tab ((t (:background "#4C566A"
                                   :foreground "#ECEFF4"
                                   :box (:line-width 1 :color "#4C566A")))))
     '(modern-tab-bar-tab-inactive ((t (:foreground "#D8DEE9"
                                            :box (:line-width 1 :color "#434C5E")))))
     '(modern-tab-bar-tab-highlight ((t (:background "#434C5E"))))
     '(modern-tab-bar-separator ((t (:foreground unspecified
                                         :height 1.0
                                         :inherit modern-tab-bar))))
     '(tab-bar ((t (:inherit modern-tab-bar))))
     '(tab-bar-tab ((t (:inherit modern-tab-bar-tab))))
     '(tab-bar-tab-inactive ((t (:inherit modern-tab-bar-tab-inactive))))
     '(tab-bar-tab-highlight ((t (:inherit modern-tab-bar-tab-highlight))))))

  (defun my/tab-bar-padding ()
    "Add padding row below tab bar."
    (propertize "\n" 'face 'modern-tab-bar))

  (setq tab-bar-format '(tab-bar-format-tabs
                         modern-tab-bar-suffix
                         my/tab-bar-padding))

  (defun my/tab-bar-tab-name-project ()
    "Name the tab after the current project, or fall back to the current buffer."
    (let ((project (project-current)))
      (if project
          (file-name-nondirectory (directory-file-name (project-root project)))
        (tab-bar-tab-name-current))))

  (setq tab-bar-tab-name-function #'my/tab-bar-tab-name-project)

  (modern-tab-bar-mode 1))

;; System clipboard integration in terminal mode (uses wl-copy/wl-paste on Wayland)
;; Ensure WAYLAND_DISPLAY is set (emacs daemon starts before the env is inherited)
(unless (getenv "WAYLAND_DISPLAY")
  (setenv "WAYLAND_DISPLAY" "wayland-0"))
(use-package xclip
  :demand t
  :config
  (xclip-mode 1))

;; YAML syntax highlighting
(use-package yaml-mode
  :mode "\\.ya?ml\\'")
