import xml.etree.ElementTree as ET
from datetime import datetime

def sort_svn_log(input_file, output_file):
    tree = ET.parse(input_file)
    root = tree.getroot()

    # Собираем все logentry (включая вложенные)
    all_entries = []
    for parent in root.findall('.//logentry/..'):
        for entry in parent.findall('logentry'):
            all_entries.append((entry, parent))

    # Сортируем по дате (новые → старые)
    all_entries.sort(
        key=lambda x: datetime.strptime(x[0].find('date').text, '%Y-%m-%dT%H:%M:%S.%fZ'),
        reverse=True
    )

    # Удаляем все logentry из их исходных родителей
    for entry, parent in all_entries:
        parent.remove(entry)

    # Добавляем отсортированные в корень <log>
    for entry, _ in all_entries:
        root.append(entry)

    # Сохраняем (с правильным форматированием)
    tree.write(output_file, encoding='utf-8', xml_declaration=True)

sort_svn_log('svn_log.xml', 'svn_log_sorted.xml')