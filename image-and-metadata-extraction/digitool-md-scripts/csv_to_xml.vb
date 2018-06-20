Sub csv_to_xmls()

'macro must be stored in Personal Macro Workbook (universal) since it switches between files
'
'
'splits apart csv file with rows of xml entries into individual xml files
'csv as PID in first column, mix xml in second column
'renames xml files as PID

'
Set MyWorkbook = ActiveWorkbook

Dim i As Integer

'set i as number of rows to be processed
For i = 2 To 5

'copy and paste each row into a new workbook
    Range(Cells(i, 1), Cells(i, 2)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste

'save each new workbook named as PID (in A1) and in machine-readable format
Dim Path As String
Dim filename As String
Path = "/Users/walkerpb/Desktop/DigiTool/"
filename = Range("A1")
ActiveWorkbook.SaveAs filename:=Path & filename & ".csv", FileFormat:=xlCSV

'reset filename
filename = filename

'delete PID column so only MIX xml remains
    Columns("A:A").Select
    Selection.Delete Shift:=xlToLeft
    
'save new csv as .xml
ActiveWorkbook.Save
ActiveWorkbook.SaveAs filename:=Path & filename & ".xml"
ActiveWorkbook.Save
ActiveWorkbook.Close

'return to main workbook

MyWorkbook.Activate
Next i

End Sub
