' Insert this into a module in outlook and enable macros'

'Adds a link to the currently selected message to the clipboard
Sub AddLinkToMessageInClipboard()
    Dim objMail As Object
    'was earlier Outlook.MailItem
    Dim doClipboard As New MSForms.DataObject
    Dim message As String
      
    'One and ONLY one message muse be selected
    If Application.ActiveExplorer.Selection.Count <> 1 Then
        MsgBox ("Select one and ONLY one message.")
        Exit Sub
    End If
   
    Set objMail = Application.ActiveExplorer.Selection.Item(1)
   
    If objMail.Class = olMail Then
        doClipboard.SetText "[[outlook:" + objMail.EntryID + "][MESSAGE: " + objMail.Subject + " (" + objMail.SenderName + " on " + Format(objMail.SentOn, "dd-mmm-yy hh:mm") + ")]]"
        objMail.MarkAsTask (olMarkNoDate)
        objMail.Save
    ElseIf objMail.Class = olAppointment Then
        doClipboard.SetText "[[outlook:" + objMail.EntryID + "][MEETING: " + objMail.Subject + " (" + objMail.Organizer + ")]]"
    ElseIf objMail.Class = olTask Then
        doClipboard.SetText "[[outlook:" + objMail.EntryID + "][TASK: " + objMail.Subject + " (" + objMail.Owner + ")]]"
    ElseIf objMail.Class = olContact Then
        doClipboard.SetText "[[outlook:" + objMail.EntryID + "][CONTACT: " + objMail.Subject + " (" + objMail.FullName + ")]]"
    ElseIf objMail.Class = olJournal Then
        doClipboard.SetText "[[outlook:" + objMail.EntryID + "][JOURNAL: " + objMail.Subject + " (" + objMail.Type + ")]]"
    ElseIf objMail.Class = olNote Then
        doClipboard.SetText "[[outlook:" + objMail.EntryID + "][NOTE: " + objMail.Subject + " (" + " " + ")]]"
    Else
        doClipboard.SetText "[[outlook:" + objMail.EntryID + "][ITEM: " + objMail.Subject + " (" + objMail.MessageClass + ")]]"
    End If
    
    doClipboard.PutInClipboard
   
   ' For calendar item
   ' Class =
   ' MessageClass = "IPM.Appointment"
   ' Organizer = <Whoever sent it>
   ' For mail item
   ' Class = olMail
   ' MessageClass = "IPM.Note"
   ' SenderName = <Whoever sent it>
   ' etc.
   ' More extensive analysis in org.

End Sub

