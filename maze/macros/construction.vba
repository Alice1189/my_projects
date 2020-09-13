'структура "клетка лабиринта"
Type Maze
    Top As Boolean
    Left As Boolean
    Right As Boolean
    Bottom As Boolean
    Flag_visited As Boolean
    X As Integer
    Y As Integer
End Type

Dim myMaze() As Maze, myStack() As Maze
Dim top_left_point As Maze, pointer As Integer
Dim nei(4) As Integer, k As Integer, flag_nei As Boolean
Dim r As Integer, flag_visit As Boolean
Dim mySolution() As Maze, solutionStack() As Maze

Dim start_x As Integer, start_y As Integer
Dim len_x As Integer, len_y As Integer
Dim x_clear As Integer, y_clear As Integer
Dim width_x As Integer, width_y As Integer
Dim height_x As Integer, height_y As Integer

Public Sub Construction()
    start_x = 11
    start_y = 2
    x_clear = 1
    y_clear = 30
    width_x = 7
    width_y = 5
    height_x = 7
    height_y = 8
    
    If Not IsNumeric(Cells(width_y, width_x)) Or Not IsNumeric(Cells(height_y, height_x)) Then
        len_x = 0
        len_y = 0
    Else
        len_x = Cells(width_y, width_x)
        len_y = Cells(height_y, height_x)
    End If
    
    If len_x = 0 Or len_y = 0 Then
        Dim lRetVal As Long
        lRetVal = MsgBox("Недопустимые размеры лабиринта!", vbCritical)
    Else
        'очистка листа
        Range(Cells(1, start_x - 1), Cells(1048576, 16384)).Clear
        Range(Cells(y_clear, x_clear), Cells(1048576, 16384)).Clear
        
        'границы лабиринта
        Range(Cells(start_y, start_x), Cells(len_y + 1, start_x - 1 + len_x)).Select
        Range(Cells(start_y, start_x), Cells(len_y + 1, start_x - 1 + len_x)).Borders.LineStyle = True
                
        With Selection.Borders(xlEdgeLeft)
            .LineStyle = xlContinuous
            .ColorIndex = 0
            .TintAndShade = 0
            .Weight = xlThick
        End With
        With Selection.Borders(xlEdgeTop)
            .LineStyle = xlContinuous
            .ColorIndex = 0
            .TintAndShade = 0
            .Weight = xlThick
        End With
        With Selection.Borders(xlEdgeBottom)
            .LineStyle = xlContinuous
            .ColorIndex = 0
            .TintAndShade = 0
            .Weight = xlThick
        End With
        With Selection.Borders(xlEdgeRight)
            .LineStyle = xlContinuous
            .ColorIndex = 0
            .TintAndShade = 0
            .Weight = xlThick
        End With
        
        'построение лабиринта
        ReDim myMaze(0 To (1 + len_x), 0 To (1 + len_y))
        'координаты левой верхней ячейки
        myMaze(0, 0).X = Selection.Column
        myMaze(0, 0).Y = Selection.Row
        top_left_point.X = myMaze(0, 0).X
        top_left_point.Y = myMaze(0, 0).Y
        
        'записываем данные обо всех ячейках
        Dim i As Integer, j As Integer
        For i = 1 To len_x
            For j = 1 To len_y
                myMaze(i, j).Top = True
                myMaze(i, j).Left = True
                myMaze(i, j).Right = True
                myMaze(i, j).Bottom = True
                myMaze(i, j).Flag_visited = False
                myMaze(i, j).X = i + top_left_point.X - 1
                myMaze(i, j).Y = j + top_left_point.Y - 1
            Next j
        Next i
        
        'генерируем лабиринт
        Dim myStack() As Maze
        Dim counter As Integer, pointer As Integer
        Dim nei(4) As Integer, k As Integer 'посещенность соседей
        ReDim myStack(1 To len_y * len_x)
        myMaze(1, 1).Flag_visited = True
        counter = 1
        pointer = 0
        i = 1
        j = 1
        'пока не просмотрены все ячейки
        While counter < len_x * len_y
            Cells(myMaze(i, j).Y, myMaze(i, j).X).Select
            If i <> len_x Then
                If myMaze(i + 1, j).Flag_visited = False Then 'right
                    nei(0) = 1
                End If
            End If
            If j <> len_y Then
                If myMaze(i, j + 1).Flag_visited = False Then 'bottom
                    nei(1) = 1
                End If
            End If
            If i <> 1 Then
                If myMaze(i - 1, j).Flag_visited = False Then 'left
                    nei(2) = 1
                End If
            End If
            If j <> 1 Then
                If myMaze(i, j - 1).Flag_visited = False Then 'top
                    nei(3) = 1
                End If
            End If
            'если есть непосещенные соседи
            If nei(0) = 1 Or nei(1) = 1 Or nei(2) = 1 Or nei(3) = 1 Then
                pointer = pointer + 1
                myStack(pointer) = myMaze(i, j)
                'выбрать любого непосещенного соседа
                flag_nei = False
                While flag_nei = False
                    r = Int(4 * Rnd)
                    flag_nei = True
                    If nei(r) = 0 Then
                        flag_nei = False
                    End If
                Wend
                'сломать стенку с соседом и перейти туда
                Select Case r
                    Case 0 'Right
                        myMaze(i, j).Right = False
                        Cells(myMaze(i, j).Y, myMaze(i, j).X).Borders(xlEdgeRight).LineStyle = False
                        myMaze(i + 1, j).Left = False
                        i = i + 1
                    Case 1 'Bottom
                        myMaze(i, j).Bottom = False
                        Cells(myMaze(i, j).Y, myMaze(i, j).X).Borders(xlEdgeBottom).LineStyle = False
                        myMaze(i, j + 1).Top = False
                        j = j + 1
                    Case 2 'Left
                        myMaze(i, j).Left = False
                        Cells(myMaze(i, j).Y, myMaze(i, j).X).Borders(xlEdgeLeft).LineStyle = False
                        myMaze(i - 1, j).Right = False
                         i = i - 1
                    Case 3 'Top
                        myMaze(i, j).Top = False
                        Cells(myMaze(i, j).Y, myMaze(i, j).X).Borders(xlEdgeTop).LineStyle = False
                        myMaze(i, j - 1).Bottom = False
                        j = j - 1
                    Case Else
                        MsgBox ("Error on case selection")
                End Select
                myMaze(i, j).Flag_visited = True
                counter = counter + 1
                For k = 0 To 3
                    nei(k) = 0
                Next
            ElseIf pointer <> 0 Then
                'если нет соседей, выталкиваем из стэка
                i = myStack(pointer).X + 1 - top_left_point.X
                j = myStack(pointer).Y + 1 - top_left_point.Y
                pointer = pointer - 1
            Else
                'найти случайную непосещенную, посетить
                flag_visit = True
                For j = 1 To len_y
                    For i = 1 To len_x
                        If myMaze(i, j).Flag_visited = False Then
                            flag_visit = False
                            Exit For
                        End If
                    Next
                    If flag_visit = False Then
                        Exit For
                    End If
                Next
            End If
        Wend

        Cells(top_left_point.Y, top_left_point.X).Select
    End If
End Sub
