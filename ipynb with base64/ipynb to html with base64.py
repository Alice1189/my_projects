#!/usr/bin/env python
# coding: utf-8

import requests
from bs4 import BeautifulSoup
import os
import codecs
import base64

#ipynb_names = ['01.ipynb', '02.ipynb', '03.ipynb', '04.ipynb', '05.ipynb', '05_SQL.ipynb',
#               '06.ipynb', '07.ipynb', '08.ipynb', '09.ipynb', '11.ipynb']


# Структура:  
# в одной папке лежат все проекты и папка с изображениями (images), в которую сохранялись графики при выполнении проектов, и из которой же берутся графики для отображения в ячейках markdown

# берём все проекты
get_ipython().system('jupyter nbconvert 01.ipynb 02.ipynb 03.ipynb 04.ipynb 05.ipynb 05_SQL.ipynb 06.ipynb 07.ipynb 08.ipynb 09.ipynb 11.ipynb')

# названия html файлов
html_names = ['01.html', '02.html', '03.html', '04.html', '05.html', '05_SQL.html',
              '06.html', '07.html', '08.html', '09.html', '11.html']

# проходимся по всем файлам html
for nb_file in html_names:
    # открываем файл, читаем
    fin = codecs.open(os.path.abspath(nb_file), encoding='utf-8', mode='r')
    s = fin.read()
    soup = BeautifulSoup(s)
    # условие для файла с нетипичным названием "05_SQL", чтобы он правильно перезаписался
    k = 2 if nb_file[2] != '_' else 6
    # создаём пустой файл html
    fout = codecs.open(os.path.abspath(nb_file[:k]+'_2.html'), encoding='utf-8', mode='w')
    # находим все картинки по тегу img
    images = soup.findAll('img')
    # создаём словарь соответствия <что заменить>:<на что заменить>
    d = {}
    for img in images:
        # для каждой картинки определяем, график это или вставленная нами картинка
        # (графики, которые генерируются в процессе выполнения кода, записываются в html в base64, но тоже с тегом img)
        # если в атрибуте src картинки есть название папки, в которой лежат все картинки
        if 'images/' in img['src']:
            # по пути из src берём картинку и генерируем код base64
            encoded = str(base64.b64encode(open(img['src'], "rb").read()))
            l = len(encoded)
            # пишем в словарь <старый src>:<новый src>
            d[img['src']] = 'data:image/png;base64,'+encoded[2:l-1]
            # меняем содержимое исходного html файла
            new_s = s.replace('src="'+img['src'], 'src="'+d[img['src']])
            s = new_s
    # пишем в новый, пока пустой, html файл преобразованное содержимое исходного html файла
    fout.write(s)
    # закрываем файлы
    fout.close()
    fin.close()
    # удаляем исходный html файл
    os.remove(os.path.abspath(nb_file))
    # меняем название нового html файла на название исходного
    os.rename(nb_file[:k]+'_2.html', nb_file)