import os
import json

folder_path = './assets/the_goon_folder'  # Replace with the actual folder path

file_dict = {}

for file_name in os.listdir(folder_path):
    key = os.path.splitext(file_name)[0].capitalize()
    value = {
        'price': 100,
        'filepath': file_name
    }
    file_dict[key] = value

json_data = json.dumps(file_dict, indent=4)
with open('./assets/goon_index.json', 'w') as file:
    file.write(json_data)