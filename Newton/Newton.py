import sys
import math
import PyQt5
from PyQt5 import QtWidgets
from PyQt5 import QtGui

class Example(QtWidgets.QWidget):
    def __init__(self):
        super(Example, self).__init__()
        self.initUI()
        
    def initUI(self):      
        self.setGeometry(300, 300, 300, 300)
        self.setWindowTitle('Pen styles')
        self.show()

    def paintEvent(self, e):
        qp = QtGui.QPainter() # Создаём класс для рисования
        qp.begin(self)        # начинаем рисовать на self, то есть на виджете.
        self.drawNewton(qp)   # Само рисование проходит в методе drawClock.
        qp.end()              # Чтобы результаты всегда корректно отображались,
                              # у объектов класса QPainter надо вызвать метод end.
        
    def drawNewton(self, qp):
        roots = [(-1), (1), (-(-1)**(1/3)), ((-1)**(1/3)), (-(-1)**(2/3)), ((-1)**(2/3))]
        colors = [ QtGui.QColor(r, g, b) for r, g, b in
                  [(255, 0, 0), (255, 215, 0), (0, 0, 255), (247, 84, 255), (100, 0, 100), (0, 230, 222)]]
        print(colors)
        h = self.height()
        w = self.width()
        for y in range(h):
            for x in range(w):
                x1 = 2 * x / w - 1
                y1 = 2 * y / h - 1
                try:
                    z = complex(x1,y1)
                    for i in range(0,60):
                        z = z - (z ** 6 - 1) / (6 * z ** 5)
                except:
                    z = 0
                min1 = 100500
                for ind, root in enumerate(roots):
                    dist = abs(root - z)
                    if dist < min1:
                        min1 = dist
                        ind1 = ind
                qp.setPen(colors[ind1])
                qp.drawPoint(x, y)  

def main():
    app = QtWidgets.QApplication(sys.argv)
    w = Example()
    w.move(300, 300)
    w.setWindowTitle('Newton')
    w.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
