# ssoutliner
Tiny cli app for adding outlines to images (usually screenshots).

Use -r switch to round the corners, as for window screenshots.

# usage
```
usage: ssoutliner [-r] [-o] files...
flags:
  -r, --rounded
      Round the corners. Suitable for window screenshots.
  -o, --overwrite
      Overwrite input file. Otherwise, new file is saved as filename_ssoutlined.png.

Output overwrites input file.
```
