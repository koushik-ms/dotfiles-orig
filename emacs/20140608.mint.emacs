
;; 
;; Emacs configuration file
;;

;; Version History
;; 01-Mar-14: Created initial version
;; 08-Mar-14: Merged lines from .emacs in dropbox
;;            1. Buffer, UI settings
;;            2. Orgmode setup
;;            3. Cursor color etc.
;; 09-Mar-14: Add connection to org ELPA for installing latest org updates


;; =============================================================================
;; Part 0. Custom (settings done via customize-*)
;; =============================================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fill-column 100)
 '(menu-bar-mode nil)
 '(org-agenda-files (quote ("~/org")))
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-id org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-checklist org-secretary)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 4))))
 '(org-refile-use-outline-path (quote file))
 '(org-tags-column -120)
 '(org-tags-exclude-from-inheritance (quote ("prj")))
 '(show-paren-mode t)
 '(show-paren-style (quote mixed))
 '(tool-bar-mode nil)
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; =============================================================================
;; Part 1. Own Functions
;; =============================================================================
;; Put your 'defun's here

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

;; =============================================================================
;; Part 2. ELPA settings
;; =============================================================================
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; =============================================================================
;; Part 3. Buffer & Frame Parameters
;; =============================================================================
(column-number-mode t)
(display-time-mode)
(display-battery-mode)
(hl-line-mode)
(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width . 160))
(setq frame-title-format "%b - Emacs")

;; =============================================================================
;; Part 4. Emacs Behaviour
;; =============================================================================
(put 'narrow-to-region 'disabled nil)
(setq make-backup-files nil)
(windmove-default-keybindings)
(winner-mode t)
(iswitchb-mode t)
(setq user-mail-address "koushik.ms@gmail.com")
(setq inhibit-startup-message t)

