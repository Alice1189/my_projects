from lxml import etree
import pandas as pd

# склейка тегов через слэши
def print_path(key_list = [], last_key = ''):
	str_path = ''
	for row in key_list:
		str_path += row + '/'
	str_path += last_key
	return str_path

def foo(root):
	# если в тэге root есть вложенные тэги
	if len(root) > 0:
		# добавляем в стэк пути тэг
		xml_list.append(root.tag)
		# для дочерних тэгов делаем то же самое
		for child in root:
			foo(child)
		# выталкиваем тэг из стека, когда прошлись по всем вложенным
		del xml_list[len(xml_list) - 1]
	# если тэг конечный и в нём только текст
	else:
		# выводим путь до конечного тэга и текст по нему
		print(print_path(xml_list, root.tag),'\t', root.text)
		# пишем пути с текстом по ним в датафрейм
		data.loc[data.shape[0] + 1, 'path'] = print_path(xml_list, root.tag)
		data.loc[data.shape[0], 'value'] = str(root.text)

with open('test.xml', 'rb') as f:
	xml_file = f.read()
	root = etree.fromstring(xml_file)

	xml_list = []
	data = pd.DataFrame(columns = ['path', 'value'])
	foo(root)

	# записываем датафрейм в файл xlsx
	data.to_excel('data.xlsx', index = False, encoding = 'utf-8-sig')