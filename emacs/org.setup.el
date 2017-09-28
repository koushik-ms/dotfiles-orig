;; orgmode setup by Koushik B Meenakshi Sundaram
;; 
;; This is a setup file for orgmode that aims to be platform and deployment agnostic.  This is
;; intended to be used in the windows & linux installation of emacs24 so as to provide a common
;; configuration of orgmode. 

;; The idea is that this will be placed in dropbox or other shared/ synced location so that an
;; update of configuration from one machine is immediately available to all other deployments.

;; This file shall be included in the .emacs.

;; This depends on below settings done via "Customize" to bind to the specifics of the deployment
;; org-directory (location of all .org files)
;; org-mobile-directory

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
                      ("@work" . ?w) ("@home" . ?h) ("@away" . ?a) ("@anywhere" . ?@)
                      (:endgroup . nil)
                      (:startgroup . nil)
                      ("@online" . ?e) ("@offline" . ?f) ("@phone_f2f" . ?p)
                      (:endgroup . nil)
                      ("#people" . ?l) ("#project" . ?t) ("#PIC_HC" . ?c)
                      ("#om" . ?o) ("#career" . ?r) ("#family" . ?y)
                      ("#friends" . ?d) ("#finance" . ?$) ("#tech_hobby" . ?z)
                      ("#gtd" . ?g) ("ARCHIVE" . ?k) 
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
;; org-mobile-directory shall be set via customize.
(setq org-mobile-inbox-for-pull (concat org-directory "inbox.org"))

;; Make  the mode-line display the current heading.
(require 'which-func)
(add-to-list 'which-func-modes 'org-mode)
(which-func-mode 1)