;; =============================================================================
;; Part 5. General keybingings
;; =============================================================================
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "M-S-<f4>") 'save-buffers-kill-emacs)
(global-set-key (kbd "<f8>") 'linum-mode)
(global-set-key (kbd "C-<f6>") 'other-window)
(global-set-key (kbd "<f3>") 'kmacro-start-macro)
(global-set-key (kbd "<f4>") 'kmacro-end-or-call-macro)
(global-set-key (kbd "<f5>") 'hl-line-mode)
(global-set-key "\M-\C-z" 'iconify-or-deiconify-frame)
(global-set-key "\C-@" 'shell)
(global-set-key (kbd "<C-tab>") 'other-window) ;; will work in non-org mode buffers
(global-set-key (kbd "C-<f4>") 'delete-window)
(global-set-key (kbd "M-<f4>") 'delete-frame)
(global-set-key (kbd "C-x C-c") 'save-buffers-kill-terminal) ;works only in terminal mode (emacs -nw)
(global-set-key (kbd "C-/") 'make-frame-command)
(global-set-key (kbd "C-}") 'enlarge-window-horizontally)
(global-set-key (kbd "C-{") 'shrink-window-horizontally)
(global-set-key (kbd "C-^") 'enlarge-window)

;; =============================================================================
;; Part 6. Programming
;; =============================================================================
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(global-set-key "\C-b" 'select-block)

(put 'downcase-region 'disabled nil)
;; Show selections
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

(set-face-foreground 'region "white")
(set-face-background 'region "darkblue")

(set-face-foreground 'highlight "black")   ; hyperlink
(set-face-background 'highlight "lightcyan")   ; hyperlink


;; =============================================================================
;; Part 7. File Management/ Exploring
;; =============================================================================
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
;;; Part 8. Configure Org-mode
;;; ======================================================================
(require 'org)
;; Keybindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; <C-tab> mapped to visibility cycling commands in org mode buffers
(global-set-key (kbd "<C-S-iso-lefttab>") 'other-window) 

;; Todo keywords
(setq org-todo-keywords
      '(
        (sequence "NEW(n)" "TODO(t)" "NEXT(x!)" "WAITING(w@/!)" "BLOCKED(b@/!)" "|" "DONE(d!)")
        (sequence "JOURNAL(j)" "|" "PROCESSED(p!)")
        (sequence "INCIDENT(i!)" "DISCUSSED(s@)" "|" "ADDRESSED(a@)")
        (sequence "SOMEDAY(m)" "GOAL(g)" "|" "ACHIEVED(v!)" "CANCELED(c@)")
        ))

;; Publishing !
; Sample configuration
(setq org-publish-project-alist
      '(("org"
         :base-directory org-directory
         :publishing-directory (concat org-directory "pub")
         :section-numbers nil)))

;; Miscellaneous configuration vars
(setq org-log-done 'time)
(setq org-tag-alist '(
                      (:startgroup . nil)
                      ("@work" . ?w) ("@home" . ?h) ("@away" . ?@)
                      (:endgroup . nil)
                      (:startgroup . nil)
                      ("@online" . ?e) ("@offline" . ?f) ("@phone_f2f" . ?p)
                      (:endgroup . nil)
                      ("#people" . ?l) ("#project" . ?t) ("#PIC_HC" . ?c)
                      ("#om" . ?o) ("#career" . ?r) ("#family" . ?y)
                      ("#friends" . ?d) ("#finance" . ?$) ("#tech_hobby" . ?z)
                      ("#gtd" . ?g) ("ARCHIVE" . ?a) 
                      ))

;; Agenda and appointments (a tT mM L s taken)
; (setq org-agenda-include-diary t) adding diary slows down org. Maybe due to some entries in the diary.
(setq org-agenda-custom-commands
      '(
        ("i" "Inbox Review" 
         (
          (todo "NEW")
          (todo "JOURNAL")
          )
         )
        ("w" "Away List"
         ((agenda "")
          (tags-todo "@away")
          (tags ":away:errand:")))
        ("o" "Agenda and Work-related tasks"
         ((agenda "")
          (todo "NEXT")
          ))
        ("r" "Weekly Review" 
         (
          (todo "BLOCKED")
          (todo "NEXT")
          (todo "TODO")
          (todo "WAITING")
          (todo "NEW")
          (todo "JOURNAL")
          )
         )
        ("p" "Person Context" 
         (
          (todo "WAITING")
          (todo "INCIDENT")
          (todo "DISCUSSED")
          (tags-todo "1on1")
          (tags-todo "@1on1")
          (tags-todo "feedback")
          (todo "JOURNAL")
          )
         )
        ))

;; Org-Capture setup
(setq org-default-notes-file (concat org-directory "projects.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(
        ("a" "An Interruption" entry (file+datetree "log.org")
         "* JOURNAL %U %?  :i10n:\n\n\n  %a\n  {%i}\n  %c\n\n  [Interrupted during %K]\n" :clock-in t :clock-resume t)
        ("d" "A Dated Interruption" entry (file+datetree+prompt "log.org")
         "* JOURNAL %U %?  :i10n:\n\n\n  %a\n  {%i}\n  %c\n\n  [Interrupted during %K]\n" :clock-in t :clock-resume t)
        ("e" "Event (date to remember)" entry (file+headline "reference.org" "Events")
         "* Event: %?\n  %a\n  {%i}\n  %c\n\n")
        ("g" "New Gmail Item" entry (file "inbox.org")
         "* NEW %?\n\n\n  gmail:%a\n  {%i}\n  See [[gmail:%c][Gmail Link]]\n\n" :clock-in t :clock-resume t)
        ("i" "New Item" entry (file "inbox.org")
         "* NEW %?\n\n\n  %a\n  {%i}\n  %c\n\n" :clock-in t :clock-resume t)
        ("j" "Journal / Log" entry (file+datetree "log.org")
         "* JOURNAL %?\n\n  Entered on %U\n\n\n  %a\n  {%i}\n  %c\n\n" :clock-in t :clock-keep t)
        ("k" "Dated Journal / Log" entry (file+datetree+prompt "log.org")
         "* JOURNAL %?\n\n  Entered on %U\n\n\n  %a\n  {%i}\n  %c\n\n")
        ("n" "Next Action" entry (file+headline "projects.org" "Tasks")
         "* NEXT %?\n  %a\n  {%i}\n  %c\n\n")
        ("t" "Todo" entry (file+headline "projects.org" "Tasks")
         "* TODO %?\n  %a\n  {%i}\n  %c\n\n")
        ))

;; MobileOrg Configuration
(setq org-mobile-directory (concat org-directory "MobileOrg") )
(setq org-mobile-inbox-for-pull (concat org-directory "mobileInbox.org"))

;; Make  the mode-line display the current heading.
(require 'which-func)
(add-to-list 'which-func-modes 'org-mode)
(which-func-mode 1)

;; Ido Configuration
(ido-mode 1)
(ido-everywhere 1)
(setq ido-confirm-unique-completion t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess) ;; will use ffap-guesser to determine whether file name is at point
(setq org-completion-use-ido t)

;; Calendar/ Dairy Settings
(setq european-calendar-style t)
; (setq mark-diary-entries-in-calendar t)

;; =============================================================================
;; Part 9. Koushik MS - 20091218, Fun with cursor type & color.
;; =============================================================================
;; Cool piece of code from http://emacs-fu.blogspot.com/2009/12/changing-cursor-color-and-shape.html
;; Change cursor color according to mode; inspired by
;; http://www.emacswiki.org/emacs/ChangingCursorDynamically
(setq djcb-read-only-color       "darkgray")

;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar. HEIGHT); see the docs for set-cursor-type
(setq djcb-read-only-cursor-type '(hbar . 20))
(setq djcb-overwrite-color       "darkred")
(setq djcb-overwrite-cursor-type 'box)
(setq djcb-normal-color          "darkblue")
(setq djcb-normal-cursor-type    '(bar . 3) )


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


;; =============================================================================
;; Part 10. Startup actions
;; =============================================================================

(server-start)

(animate-sequence '("ॐ विघ्नराजाय नमः" "श्री गुरुभ्यो नमः" "जय जय शँकर" "हर हर शँकर") 0)
