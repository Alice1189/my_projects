Sub Shortcut_Click()
    mazeToGraph mySolution
End Sub

Function mazeToGraph(ByRef exMaze() As Maze) As Integer()
    Dim size_graph As Integer, arr() As Integer
    Dim len_x As Integer, len_y As Integer
    Dim MAXINT As Integer
    MAXINT = (2 ^ 15) - 1
    len_x = UBound(exMaze, 1) - 1
    len_y = UBound(exMaze, 2) - 1
    size_graph = len_x * len_y
    ReDim arr(1 To size_graph, 1 To size_graph)
    
    Dim i As Integer, j As Integer, k As Integer, t As Integer
    'разделяем все вершины (рёбер нет)
    For i = 1 To size_graph
        For j = 1 To size_graph
            If i = j Then
                arr(i, j) = 0
            Else
                arr(i, j) = MAXINT / 4
            End If
        Next j
    Next i
    
    'ставим рёбра там, где нет стен
    For i = 1 To len_x
        For j = 1 To len_y
            k = (j - 1) * len_x + i
            arr(k, k) = 0 'путь в себя
            If exMaze(i, j).Top = False Then
                t = (j - 2) * len_x + i
                arr(k, t) = 1 'путь из (i, j) в (i, j - 1)
                arr(t, k) = 1
            End If
            If exMaze(i, j).Right = False Then
                t = (j - 1) * len_x + i + 1
                arr(k, t) = 1 'путь из (i, j) в (i + 1, j)
                arr(t, k) = 1
            End If
            If exMaze(i, j).Bottom = False Then
                t = (j) * len_x + i
                arr(k, t) = 1 'путь из (i, j) в (i, j + 1)
                arr(t, k) = 1
            End If
            If exMaze(i, j).Left = False Then
                t = (j - 1) * len_x + i - 1
                arr(k, t) = 1 'путь из (i, j) в (i - 1, j)
                arr(t, k) = 1
            End If
        Next j
    Next i
    
    mazeToGraph = arr
    Shortcut arr
End Function

Function Shortcut(ByRef exGraph() As Integer) As Integer()
    Dim size_graph As Integer, arr() As Integer, way() As Integer
    size_graph = UBound(exGraph, 1)
    ReDim arr(1 To size_graph, 1 To size_graph)
    ReDim way(1 To size_graph, 1 To size_graph)

    Dim i As Integer, j As Integer, k As Integer, t As Integer
    For i = 1 To size_graph
        For j = 1 To size_graph
            arr(i, j) = exGraph(i, j)
            way(i, j) = i
        Next j
    Next i
    'алгоритм Флойда
    For k = 1 To size_graph
        For i = 1 To size_graph
            If i <> k Then
                For j = 1 To size_graph
                    If j <> k Then
                        If arr(i, j) > arr(i, k) + arr(k, j) Then
                            arr(i, j) = arr(i, k) + arr(k, j)
                            way(i, j) = way(k, j)
                        End If
                    End If
                Next j
            End If
        Next i
    Next k
    
    Shortcut = way
    shortcut_color way
End Function

Function shortcut_color(ByRef arr() As Integer) As Integer()
    Dim size_graph As Integer
    size_graph = UBound(arr, 1)

    Dim i As Integer, j As Integer, k As Integer, t As Integer
    
    start_x = 11
    start_y = 2
    width_x = 7
    width_y = 5
    height_x = 7
    height_y = 8
    
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

    'раскраска
    k = size_graph
    t = 1
    While arr(k, t) <> size_graph
        i = arr(k, t) Mod len_x
        If i = 0 Then
            i = len_x
        End If
        j = (arr(k, t) - i) / len_x + 1
        If j > len_y Then
            j = len_y
        End If
        Cells(j + start_y - 1, i + start_x - 1).Select
        Cells(j + start_y - 1, i + start_x - 1).Interior.Color = RGB(219, 147, 255)
        t = arr(k, t)
    Wend

    Cells(start_y, start_x).Interior.Color = RGB(250, 128, 114)
    Cells(len_y + 1, start_x - 1 + len_x).Interior.Color = RGB(250, 128, 114)
    Cells(len_y + 1, start_x - 1 + len_x).Select
End Function