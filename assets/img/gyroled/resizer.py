import os
import subprocess

# Directory containing the files
directory = "."

# Ensure the scaled directory exists
scaled_directory = os.path.join(directory, 'scaled')
if not os.path.exists(scaled_directory):
    os.makedirs(scaled_directory)

# Loop through each file in the directory
for filename in os.listdir(directory):
    # Full path of the file
    filepath = os.path.join(directory, filename)

    # Check if the file is an image (jpg or png)
    if filename.endswith(('.jpg', '.png')):
        # Prepare the scaled file path
        scaled_filepath = os.path.join(scaled_directory, filename)

        # Use ffmpeg to scale the image and compress it
        subprocess.run(['ffmpeg', '-y', '-i', filepath, '-vf', 'scale=-2:1080', '-compression_level', '10', scaled_filepath])

    # Check if the file is a .mov file
    elif filename.endswith('.mov'):
        # Prepare the new .mp4 filename in the scaled directory
        mp4_filepath = os.path.join(scaled_directory, filename.split('.')[0] + '_h264.mp4')

        # Convert .mov to .mp4 using H.264, ensure width is divisible by 2, scale it, and apply compression
        subprocess.run(['ffmpeg', '-y', '-i', filepath, '-vf', 'scale=-2:1080', '-c:v', 'libx264', '-crf', '23', mp4_filepath])

print("Processing complete.")
