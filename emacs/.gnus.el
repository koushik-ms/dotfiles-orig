
;;; gnus configuration file
;; Copyright (C) 2010, Koushik B Meenakshi Sundaram, Bangalore, INDIA.

;; Version History
;; |-------+----------+-------------------------------------------------------------------------------------+------------|
;; | Ver # |     Date | Description                                                                         | Author     |
;; |-------+----------+-------------------------------------------------------------------------------------+------------|
;; |   0.1 | 20100610 | Creation based on tutorial at                                                       | Koushik MS |
;; |       |          | http://www.emacswiki.org/emacs/GnusTutorial                                         |            |
;; |-------+----------+-------------------------------------------------------------------------------------+------------|
;; |   0.2 | 20100611 | Update thread view based on tips from                                               | Koushik MS |
;; |       |          | http://groups.google.com/group/gnu.emacs.gnus/browse_thread/thread/a673a74356e7141f |            |
;; |-------+----------+-------------------------------------------------------------------------------------+------------|
;; |   0.3 | 20100614 | First attempt at imapping work email into gnus                                      | Koushik MS |
;; |-------+----------+-------------------------------------------------------------------------------------+------------|


;;; Basics - Who Am I ?
(setq user-mail-address "emacsfan@gmail.com")
(setq user-full-name "Poptester Emacsfan")

(setq gnus-select-method '(nntp "news.gnus.org"))
;; TODO: Subscribe to news.gmane.org & slashdot

;;; Enable any one setup from the list below.
;; Setup 1 - GMail via pop
(add-to-list 'gnus-secondary-select-methods '(nnml ""))
(setq mail-sources '(
                     (pop :server "pop.gmail.com"
                          :port 995
                          :user "emacsfan@gmail.com")
                     ))
;; Setup 2 - imap [INCOMPLETE]
;; (setq gnus-secondary-select-methods '((nnimap "Trident"
;; 			              (nnimap-address "localhost")
;; 					      (nnimap-authenticator login)
;; 					      (nnimap-stream ssl))))

;; Use smtpmail package for outgoing mail.
(setq send-mail-function 'smtpmail-send-it) ; not for Gnus :-)
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-default-smtp-server "smtp.gmail.com")
(setq smtpmail-starttls-credentials '(("smtp.gmail.com" 587 "emacsfan" "samsrushtam")))

;;; Eye-candy - Appearance !
;;; threading
(setq gnus-face-9 'font-lock-warning-face)
(setq gnus-face-10 'shadow)
(defun sdl-gnus-summary-line-format-ascii nil
  (interactive)
  ;; TODO: Activate appropriate summary-line after mods and after setting scroing etc.
  ;;       Also, figure out what is &@ 
  ;; (setq gnus-summary-line-format
  ;;       (concat
  ;;        "%0{%U%R%z%}" "%10{|%}" "%1{%d%}" "%10{|%}"
  ;;        "%9{%u&@;%}" "%(%-15,15f %)" "%10{|%}" "%4k" "%10{|%}"
  ;;        "%2u&score;" "%10{|%}" "%10{%B%}" "%s\n"))
  (setq
   gnus-sum-thread-tree-single-indent   "o "
   gnus-sum-thread-tree-false-root      "x "
   gnus-sum-thread-tree-root            "* "
   gnus-sum-thread-tree-vertical        "| "
   gnus-sum-thread-tree-leaf-with-other "|-> "
   gnus-sum-thread-tree-single-leaf     "+-> " ;; "\\" is _one_ char
   gnus-sum-thread-tree-indent          "  ")
  (gnus-message 5 "Using ascii tree layout."))

(defun sdl-gnus-summary-line-format-unicode nil
  (interactive)
  ;; TODO: Activate appropriate summary-line after mods and after setting scroing etc.
  ;;       Also, figure out what is &@ 
  ;; (setq gnus-summary-line-format
  ;;       (concat
  ;;        "%0{%U%R%z%}" "%10{│%}" "%1{%d%}" "%10{│%}"
  ;;        "%9{%u&@;%}" "%(%-15,15f %)" "%10{│%}" "%4k" "%10{│%}"
  ;;        "%2u&score;" "%10{│%}" "%10{%B%}" "%s\n"))
  (setq
   gnus-sum-thread-tree-single-indent   "◎ "
   gnus-sum-thread-tree-false-root      "  "
   gnus-sum-thread-tree-root            "┌ "
   gnus-sum-thread-tree-vertical        "│"
   gnus-sum-thread-tree-leaf-with-other "├─>"
   gnus-sum-thread-tree-single-leaf     "└─>"
   gnus-sum-thread-tree-indent          "  ")
  (gnus-message 5 "Using ascii tree layout with unicode chars."))

(sdl-gnus-summary-line-format-unicode) 
