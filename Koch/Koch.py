import sys
import PyQt5
from PyQt5 import QtWidgets
from PyQt5 import QtGui
from PyQt5 import QtCore
import math 

h=650
w=650
print('введите глубину, желательно не больше 6')
P=int(input())
class Example(QtWidgets.QWidget):
    
    def __init__(self):
        super(Example, self).__init__()
        
        self.initUI()
        
    def initUI(self):
        
        self.setGeometry(300, 300, w, h)
        self.setWindowTitle('Snowflake')
        self.show()

    def paintEvent(self, e):

        qp = QtGui.QPainter() # Создаём класс для рисования
        qp.begin(self)        # начинаем рисовать на self, то есть на виджете.
        self.drawKoch(qp)     # Само рисование проходит в методе drawClock.
        qp.end()              # Чтобы результаты всегда корректно отображались,
                              # у объектов класса QPainter надо вызвать метод end.
        
    def drawKoch(self, qp):

        
        def sf (ax, ay, bx, by, N):
            f = math.sqrt((bx - ax) ** 2 + (by - ay) ** 2)
            if (N == 0):
                 qp.drawLine(ax, ay, bx, by)
                 return
            f3 = f / 3
            #делим отрезок на 3 части
            cs = (bx - ax) / f
            sn = (by - ay) / f
            #координаты одной точки посередине
            cx = ax + cs * f3
            cy = ay + sn * f3
            h = f3 * math.sqrt(3) / 2
            dx = (ax + bx) / 2 + sn * h
            dy = (ay + by) / 2 - cs * h
            #координаты второй точки
            ex = bx - cs * f3
            ey = by - sn * f3
            sf(ax, ay, cx, cy, N-1)
            sf(cx, cy, dx, dy, N-1)
            sf(dx, dy, ex, ey, N-1)
            sf(ex, ey, bx, by, N-1)
        def st(l, d):
      
            H = l / 2
            W = d / 2
            r = W
            a = 2 * math.pi / 3
            for k in range(3):
            #отмечаем точки на окружности
                x0 = W + r * math.cos(a * k)
                y0 = H + r * math.sin(a * k)
                x1 = W + r * math.cos(a * (k + 1))
                y1 = H + r * math.sin(a * (k + 1))
                sf( x0 + w / 2 - W, y0 + h / 2 - H, x1 + w / 2 - W, y1 + h / 2 - H, 5)
        pen = QtGui.QPen(QtCore.Qt.black, 1, QtCore.Qt.SolidLine)
        qp.setPen(pen)
        for i in range(0,P):
            st(h*((math.sqrt(5)-1)/2)**i,w*((math.sqrt(5)-1)/2)**i)
def main():
    app = QtWidgets.QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()