import os
import subprocess

# Directory containing the files
directory = "."

# Ensure the scaled directory exists
scaled_directory = os.path.join(directory, 'scaled')
if not os.path.exists(scaled_directory):
    os.makedirs(scaled_directory)

def determine_rotation(file_path):
    """ Determine if a video needs to be rotated based on its metadata """
    cmd = ['ffprobe', '-v', 'error', '-select_streams', 'v:0',
           '-show_entries', 'stream_tags=rotate', '-of', 'default=noprint_wrappers=1:nokey=1', file_path]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    rotate = result.stdout.strip()
    return rotate

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
        # Determine rotation
        rotation = determine_rotation(filepath)
        video_filter = 'scale=-2:1080'

        # Adjust video filter for rotation if needed
        if rotation == '90':
            video_filter = 'transpose=1,' + video_filter
        elif rotation == '180':
            video_filter = 'transpose=2,' + video_filter
        elif rotation == '270':
            video_filter = 'transpose=2,transpose=2,' + video_filter

        # Prepare the new .mp3 filename in the scaled directory
        mp4_filepath = os.path.join(scaled_directory, filename.split('.')[0] + '.mp4')

        # Use ffmpeg to convert .mov to .mp4, scale it, and apply compression
        subprocess.run(['ffmpeg', '-y', '-i', filepath, '-vf', video_filter, '-c:v', 'libx264', '-crf', '23', mp4_filepath])

print("Processing complete.")
