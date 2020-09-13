Private Sub Workbook_Open()
    Dim start_x As Integer, start_y As Integer
    Dim x_clear As Integer, y_clear As Integer
    Dim width_x As Integer, width_y As Integer
    Dim height_x As Integer, height_y As Integer
    start_x = 11
    start_y = 2
    x_clear = 1
    y_clear = 30
    width_x = 7
    width_y = 5
    height_x = 7
    height_y = 8
    
    ActiveWindow.DisplayGridlines = False   'убираем сетку
    Range(Cells(width_y, width_x), Cells(height_y, height_x)) = Empty 'очищаем размеры

    'очистка листа
    Range(Cells(1, start_x - 1), Cells(1048576, 16384)).Clear
    Range(Cells(y_clear, x_clear), Cells(1048576, 16384)).Clear
    
    'выделяем ячейку для ввода размеров лабиринта
    Cells(width_y, width_x).Select
    
End Sub
