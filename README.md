## Usage

Execute ./ decompressor.sh <name_of_the_file_to_decompress>

## Behavior

When executed, the script creates an output directory (named `<input_filename>_extracted` by default) and places all extracted files inside it. For each decompression operation the script prints to the console the start time, end time, and elapsed time, allowing the user to track how long each layer of nested extraction took. A summary of total elapsed time is printed when the process completes. Optionally, the script can write the same timing details to a log file.

## Credits

[S4vitar](https://github.com/s4vitar)
