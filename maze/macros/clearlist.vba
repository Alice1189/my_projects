Sub ClearList()
    start_x = 11
    start_y = 2
    x_clear = 1
    y_clear = 30
    width_x = 7
    width_y = 5
    height_x = 7
    height_y = 8
    
    '??????? ?????
    Range(Cells(1, start_x - 1), Cells(1048576, 16384)).Clear
    Range(Cells(y_clear, x_clear), Cells(1048576, 16384)).Clear
    Range(Cells(width_y, width_x), Cells(height_y, height_x)) = Empty
    Cells(width_y, width_x).Select
End Sub