
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(fill-column 100)
 '(org-agenda-files (quote ("~/org/")))
 '(org-directory "~/org/")
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 4))))
 '(org-refile-use-outline-path (quote file))
 '(org-tags-column -90)
 '(show-paren-mode t)
 '(show-paren-style (quote mixed)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :family "Droid Sans Mono"))))
 '(minibuffer-prompt ((t (:background "orange" :foreground "medium blue")))))

(require 'ediff)

;; Own Functions
;; Put your 'defun's here
;; (require 'lisp) 


(defun turn-on-truncation() 
  "Enable line truncation by default"
  (setq truncate-lines t)
)

;; This is a script for selecting a block. Any block that is a paren-based
;; sexp that is at point is selected.

(defun select-block()
  "Select block starting at point"
  (interactive )
  (cond ( 
         (eq (mark-sexp) (kill-ring-save (mark) (point)))
         (message "Saved block starting at point")
         )
   )
  )

;; This is a lisp defun for copying the name of the file at current line
;; (the complete name). THIS WORKS ONLY IN DIRED BUFFERS.
;; It automatically converts the filename separators from / to \, since both
;; emacsen and Windozen can understand these.

(defun dired-append-file-name-at-point()
  "Add name of the selected dired entry to the end of kill ring"
  (interactive )
  (cond (
         (kill-new (replace-regexp-in-string "/" "\\\\" (dired-get-filename)))
         (message "Added filename to kill-ring")
         )
        )
  )

;; Koushik MS - 20100622
;; =============================================================================
;; Configure color-theme. reapply-color-theme is entry point for selecting color 
;; theme.
;; =============================================================================
;;; Setup Color Theme
;;; (require 'color-theme)

(defun reapply-color-theme()
  "Apply the currently selected color theme"
  ;; Note: Everytime color-theme is changed, pls re-customize the faces. Any customization on a face,
  ;; overrides ALL customization from color-theme, and in startup sequence, color-theme is applied
  ;; first and _then_ custom-set-face is applied. This leads to some attributes (esp bg, fg color)
  ;; being out of sync with the color-theme
  (interactive)
  ;; (color-theme-blue-mood)
  ;; (color-theme-charcoal-black)
  ;; (color-theme-gnome)
  ;; (color-theme-aalto-light)
  ;; (color-theme-goldenrod)
  ;; (color-theme-high-contrast)
  ;; (color-theme-dark-blue2)
  ;; (color-theme-sitaramv-nt)
  ;; (color-theme-snowish)
  ;; (require 'color-theme-less)
  ;; (color-theme-less)
  ;; (require 'color-theme-subdued)
  ;; (color-theme-subdued)
  ;; (require 'color-theme-gruber-darker)
  ;; (color-theme-gruber-darker)
  )
;; Koushik MS - 20091118

;; This lisp defun creates a new frame and open an org-mode file in that buffer
(defun get-organized() 
  "Open an exclusive frame for org-files"
  (interactive)
  (select-frame (make-frame))
  (find-file (concat org-directory "gtd.org"))
  )

;; =============================================================================
;; Koushik MS - 20091218, Fun with cursor type & color.
;; =============================================================================
;; Cool piece of code from http://emacs-fu.blogspot.com/2009/12/changing-cursor-color-and-shape.html
;; Change cursor color according to mode; inspired by
;; http://www.emacswiki.org/emacs/ChangingCursorDynamically
(setq djcb-read-only-color       "blue")

;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar. HEIGHT); see the docs for set-cursor-type
(setq djcb-read-only-cursor-type '(hbar . 20))
(setq djcb-overwrite-color       "turquoise")
(setq djcb-overwrite-cursor-type 'box)
(setq djcb-normal-color          "turquoise")
(setq djcb-normal-cursor-type    '(bar . 3))

(defun djcb-set-cursor-according-to-mode ()
  "change cursor color and type according to some minor modes."

  (cond
    (buffer-read-only
      (set-cursor-color djcb-read-only-color)
      (setq cursor-type djcb-read-only-cursor-type))
    (overwrite-mode
      (set-cursor-color djcb-overwrite-color)
      (setq cursor-type djcb-overwrite-cursor-type))
    (t 
      (set-cursor-color djcb-normal-color)
      (setq cursor-type djcb-normal-cursor-type))))

(add-hook 'post-command-hook 'djcb-set-cursor-according-to-mode)
;; =============================================================================

; Show selections
(transient-mark-mode 1)
(setq mouse-drag-copy-region nil)  ; stops selection with a mouse being immediately injected to the
                                   ; kill ring
(setq x-select-enable-primary nil)  ; stops killing/yanking interacting with primary X11 selection
(setq x-select-enable-clipboard t)  ; makes killing/yanking interact with clipboard X11 selection
(setq select-active-regions t) ;  active region sets primary X11 selection
(global-set-key [mouse-2] 'mouse-yank-primary)  ; make mouse middle-click only paste from primary
                                                ; X11 selection, not clipboard and kill ring.
;; with this, doing an M-y will also affect the X11 clipboard, making emacs act as a sort of
;; clipboard history, at least of text you've pasted into it in the first place.  Enable this if all goes well.
;; (setq yank-pop-change-selection t) ; makes rotating the kill ring change the X11 clipboard.


(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 135))

;; Programming
;; -----------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(global-set-key "\C-b" 'select-block)

(put 'downcase-region 'disabled nil)


;; File Management/ Exploring
;; --------------------------
; Bind dired-x-find-file and dired-x-find-file-other-window over
; find-file and find-file-other-window respectively.
; (setq dired-x-hands-off-my-keys nil)
; (dired-x-bind-find-file)

(add-hook 'dired-load-hook
          (lambda ()
            (define-key dired-mode-map "c" 'dired-append-file-name-at-point)
            (define-key dired-mode-map " " 'isearch-forward)
            (define-key dired-mode-map [(ctrl return)] 'dired-find-file-other-frame)
            (define-key dired-mode-map "\d" 'dired-up-directory)
            )
          )

(add-hook 'dired-x-load-hook
          (lambda () (setq dired-x-hands-off-my-keys nil)))
(add-hook 'dired-x-load-hook
          (lambda () (dired-x-bind-find-file)))

(setq dired-dwim-target t)
(setq dired-recursive-copies t)

;;; Hack dired to launch files with 'l' key.  Put this in your ~/.emacs file

(defun dired-launch-command ()
  (interactive)
  (dired-do-shell-command 
   (case system-type       
     (gnu/linux "gnome-open") ;right for gnome (ubuntu), not for other systems
     (darwin "open"))
   nil
   (dired-get-marked-files t current-prefix-arg)))

(setq dired-load-hook
      (lambda (&rest ignore)
 (define-key dired-mode-map
   "l" 'dired-launch-command)))

(setq find-ls-option '("-print0 | xargs -0 ls  -ld" . "-d"))



;;; =====================================================================
;;  autoload dired-jump
;;  This function allows the user to jump from a file being edited to the
;;  dired buffer showing its directory contents. A new buffer is created 
;;  if one doesn't exist. Got to checkout how cool this really is - eg.,
;;  does it detect subdirectories included in dired buffers of "parent"
;;  directory and jump to them ? 
(define-key global-map "\C-x\C-j" 'dired-jump)

;;; ======================================================================
;;; Configure Org-mode
;;; ======================================================================

;; Keybindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; <C-tab> mapped to visibility cycling commands in org mode buffers
(global-set-key (kbd "<C-S-iso-lefttab>") 'other-window) 
(global-set-key "\C-xg" 'get-organized)
(global-set-key [f11] 'get-organized)

;; Todo keywords
(setq org-todo-keywords
      '((sequence "TODO(t)" "FOLLOWUP(p!)" "WAITING(w@/!)" "SOMEDAY(s)" "|" "DONE(d!)")
        (sequence "TWEETFEED(w)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
        (sequence "|" "CANCELED(c@)")))

;; Publishing !
; Sample configuration
(setq org-publish-project-alist
      '(("org"
         :base-directory org-directory
         :publishing-directory (concat org-directory "pub")
         :section-numbers nil)))

(setq org-log-done 'note)
(setq org-tag-alist '((:startgroup . nil)
                      ("@work" . ?w) ("@home" . ?h)
                      ("@computer" . ?c) ("@online" . ?e)
                      ("@calls" . ?s)
                      (:endgroup . nil)
                      ("laptop" . ?l) ("pc" . ?p) ("ARCHIVE" . ?a) ))

;; Agenda and appointments
; (setq org-agenda-include-diary t) adding diary slows down org. Maybe due to some entries in the diary.
(setq org-agenda-custom-commands
      '(("h" "Agenda and Calls"
         ((agenda "")
          (tags-todo "@calls")
          (tags "@calls")))
        ("w" "Away List"
         ((agenda "")
          (tags-todo "@away")
          (tags ":away:errand:")))
        ("o" "Agenda and Office-related tasks"
         ((agenda "")
          (tags-todo "@work")
          (tags ":kk:pj:")))))

;; Org-Remember
(org-remember-insinuate)
;; (setq org-directory "d:/nxp/GTD/org-files/") => This notation is not generic. Use custom to set this.
(setq org-default-notes-file (concat org-directory "gtd.org"))
(define-key global-map "\C-cr" 'org-remember)

(setq org-remember-templates
      '(("Todo" ?t "* TODO %?\n  %i\n  %a" "gtd.org" "Inbox")
        ("Journal" ?j "* %U %?\n  \n  %i\n  %a" "gtd.org" "Log" )
        ("Tweetfeed" ?w "* TWEETFEED %?\n  \n  %i\n  %a" "gtd.org" "Inbox" )
        ("Idea" ?i "* %^{Title}\n  %i\n  %a" "gtd.org" "Maybe")))


(setq org-CUA-compatible t)

;; Ido Configuration
(ido-mode 1)

(ido-everywhere 1)
(setq ido-confirm-unique-completion t)
(setq ido-enable-flex-matching t)

;; will use ffap-guesser to determine whether file name is at point
(setq ido-use-filename-at-point 'guess)

(setq org-completion-use-ido t)

;; Ubiquitous capture - set entry point into emacs for org-remember that can be invoked from
;; anywhere in the OS.
(defadvice remember-finalize (after delete-remember-frame activate)
  "Advise remember-finalize to close the frame if it is the remember frame"
  (if (equal "remember" (frame-parameter nil 'name))
      (delete-frame)))

(defadvice remember-destroy (after delete-remember-frame activate)
  "Advise remember-destroy to close the frame if it is the rememeber frame"
  (if (equal "remember" (frame-parameter nil 'name))
      (delete-frame)))

;; make the frame contain a single window. by default org-remember
;; splits the window.
(add-hook 'remember-mode-hook
          'delete-other-windows)

(defun make-remember-frame ()
  "Create a new frame and run org-remember."
  (interactive)
  (make-frame '((name . "remember") (width . 110) (height . 10)))
  (select-frame-by-name "remember")
  (org-remember))

;; Calendar/ Dairy Settings
(setq european-calendar-style t)
; (setq mark-diary-entries-in-calendar t)

;; Buffer Parameters
;; -----------------
(column-number-mode t)
(display-time-mode)
(display-battery-mode)
(hl-line-mode)

;; Emacs Behaviour
;; ---------------
(put 'narrow-to-region 'disabled nil)
(setq make-backup-files nil)
(setq-default truncate-lines t)
(global-set-key "\C-z" 'undo) 
(global-set-key "\M-\C-z" 'iconify-or-deiconify-frame)
(global-set-key "\C-@" 'shell)
(global-set-key [f10] 'call-last-kbd-macro)
(global-set-key (kbd "<C-tab>") 'other-window) ;; will work in non-org mode buffers
(global-set-key (kbd "C-<f4>") 'delete-window)
(global-set-key (kbd "M-<f4>") 'delete-frame)
(global-set-key (kbd "S-M-<f4>") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x C-c") nil)
(global-set-key (kbd "C-n") 'make-frame)

(global-set-key [f5] 'hl-line-mode)
(global-set-key [f8] 'linum-mode)
(windmove-default-keybindings)
(winner-mode t)
(iswitchb-mode t)
(setq echo-keystrokes 0.1)
(server-start)

;; GUI Appearance
;; --------------
(menu-bar-mode nil)
(tool-bar-mode nil)
;; (global-set-key [down-mouse-3] 'imenu)

