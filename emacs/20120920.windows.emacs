
;;
;; This is the initialisation file of the Windows NT version of Emacs
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fill-column 100)
 '(org-agenda-files (quote ("D:/koushik.ccase/Dropbox/org/")))
 '(org-directory "D:/koushik.ccase/Dropbox/org/")
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-id org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 4))))
 '(org-refile-use-outline-path (quote file))
 '(org-tags-column -120)
 '(show-paren-mode t)
 '(show-paren-style (quote mixed)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "outline" :family "Bitstream Vera Sans Mono"))))
 '(cursor ((t (:background "orange"))))
 '(diredp-dir-priv ((t (:background "ivory" :foreground "saddle brown" :weight bold))))
 '(ecb-default-general-face ((((class color) (background light)) (:height 1.0))))
 '(ecb-directories-general-face ((((class color) (background light)) (:inherit ecb-default-general-face :height 0.6))))
 '(ecb-tree-guide-line-face ((((class color) (background light)) (:inherit ecb-default-general-face :foreground "grey" :height 0.6))))
 '(font-lock-comment-face ((((class color) (background light)) (:foreground "Firebrick" :height 1.0))))
 '(font-lock-function-name-face ((((class color) (background light)) (:foreground "Blue" :height 1.0))))
 '(mode-line ((t (:box (:line-width 2 :color "grey75" :style released-button) :height 80))))
 '(muse-link-face ((t (:background "white" :foreground "darkgreen" :underline "darkgreen" :weight bold))))
 '(outline-1 ((t (:inherit font-lock-function-name-face :background "gray75" :foreground "black" :underline t))))
 '(outline-2 ((t (:inherit font-lock-variable-name-face))))
 '(outline-3 ((t (:inherit font-lock-keyword-face))))
 '(outline-4 ((t (:inherit font-lock-comment-face))))
 '(outline-5 ((t (:inherit font-lock-type-face))))
 '(outline-6 ((t (:inherit font-lock-constant-face))))
 '(outline-7 ((t (:inherit font-lock-builtin-face :underline "gray"))))
 '(outline-8 ((t (:inherit font-lock-string-face :inverse-video t)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of Custom Section of .emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ediff)

