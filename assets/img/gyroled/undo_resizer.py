import os

# Directory containing the files
directory = "."

# Loop through each file in the directory
for filename in os.listdir(directory):
    # Full path of the file
    filepath = os.path.join(directory, filename)

    # Check if the file is a scaled image and delete it
    if '_scaled.' in filename:
        os.remove(filepath)
        print(f"Deleted scaled file: {filename}")

    # Check if the file is an original image, then rename it
    elif '_original.' in filename:
        original_name = filename.replace('_original', '')
        original_filepath = os.path.join(directory, original_name)
        os.rename(filepath, original_filepath)
        print(f"Renamed {filename} to {original_name}")

    # Check if the file is an .mp4 file and delete it
    elif filename.endswith('.mp4'):
        os.remove(filepath)
        print(f"Deleted MP4 file: {filename}")

print("Undo process complete.")
