
;;
;; This is the initialisation file of the Linux version of Emacs
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fill-column 100)
 '(org-agenda-files (quote ("~/org/")))
 '(org-completion-use-ido t)
 '(org-default-notes-file "~/orgprojects.org")
 '(org-from-is-user-regexp "\\<KM\\>")
 '(org-log-done (quote note))
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-id org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 4))))
 '(org-refile-use-outline-path (quote file))
 '(org-tags-column -120)
 '(org-todo-keywords (quote ((sequence "NEW(n)" "TODO(t)" "NEXT(x!)" "WAITING(w@/!)" "BLOCKED(b@/!)" "|" "DONE(d!)") (sequence "JOURNAL(j)" "|" "PROCESSED(p!)") (sequence "INCIDENT(i!)" "DISCUSSED(s@)" "|" "ADDRESSED(a@)") (sequence "SOMEDAY(m)" "GOAL(g)" "|" "ACHIEVED(v!)" "CANCELED(c@)"))))
 '(show-paren-mode t))



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 85 :width normal :foundry "unknown" :family "Droid Sans Mono")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of Custom Section of .emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ediff)
(require 'org)

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

(defun dired-find-file-other-frame()
  "Open file in a new frame"
  (interactive )
  (find-file-other-frame (dired-get-filename))
  )


;; This function jumps to the selected WikiName in a new window in a new frame.
;; It always creates a new frame
(defun emacs-wiki-follow-name-at-point-other-frame()
  "Follow selected wiki name on a new frame - Uses assumptions about buffer list management"
  (interactive)
  (let (buf)
    (emacs-wiki-follow-name-at-point)
    (setq buf (current-buffer))
    (switch-to-buffer nil)
    (select-frame (make-frame))
    (switch-to-buffer buf)
    )
  )

;; Koushik MS - 20091118

;; This lisp defun creates a new frame and open an org-mode file in that buffer
(defun get-organized() 
  "Open an exclusive frame for org-files"
  (interactive)
  (select-frame (make-frame))
  (find-file (concat org-directory "inbox.org"))
  )

;; =============================================================================
;; Koushik MS - 20091218, Fun with cursor type & color.
;; =============================================================================
;; Cool piece of code from http://emacs-fu.blogspot.com/2009/12/changing-cursor-color-and-shape.html
;; Change cursor color according to mode; inspired by
;; http://www.emacswiki.org/emacs/ChangingCursorDynamically
(setq djcb-read-only-color       "DarkSlateGray")

;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar. HEIGHT); see the docs for set-cursor-type
(setq djcb-read-only-cursor-type '(hbar . 10))
(setq djcb-overwrite-color       "red")
(setq djcb-overwrite-cursor-type 'box)
(setq djcb-normal-color          "brown")
(setq djcb-normal-cursor-type    'bar)

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

(transient-mark-mode 1)

(add-to-list 'default-frame-alist '(height . 55))
(add-to-list 'default-frame-alist '(width . 140))

;; Programming
;; -----------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(global-set-key "\C-\M-b" 'select-block)
(put 'downcase-region 'disabled nil)

;; File Management/ Exploring
;; --------------------------

(add-hook 'dired-load-hook
          (lambda ()
            (define-key dired-mode-map "c" 'dired-append-file-name-at-point)
            (define-key dired-mode-map " " 'isearch-forward)
            (define-key dired-mode-map [(ctrl return)] 'dired-find-file-other-frame)
            (define-key dired-mode-map "\d" 'dired-up-directory)
            (define-key dired-mode-map "O" 'w32-dired-open-explorer)
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
;; (global-set-key (kbd "<C-M-tab>") 'other-window) -- doesn't work in gnome (Cinnamon etc)
(global-set-key (kbd "<C-S-iso-lefttab>") 'other-window) ;; will work in org-mode buffers also
(global-set-key "\C-xg" 'get-organized)
(global-set-key [f11] 'get-organized)

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
(setq org-log-done 'note)
(setq org-tag-alist '(
                      (:startgroup . nil)
                      ("@work" . ?w) ("@home" . ?h) ("@away" . ?w)
                      (:endgroup . nil)
                      (:startgroup . nil)
                      ("@online" . ?e) ("@offline" . ?f) ("@phone_f2f" . ?p)
                      (:endgroup . nil)
                      ("#people" . ?l) ("#project" . ?t) ("#PIC_HC" . ?c)
                      ("#om" . ?o) ("#career" . ?r) ("#family" . ?y)
                      ("#friends" . ?d) ("#finance" . ?$) ("#tech_hobby" . ?z)
                      ("#gtd" . ?g) ("ARCHIVE" . ?a) 
                      ))
;; (setq org-agenda-window-setup 'other-frame)

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
          (tags-todo "PH")
          (tags-todo "PIC")
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

;; Org-Capture 
;; (setq org-directory "d:/nxp/GTD/org-files/") => This notation is not generic. Use custom to set this.
(setq org-default-notes-file (concat org-directory "projects.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(
        ("a" "An Interruption" entry (file+datetree "log.org")
         "* JOURNAL %U %?  :i10n:\n\n\n  %a\n  {%i}\n  %c\n\n  [Interrupted during %K]\n" :clock-in t :clock-resume t)
        ("d" "A Dated Interruption" entry (file+datetree+prompt "log.org")
         "* JOURNAL %U %?  :i10n:\n\n\n  %a\n  {%i}\n  %c\n\n  [Interrupted during %K]\n" :clock-in t :clock-resume t)
        ("i" "New Item" entry (file "inbox.org")
         "* NEW %?\n\n\n  %a\n  {%i}\n  %c\n\n" :clock-in t :clock-resume t)
        ("g" "New Gmail Item" entry (file "inbox.org")
         "* NEW %?\n\n\n  gmail:%a\n  {%i}\n  See [[gmail:%c][Gmail Link]]\n\n" :clock-in t :clock-resume t)
        ("j" "Journal / Log" entry (file+datetree "log.org")
         "* JOURNAL %?\n\n  Entered on %U\n\n\n  %a\n  {%i}\n  %c\n\n" :clock-in t :clock-keep t)
        ("k" "Dated Journal / Log" entry (file+datetree+prompt "log.org")
         "* JOURNAL %?\n\n  Entered on %U\n\n\n  %a\n  {%i}\n  %c\n\n")
        ("n" "Next Action" entry (file+headline "projects.org" "Tasks")
         "* NEXT %?\n  %a\n  {%i}\n  %c\n\n")
        ("t" "Todo" entry (file+headline "projects.org" "Tasks")
         "* TODO %?\n  %a\n  {%i}\n  %c\n\n")
        ))


;; Setup MobileOrg Configuration
;; (setq org-mobile-directory (quote org-directory))
;; (setq org-mobile-inbox-for-pull (concat org-mobile-directory "mobileInbox.org"))

;; Ubiquitous capture - set entry point into emacs for org-capture that can be invoked from
;; anywhere in the OS.

;; TODO:: Add keyboard shortcut from os to invoke org-capture

;; Make  the mode-line display the current heading.
(require 'which-func)
(add-to-list 'which-func-modes 'org-mode)
(which-func-mode 1)

;; Ido Configuration
(ido-mode 1)

(ido-everywhere 1)
(setq ido-confirm-unique-completion t)
(setq ido-enable-flex-matching t)

;; will use ffap-guesser to determine whether file name is at point
(setq ido-use-filename-at-point 'guess)

(setq org-completion-use-ido t)

;; GUI Appearance
;; --------------
(menu-bar-mode 0)
(tool-bar-mode 0)

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

;; Macro define and invoke - default f3 - start recording; f4 - stop recording / playback last macro
;; if you additionally want to bind this to f10 uncomment below line.  
;; (global-set-key [f10] 'call-last-kbd-macro)

(global-set-key (kbd "<C-tab>") 'other-window) ;; will work in non-org mode buffers
(global-set-key (kbd "C-<f4>") 'delete-window)
(global-set-key (kbd "M-<f4>") 'delete-frame)
(global-set-key (kbd "S-M-<f4>") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x C-c") nil)
(global-set-key (kbd "C-/") 'make-frame)

(global-set-key (kbd "C-}") 'enlarge-window-horizontally)
(global-set-key (kbd "C-{") 'shrink-window-horizontally)
(global-set-key (kbd "C-^") 'enlarge-window)


(global-set-key [f5] 'hl-line-mode)
(global-set-key [f8] 'linum-mode)
(windmove-default-keybindings)
(winner-mode t)
(iswitchb-mode t)
(setq echo-keystrokes 0.1)
(setq user-mail-address "koushik.ms@gmail.com")
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of custom section of Emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Startup actions
;; ---------------
(server-start)
(animate-sequence '("ॐ िवघ्नराजाय नमः" "श्री गुरुभ्यो नमः" "जय जय शँकर" "हर हर शँकर") 0)