;; Own Functions
;; Put your 'defun's here
;; (require 'lisp) 


(defun turn-on-truncation() 
  "Enable line truncation by default"
  (setq truncate-lines t)
)
;
(defun w32-maximise-frame(frame) 
  "Maximize the frame passed as parameter (which is an MS Windows window)"
  (interactive) 
  (w32-send-sys-command #xf030 frame)
)
;
(defun w32-maximise-current-frame() 
  "Maximize the current frame (which is an MS Windows window)"
  (interactive) 
  (w32-send-sys-command #xf030)
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

;; This function open current dired item by running W32 Shell open verb on it.
(defun w32-dired-open-explorer ()
  "Open a file in dired mode by explorer.exe as you double click it."
  (interactive)
  (let ((file-name (dired-get-file-for-visit)))
    (if (file-exists-p file-name)
	(w32-shell-execute "open" file-name nil 1))))

;; This calculates the size of all marked files - requires du in path.
(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "du" nil t nil "-sch" files) ;; replace du with /usr/bin/du in linux if required.
      (message "Size of all marked files: %s"
               (progn 
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
                 (match-string 1))))))



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

;; This lisp function sets up calendar, diary and plan buffers in a special 
;; frame. This should ideally be called only once per emacs session. Good to put
;; in .emacs itself at the end.
(defun make-my-day()
  "Setup my Calendar and diary"
  (interactive)
  (select-frame (make-frame))
  (calendar)
  (diary)
  (other-window 1)
  (split-window-vertically 15)
  (other-window 1)
  (plan)
  (calculator)
  (other-window -1)
  )

;; This lisp defun sets up the welcome Muse page in a new frame - it creates a 
;; new frame for this purpose.
(defun welcome-me() 
  "Open an exclusive frame for welcome page"
  (interactive)
  ;; emacs-wiki-find-file works fine, except when invoked from a
  ;; planner page where it is overridden by planner-find-file! The
  ;; below workaround will solve this problem for other such modes
  ;; that screw up normal operation of emacs-wiki, since the
  ;; *Messages* buffer will always exist and from there the find-file
  ;; operation works fine.
  (select-frame (make-frame))
  (switch-to-buffer "*Messages*")
  (w32-maximize-frame)
  (emacs-wiki-find-file "WelcomePage")
  (split-window-horizontally)
  (other-window 1)
  (emacs-wiki-find-file "EventReportGen")
  (split-window-vertically)
  (emacs-wiki-find-file "InnateProgressor")
  (split-window-vertically)
  (emacs-wiki-find-file "ScratchPad")
  (balance-windows)
  (other-window -1)
  )

;; Koushik MS - 20060401
;; Defun the last bit of .emacs for creating setup windows
(defun emacs-workshop-setup() 
  "Setup the necessary windows for learning about and improving emacs customization"
  (interactive)
  (w32-maximize-frame)
  (split-window-vertically)
  (find-file-other-window "~/.emacs")
  (other-window 1)
  (split-window-horizontally)
  (other-window 1)
  (info)
  (enlarge-window 12)
  (other-window 2)
  (split-window-vertically)
  (other-window 1)
  (dired "c:/bin/emacs/emacs-21.3/site-lisp/")
  (other-window -1)
  (w32-minimize-frame)
  )

;; This lisp defun makes a small frame and open a wiki page "Notes"
;; in it. Somewhat like remember but only for making notes w/o 
;; annotations... and a little customised.
(defun make-notes-frame()
  "Make a small frame to put down notes"
  (interactive)
  (let (newframe)
    (select-frame(setq newframe (make-frame)))
    ; (print newframe)
    (set-frame-height newframe 3)
    (set-frame-width newframe 120)
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

;; Shell behaviour enhancement.
;; (setq process-coding-system-alist
;;       '(("cmdproxy" . (raw-text-dos . raw-text-dos))))
;; (add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m)

;;; Emacs/W3 Configuration
(condition-case () (require 'w3-auto "w3-auto") (error nil))
;; Clean this up
;; (setq url-proxy-services
;;             '(("http"     . "130.139.104.10:8080")
;;              ))

;;; TODO: Integrate Load Semantic, CEDET

;;; TODO : ECB Configuration 

;; Programming
;; -----------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(global-set-key "\C-\M-b" 'select-block)

; (eshell)

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
            (define-key dired-mode-map "O" 'w32-dired-open-explorer)
            (define-key dired-mode-map (kbd "?") 'dired-get-size)
            )
          )

(add-hook 'dired-x-load-hook
          (lambda () (setq dired-x-hands-off-my-keys nil)))
(add-hook 'dired-x-load-hook
          (lambda () (dired-x-bind-find-file)))

(setq dired-dwim-target t)
(setq dired-recursive-copies t)

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
;;; Activate dired+ and w32-browser
;;; ======================================================================
;; 
(require 'dired+)
(require 'w32-browser)

;;; ======================================================================
;;; TODO: Bringin useful parts of Planner & emacs-wiki setup
;;; ======================================================================

;;; ======================================================================
;;; TODO: Check if "Time Clock" is required
;;; ======================================================================
;;; ======================================================================
;;; TODO: Integrate "Emacs Muse"
;;; ======================================================================

;;; ======================================================================
;;; TODO: Integrate "Emacs IRC - Configure ERC"
;;; ======================================================================


;;; ======================================================================
;;; Configure Org-mode
;;; ======================================================================

;; Keybindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key (kbd "<C-M-tab>") 'other-window)
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
(setq org-log-done 'time)
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
; (setq org-agenda-window-setup 'other-frame)

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

;; Org-Remember and Org-Capture (in transition)
(org-remember-insinuate)
;; (setq org-directory "d:/nxp/GTD/org-files/") => This notation is not generic. Use custom to set this.
(setq org-default-notes-file (concat org-directory "projects.org"))
(define-key global-map "\C-cr" 'org-remember)
(define-key global-map "\C-cc" 'org-capture)

(setq org-remember-templates
      '(("Todo" ?t "* TODO %?\n  %i\n  %a" "projects.org" "Inbox")
        ("Journal" ?j "* %U %?\n  \n  %i\n  %a" "projects.org" "Log" )
        ("Outlook Message" ?o "* TODO %?\n  \n  %i\n  %c\n  %a" "projects.org" "Tasks" )
        ("Gmail Message" ?g "* TODO %?\n  \n  %i\n  See [[gmail:%c][Gmail link]]\n  gmail : %a" "projects.org" "Tasks" )
        ("Tweetfeed" ?w "* TODO Tweet %?\n  \n  %i\n  %a" "projects.org" "Inbox" )
        ("Idea" ?i "* %^{Title}\n  %i\n  %a" "projects.org" "Maybe")))

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


;; MobileOrg Configuration
(setq org-mobile-directory "D:/koushik.ccase/Dropbox/MobileOrg")
(setq org-mobile-inbox-for-pull (concat org-directory "mobileInbox.org"))

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
  (make-frame '((name . "remember") (width . 110) (height . 20)))
  (select-frame-by-name "remember")
  (switch-to-buffer "*scratch*")
  (org-remember))

;; Org-outlook - Magic !  (see
;; http://superuser.com/questions/71786/can-i-create-a-link-to-a-specific-email-message-in-outlook)
;; and the comments.
(require 'org-outlook)

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

; try to improve slow performance on windows.
(setq w32-get-true-file-attributes nil)

;; GUI Appearance
;; --------------
(menu-bar-mode 0)
(tool-bar-mode 0)
;; (global-set-key [down-mouse-3] 'imenu)
;; maximise window on startup.
(add-hook 'window-setup-hook 'w32-maximise-current-frame t)

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

; Show selections
(transient-mark-mode 1)
(set-face-foreground 'region "white")
(set-face-background 'region "darkblue")

(set-face-foreground 'highlight "black")   ; hyperlink
(set-face-background 'highlight "lightcyan")   ; hyperlink

(setq frame-title-format "%b - Emacs")
(add-to-list 'default-frame-alist '(height . 55))
(add-to-list 'default-frame-alist '(width . 140))

; Maximise new frames by default (Uncomment)
; (setq after-make-frame-functions (cons 'w32-maximise-frame after-make-frame-functions)) 

;; Startup actions
;; ---------------
(server-start)
;; (turn-on-truncation)

(animate-sequence '("ॐ विघ्नराजाय नमः" "श्री गुरुभ्यो नमः" "जय जय शँकर" "हर हर शँकर") 0)

;; Startup actions to be done at the "end of start" :P
;; (emacs-workshop-setup)
;; (make-my-day)
;; (welcome-me)

;; Customization for Haris
;; (global-set-key "\C-o" 'find-file)

;;; (require 'color-theme)
;;; (color-theme-greiner)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of custom section of Emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(put 'dired-find-alternate-file 'disabled nil)
