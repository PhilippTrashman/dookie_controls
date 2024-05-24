from PIL import Image
import os

def convert_png_to_ico(png_path, ico_path):
    img = Image.open(png_path)
    width, height = img.size
    new_size = max(width, height)
    new_img = Image.new('RGBA', (new_size, new_size), (0, 0, 0, 0))
    left = (new_size - width) // 2
    top = (new_size - height) // 2
    new_img.paste(img, (left, top))
    new_img.save(ico_path)

def get_current_file_location():
    return os.path.dirname(os.path.abspath(__file__))

if __name__ == '__main__':
    png_path = os.path.join(get_current_file_location(), 'icon.png')
    ico_path = os.path.join(get_current_file_location(), 'icon.ico')
    convert_png_to_ico(png_path, ico_path)
    print('PNG to ICO conversion complete')