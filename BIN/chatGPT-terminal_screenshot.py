#!/usr/bin/env python3

import subprocess
import time
from PIL import Image, ImageGrab

# Define the size of the terminal window
terminal_width = 80
terminal_height = 24

# Take a screenshot of the entire screen
im = ImageGrab.grab()

# Crop the screenshot to the size of the terminal window
left = (im.size[0] - terminal_width * 8) // 2
top = (im.size[1] - terminal_height * 16) // 2
right = left + terminal_width * 8
bottom = top + terminal_height * 16
im = im.crop((left, top, right, bottom))

# Save the image to a file
timestamp = time.strftime('%Y-%m-%d_%H-%M-%S')
filename = f'terminal_{timestamp}.png'
im.save(filename)

# Copy the filename to the clipboard
subprocess.run(['xclip', '-selection', 'clipboard'], input=filename.encode())
print(f'Saved screenshot as {filename} and copied filename to clipboard.')
