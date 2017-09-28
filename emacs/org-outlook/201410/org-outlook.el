;;; org-outlook.el - Support for links to Outlook items in Org
;;; Copied gratefully from http://superuser.com/questions/71786/can-i-create-a-link-to-a-specific-email-message-in-outlook

(require 'org)

(org-add-link-type "outlook" 'org-outlook-open)

(defun org-outlook-open (id)
   "Open the Outlook item identified by ID.  ID should be an Outlook GUID."
;;   (w32-shell-execute "open" (concat "outlook:" id)) <-- see comment below
;;   (w32-shell-execute "open" "C:/Program Files/Microsoft Office/Office12/OUTLOOK.EXE" (concat "/select " "outlook:" id)))
   (w32-shell-execute "open" "c:/Program Files (x86)/Microsoft Office/Office14/OUTLOOK.EXE" (concat "/select " "outlook:" id)))



(provide 'org-outlook)

;;; org-outlook.el ends here

;;; * IMPORTANT *

;;; Registry data required  to be imported into windows  for open to work directly  on outlook: type
;;; links.  Export below  data into a text-file and  remove the leading ;; from all  lines that have
;;; it.   Adjust the  path  (Progra~1 or  Micros~3  or any  other elements  to  suit your  installed
;;; path). There must be  a better way to implement this (using  org-protocol or something). However
;;; the direct method of opening outlook with the select option doesn't require this import.


;; == Content to export into .reg file ==
;; Windows Registry Editor Version 5.00

;; [HKEY_CLASSES_ROOT\outlook]
;; "URL Protocol"=""
;; @="URL:Outlook Folders"

;; [HKEY_CLASSES_ROOT\outlook\DefaultIcon]
;; @="C:\\PROGRA~1\\MICROS~3\\OFFICE12\\OUTLLIB.DLL,-9403"

;; [HKEY_CLASSES_ROOT\outlook\shell]
;; @="open"

;; [HKEY_CLASSES_ROOT\outlook\shell\open]
;; @=""

;; [HKEY_CLASSES_ROOT\outlook\shell\open\command]
;; @="\"C:\\PROGRA~1\\MICROS~3\\OFFICE12\\OUTLOOK.EXE\" /select \"%1\""

