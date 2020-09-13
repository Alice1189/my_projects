Public Function toBool(ByVal a As Long) As Boolean
    If a = xlLineStyleNone Then
        toBool = False
    Else
        toBool = True
    End If
End Function

Sub Solution()
    start_x = 11
    start_y = 2
    x_clear = 1
    y_clear = 30
    width_x = 7
    width_y = 5
    height_x = 7
    height_y = 8
    
    Dim i As Integer, j As Integer
    i = 0
    j = 0
    While Cells(start_y, start_x + i).Borders(xlEdgeRight).Weight <> 4
        i = i + 1
    Wend
    While Cells(start_y + j, start_x).Borders(xlEdgeBottom).Weight <> 4
        j = j + 1
    Wend
    len_x = i + 1
    len_y = j + 1
    
    If len_x = 0 Or len_y = 0 Then
        MsgBox ("Недопустимые размеры лабиринта!")
    Else
        'очищаем лабиринт от цветов и данных предыдущего прохождения
        Range(Cells(y_clear, x_clear), Cells(1048576, 8)).Clear
        Range(Cells(1, start_x - 1), Cells(len_y + 1, start_x - 1 + len_x)).Interior.ColorIndex = xlNone
        Range(Cells(1, start_x - 1), Cells(len_y + 1, start_x - 1 + len_x)) = Empty
        Range(Cells(y_clear, x_clear + 1), Cells(y_clear + 3, x_clear + 7)).Merge
        Range(Cells(y_clear, x_clear + 1), Cells(y_clear + 3, x_clear + 7)).HorizontalAlignment = xlCenter
        Range(Cells(y_clear, x_clear + 1), Cells(y_clear + 3, x_clear + 7)).VerticalAlignment = xlCenter
        'помечаем старт и финиш
        Cells(start_y, start_x).Interior.Color = RGB(250, 128, 114)
        Cells(len_y + 1, start_x - 1 + len_x).Interior.Color = RGB(250, 128, 114)
        Cells(start_y, start_x - 1) = ChrW(&H2192)
        Cells(len_y + 1, start_x + len_x) = ChrW(&H2192)
        Cells(start_y, start_x - 1).HorizontalAlignment = xlRight
        Cells(start_y, start_x - 1).VerticalAlignment = xlCenter
        Cells(len_y + 1, start_x + len_x).HorizontalAlignment = xlLeft
        Cells(len_y + 1, start_x + len_x).VerticalAlignment = xlCenter
        
        top_left_point.X = start_x
        top_left_point.Y = start_y

        ReDim mySolution(0 To (1 + len_x), 0 To (1 + len_y))
        
        'записываем данные обо всех ячейках
        For i = 1 To len_x
            For j = 1 To len_y
                mySolution(i, j).X = i + top_left_point.X - 1
                mySolution(i, j).Y = j + top_left_point.Y - 1
                mySolution(i, j).Top = toBool(Cells(mySolution(i, j).Y, mySolution(i, j).X).Borders(xlEdgeTop).LineStyle)
                mySolution(i, j).Left = toBool(Cells(mySolution(i, j).Y, mySolution(i, j).X).Borders(xlEdgeLeft).LineStyle)
                mySolution(i, j).Right = toBool(Cells(mySolution(i, j).Y, mySolution(i, j).X).Borders(xlEdgeRight).LineStyle)
                mySolution(i, j).Bottom = toBool(Cells(mySolution(i, j).Y, mySolution(i, j).X).Borders(xlEdgeBottom).LineStyle)
                mySolution(i, j).Flag_visited = False
            Next j
        Next i
        
        'генерируем путь
        Dim flag_exit As Boolean
        flag_exit = False
        For k = 0 To 3
            nei(k) = 0
        Next
        ReDim solutionStack(1 To len_y * len_x)
        mySolution(1, 1).Flag_visited = True
        pointer = 0
        i = 1
        j = 1
        'пока не посетили финиш или не обнаружили, что пути нет
        While mySolution(len_x, len_y).Flag_visited = False And flag_exit = False
            Cells(start_y, start_x).Interior.Color = RGB(250, 128, 114)
            Cells(mySolution(i, j).Y, mySolution(i, j).X).Select
            Cells(mySolution(i, j).Y, mySolution(i, j).X).Interior.Color = RGB(152, 251, 152)
            If i <> len_x Then
                If mySolution(i + 1, j).Flag_visited = False And mySolution(i, j).Right = False Then 'right
                    nei(0) = 1
                End If
            End If
            If j <> len_y Then
                If mySolution(i, j + 1).Flag_visited = False And mySolution(i, j).Bottom = False Then  'bottom
                    nei(1) = 1
                End If
            End If
            If i <> 1 Then
                If mySolution(i - 1, j).Flag_visited = False And mySolution(i, j).Left = False Then  'left
                    nei(2) = 1
                End If
            End If
            If j <> 1 Then
                If mySolution(i, j - 1).Flag_visited = False And mySolution(i, j).Top = False Then  'top
                    nei(3) = 1
                End If
            End If
            'если есть непосещенные соседи
            If nei(0) = 1 Or nei(1) = 1 Or nei(2) = 1 Or nei(3) = 1 Then
                pointer = pointer + 1
                solutionStack(pointer) = mySolution(i, j)
                'выбираем случайного непосещенного соседа
                flag_nei = False
                While flag_nei = False
                    r = Int(4 * Rnd)
                    flag_nei = True
                    If nei(r) = 0 Then
                        flag_nei = False
                    End If
                Wend
                Cells(mySolution(i, j).Y, mySolution(i, j).X).Interior.Color = RGB(135, 206, 250)
                'переходим в соседнюю ячейку
                Select Case r
                    Case 0 'Right
                        i = i + 1
                    Case 1 'Bottom
                        j = j + 1
                    Case 2 'Left
                        i = i - 1
                    Case 3 'Top
                        j = j - 1
                    Case Else
                        MsgBox ("Error on case selection")
                End Select
                mySolution(i, j).Flag_visited = True
                For k = 0 To 3
                    nei(k) = 0
                Next
            ElseIf pointer <> 0 Then
                'если нет соседей, выталкиваем из стэка
                i = solutionStack(pointer).X + 1 - top_left_point.X
                j = solutionStack(pointer).Y + 1 - top_left_point.Y
                Cells(mySolution(i, j).Y, mySolution(i, j).X).Interior.Color = RGB(152, 251, 152)
                pointer = pointer - 1
            Else
                'выхода нет
                Cells(y_clear, x_clear + 1) = "Выхода нет..."
                flag_exit = True
            End If
        Wend
        
        Cells(mySolution(len_x, len_y).Y, mySolution(len_x, len_y).X).Select
    End If
End Sub
