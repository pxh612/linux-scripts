#!/usr/bin/env python3

import subprocess
from PIL import Image

# Define the name or ID of the window you want to capture
window_name = "INFO WATCHER"

# Get the geometry of the window by its name or ID
xwininfo_output = subprocess.check_output(f'xwininfo -name "{window_name}"', shell=True)
geometry = {}
for line in xwininfo_output.decode().splitlines():
    key, value = line.split(": ")
    geometry[key.strip()] = int(value)

# Calculate the position and size of the window
x = geometry["Absolute upper-left X"]
y = geometry["Absolute upper-left Y"]
width = geometry["Width"]
height = geometry["Height"]

# Take a screenshot of the window
subprocess.run(f'import -window root -crop {width}x{height}+{x}+{y} window_screenshot.png', shell=True)

# Open the screenshot as an image
im = Image.open("window_screenshot.png")

# Save the image to a file
filename = "window_screenshot.png"
im.save(filename)

print(f"Saved screenshot of window '{window_name}' as {filename}.")
