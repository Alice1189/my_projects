# ipynb with base64
Для корректного отображения картинок, вставленных в ячейки markdown тетрадок Jupyter Notebook, при выгрузке на GitHub.  

Скрипт перебирает список файлов (.ipynb), находит пути изображений в ячейках markdown, преобразует эти изображения в base64 и заменяет пути изображений на их код.