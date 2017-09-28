
;;
;; This is the initialisation file of the Windows NT version of Emacs
;;

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "outline" :family "Bitstream Vera Sans Mono"))))
 '(cursor ((t (:background "orange"))))
 '(ecb-default-general-face ((((class color) (background light)) (:height 1.0))))
 '(ecb-directories-general-face ((((class color) (background light)) (:inherit ecb-default-general-face :height 0.6))))
 '(ecb-tree-guide-line-face ((((class color) (background light)) (:inherit ecb-default-general-face :foreground "grey" :height 0.6))))
 '(font-lock-comment-face ((((class color) (background light)) (:foreground "Firebrick" :height 1.0))))
 '(font-lock-function-name-face ((((class color) (background light)) (:foreground "Blue" :height 1.2))))
 '(mode-line ((((type x w32 mac) (class color)) (:background "grey90" :foreground "black" :box (:line-width -1 :color "blue" :style released-button) :height 85 :family "courier new"))))
 '(muse-link-face ((t (:background "white" :foreground "darkgreen" :underline "darkgreen" :weight bold))))
 '(outline-1 ((t (:inherit font-lock-function-name-face :background "gray75" :foreground "black" :box (:line-width 2 :color "grey40" :style released-button) :underline t :height 100))))
 '(outline-2 ((t (:inherit font-lock-variable-name-face :height 100))))
 '(outline-3 ((t (:inherit font-lock-keyword-face :height 100))))
 '(outline-4 ((t (:inherit font-lock-comment-face :height 100))))
 '(outline-5 ((t (:inherit font-lock-type-face :height 90))))
 '(outline-6 ((t (:inherit font-lock-constant-face :height 90))))
 '(outline-7 ((t (:inherit font-lock-builtin-face :underline "gray" :height 90))))
 '(outline-8 ((t (:inherit font-lock-string-face :inverse-video t :height 90)))))


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
  (find-file (concat org-directory "gtd.org"))
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

; Show selections
(transient-mark-mode 1)
(set-face-foreground 'region "white")
(set-face-background 'region "darkblue")

(set-face-foreground 'highlight "black")   ; hyperlink
(set-face-background 'highlight "lightcyan")   ; hyperlink

(setq frame-title-format "%b - Emacs")
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 155))

; Maximise new frames by default (Uncomment)
; (setq after-make-frame-functions (cons 'w32-maximise-frame after-make-frame-functions)) 

;; Startup actions
;; ---------------
;; (load "gnuserv")
;; (gnuserv-start)
;; (turn-on-truncation)

;;; Emacs/W3 Configuration
(condition-case () (require 'w3-auto "w3-auto") (error nil))
(setq url-proxy-services
            '(("http"     . "161.85.103.70:8080")
             ))

;;; TODO: Integrate Load Semantic, CEDET

;;; TODO : ECB Configuration 

;; Programming
;; -----------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(global-set-key "\C-b" 'select-block)

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
(menu-bar-mode nil)
(tool-bar-mode nil)
;; (global-set-key [down-mouse-3] 'imenu)

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
(setq user-mail-address "koushik.ms@nxp.com")
(setq inhibit-startup-message t)

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

