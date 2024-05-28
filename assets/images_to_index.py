import os
import json
from PIL import Image


def generate_index(folder_path: str, save_location: str) -> None:
    file_dict = {}
    tier_dict = {
        'Free': [],
        'Trash': [],
        'Common': [],
        'Uncommon': [],
        'Rare': [],
        'Epic': [],
        'Legendary': [],
        'Mythical': [],
        'Godly': [],
        'GOATED': [],
    }

    # Check if the index file already exists
    index_file_path = f'{save_location}/goon_index.json'
    if os.path.exists(index_file_path):
        with open(index_file_path, 'r') as file:
            existing_index = json.load(file)
    else:
        existing_index = {}

    max_id = max((value['id'] for value in existing_index.values()), default=0)
    for file_name in os.listdir(folder_path):
        base_name = os.path.splitext(file_name)[0]
        names = base_name.split('_')
        capitalized_names = [name.capitalize() for name in names]
        key = ' '.join(capitalized_names)

        # Use the tier value from the existing index if it exists, otherwise use "basic"
        tier = existing_index.get(key, {}).get('tier', 'Common')

        if key not in existing_index:
            max_id += 1
            obj_id = max_id
        else:
            obj_id = existing_index[key]['id']

        value = {
            'id': obj_id,
            'name': key,
            'tier': tier,
            'filepath': file_name
        }
        file_dict[key] = value
        
        # Add the name to the list of names for this tier
        if tier not in tier_dict:
            tier_dict[tier] = []
        tier_dict[tier].append(key)

    json_data = json.dumps(file_dict, indent=4)
    with open(index_file_path, 'w') as file:
        file.write(json_data)

    # Print the names for each tier
    with open(f'{save_location}/tier_index.json', 'w') as file:
        json.dump(tier_dict, file, indent=4)

    
    print('Index file generated successfully.')

def search_for_missing_banner(icons: str, comparision: str, name: str = 'banner') -> bool:
    files1 = set(os.path.splitext(file)[0] for file in os.listdir(icons))
    files2 = set(os.path.splitext(file)[0] for file in os.listdir(comparision))

    missing_files = files1.symmetric_difference(files2)

    if not missing_files:
        print(f'All icons have a corresponding {name}.')
        return True
    
    missing_icons = []
    missing_banners = []
    for file in missing_files:
        if file in files1:
            missing_banners.append(file)
        else:
            missing_icons.append(file)
    
    if missing_icons:
        print('\nMissing icons:')
        for icon in missing_icons:
            print(icon)

    if missing_banners:
        print(f'\nMissing {name}:')
        for banner in missing_banners:
            print(banner)
    
    return False

def convert_images_to_jpeg(
        folder_path: str, 
        aspect_ratio: float = 16 / 9, 
        target_size: tuple[int, int] = (1280, 720)) -> None: # Adjust this as needed

    for file_name in os.listdir(folder_path):
        if file_name.endswith(('.webp', '.png', '.jpg', '.jpeg')):
            image_path = os.path.join(folder_path, file_name)
            img = Image.open(image_path)
            img_aspect_ratio = img.width / img.height

            if img_aspect_ratio > aspect_ratio:
                # The image is wider than the target aspect ratio
                new_width = int(target_size[1] * img_aspect_ratio)
                new_size = (new_width, target_size[1])
            else:
                # The image is taller than the target aspect ratio
                new_height = int(target_size[0] / img_aspect_ratio)
                new_size = (target_size[0], new_height)

            img = img.resize(new_size, resample=Image.Resampling.LANCZOS)
            rgb_img = img.convert('RGB')

            # Crop the image to the target size
            left = (rgb_img.width - target_size[0]) / 2
            top = (rgb_img.height - target_size[1]) / 2
            right = (rgb_img.width + target_size[0]) / 2
            bottom = (rgb_img.height + target_size[1]) / 2
            rgb_img = rgb_img.crop((left, top, right, bottom))

            base_name = os.path.splitext(file_name)[0]
            new_file_name = f'{base_name}.jpeg'
            new_file_path = os.path.join(folder_path, new_file_name)
            rgb_img.save(new_file_path, 'JPEG')

            # Delete the original file if it's not a JPEG
            if not file_name.endswith('.jpeg'):
                os.remove(image_path)

if __name__ == '__main__':
    base = './assets/the_goon_folder'
    icon_folder = f'{base}/icons'
    banner_folder = f'{base}/banners'
    portraits_folder = f'{base}/portraits'
    complete = search_for_missing_banner(
            icon_folder, banner_folder
        ) and search_for_missing_banner(
            icon_folder, portraits_folder, 'portrait')
    
    if complete:
        convert_images_to_jpeg(
            icon_folder,
            aspect_ratio=1, 
            target_size=(255, 255))
        # convert_images_to_jpeg(banner_folder,)
        # convert_images_to_jpeg(portraits_folder, aspect_ratio=9/16, target_size=(720, 1280))

        generate_index(icon_folder, base)
    else:
        print('Please add the missing images before converting them to JPEG.')


