Option Explicit
   Dim rowsNum
   rowsNum = 0
'-----------------------------------------------------------------------------
' Main function
'-----------------------------------------------------------------------------
' Get the current active model
    Dim Model
    Set Model = ActiveModel
    If (Model Is Nothing) Or (Not Model.IsKindOf(PdPDM.cls_Model)) Then
       MsgBox "The current model is not an PDM model."
    Else
      ' Get the tables collection
      '创建EXCEL APP
      dim beginrow
      DIM EXCEL, SHEET, SHEETLIST
      set EXCEL = CREATEOBJECT("Excel.Application")
      EXCEL.workbooks.add(-4167)'添加工作表
      EXCEL.workbooks(1).sheets(1).name ="表结构"
      set SHEET = EXCEL.workbooks(1).sheets("表结构")

      EXCEL.workbooks(1).sheets.add
      EXCEL.workbooks(1).sheets(1).name ="目录"
      set SHEETLIST = EXCEL.workbooks(1).sheets("目录")
      ShowTableList Model,SHEETLIST

      ShowProperties Model, SHEET,SHEETLIST


      EXCEL.workbooks(1).Sheets(2).Select
      EXCEL.visible = true
      '设置列宽和自动换行
      sheet.Columns(1).ColumnWidth = 12
      sheet.Columns(2).ColumnWidth = 20
      sheet.Columns(3).ColumnWidth = 30
      sheet.Columns(4).ColumnWidth = 20
      sheet.Columns(5).ColumnWidth = 20
      sheet.Columns(6).ColumnWidth = 15
      sheet.Columns(7).ColumnWidth = 8
      sheet.Columns(8).ColumnWidth = 8
      sheet.Columns(9).ColumnWidth = 10
      sheet.Columns(9).ColumnWidth = 10
      sheet.Columns(1).WrapText =true
      sheet.Columns(2).WrapText =true
      sheet.Columns(4).WrapText =true
      sheet.Columns(7).WrapText =true
      sheet.Columns(8).WrapText =true
      '不显示网格线
      EXCEL.ActiveWindow.DisplayGridlines = False


 End If
'-----------------------------------------------------------------------------
' Show properties of tables
'-----------------------------------------------------------------------------
Sub ShowProperties(mdl, sheet,SheetList)
   ' Show tables of the current model/package
   rowsNum=0
   beginrow = rowsNum+1
   Dim rowIndex
   rowIndex=3
   ' For each table
   output "begin"
   Dim tab
   sheet.cells(1, 1) = "Owner"
   sheet.cells(1, 2) = "Table"
   sheet.cells(1, 3) = "Code"
   sheet.cells(1, 4) = "Name"
   sheet.cells(1, 5) = "Comment"
   sheet.cells(1, 6) = "Data Type"
   sheet.cells(1, 7) = "Length"
   sheet.cells(1, 8) = "Primary"
   sheet.cells(1, 9) = "Null"
   sheet.cells(1, 10) = "Defaultvalue"
   For Each tab In mdl.tables
      ShowTable tab,sheet,rowIndex,sheetList
      rowIndex = rowIndex +1
   Next
   if mdl.tables.count > 0 then
        sheet.Range("A" & beginrow + 1 & ":A" & rowsNum).Rows.Group
   end if
   output "end"
End Sub
'-----------------------------------------------------------------------------
' Show table properties
'-----------------------------------------------------------------------------
Sub ShowTable(tab, sheet,rowIndex,sheetList)
   If IsObject(tab) Then
     Dim rangFlag
     rowsNum = rowsNum + 1
      ' Show properties
      Output "================================"
      '设置边框
      sheet.Range(sheet.cells(rowsNum, 1),sheet.cells(rowsNum, 10)).Borders.LineStyle = "1"
      'sheet.Range(sheet.cells(rowsNum-1, 4),sheet.cells(rowsNum, 10)).Borders.LineStyle = "1"
      '字体为10号
      sheet.Range(sheet.cells(rowsNum, 1),sheet.cells(rowsNum, 10)).Font.Size=10
            Dim col ' running column
            Dim colsNum
            colsNum = 0
      for each col in tab.columns
        rowsNum = rowsNum + 1
        colsNum = colsNum + 1
        sheet.cells(rowsNum, 1) = tab.Owner
        sheet.cells(rowsNum, 2) = tab.code
        sheet.cells(rowsNum, 3) = col.code
        sheet.cells(rowsNum, 4) = col.name
        sheet.cells(rowsNum, 5) = col.comment
        sheet.cells(rowsNum, 6) = col.datatype
        sheet.cells(rowsNum, 7) = col.Length
          If col.Primary = true Then
        sheet.cells(rowsNum, 8) = "Y"
        Else
        sheet.cells(rowsNum, 8) = " "
        End If
        If col.Mandatory = true Then
        sheet.cells(rowsNum, 9) = "Y"
        Else
        sheet.cells(rowsNum, 9) = " "
        End If
        sheet.cells(rowsNum, 10) =  col.defaultvalue
      next
      sheet.Range(sheet.cells(rowsNum-colsNum+1,1),sheet.cells(rowsNum,10)).Borders.LineStyle = "3"
      'sheet.Range(sheet.cells(rowsNum-colsNum+1,4),sheet.cells(rowsNum,10)).Borders.LineStyle = "3"
      sheet.Range(sheet.cells(rowsNum-colsNum+1,1),sheet.cells(rowsNum,10)).Font.Size = 10

      Output "FullDescription: "       + tab.Name
   End If

End Sub
'-----------------------------------------------------------------------------
' Show List Of Table
'-----------------------------------------------------------------------------
Sub ShowTableList(mdl, SheetList)
   ' Show tables of the current model/package
   Dim rowsNo
   rowsNo=1
   ' For each table
   output "begin"
   SheetList.cells(rowsNo, 1) = "主题"
   SheetList.cells(rowsNo, 2) = "表中文名"
   SheetList.cells(rowsNo, 3) = "表英文名"
   SheetList.cells(rowsNo, 4) = "表说明"
   rowsNo = rowsNo + 1
   SheetList.cells(rowsNo, 1) = mdl.name
   Dim tab
   For Each tab In mdl.tables
     If IsObject(tab) Then
         rowsNo = rowsNo + 1
      SheetList.cells(rowsNo, 1) = ""
      SheetList.cells(rowsNo, 2) = tab.name
      SheetList.cells(rowsNo, 3) = tab.code
      SheetList.cells(rowsNo, 4) = tab.comment
     End If
   Next
    SheetList.Columns(1).ColumnWidth = 20
      SheetList.Columns(2).ColumnWidth = 20
      SheetList.Columns(3).ColumnWidth = 30
     SheetList.Columns(4).ColumnWidth = 60
   output "end"
End Sub
