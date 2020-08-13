# outline-image
Tiny CLI macOS app for adding outlines to images (usually screenshots). Outlines can have hard or rounded corners. By default, it will output the outlined image to a separate file, but can optionally overwrite the original instead.

# installation

Copy `outline-image` into a folder in your `$PATH`. I put mine in `/usr/local/bin/`.

Eventually, I'll get around to adding a [Homebrew](https://brew.sh) recipe.

# usage
```
USAGE: outline-image <file-path> [--radius <px>] --mask <mask> [--width <px>] [--overwrite]

ARGUMENTS:
  <file-path>             Image file to which the outline will be applied 
        The file should be in one of the standard macOS image formats including
        TIFF, JPEG, GIF, PNG, and PDF.

OPTIONS:
  -r, --radius <px>       The radius of the circle which will be used to
                          inscribe the corner which is rounded. (default: 0)
        This argument is ignored if no corners have been selected for rounding
        in the mask.
  -m, --mask <mask>       A four-digit boolean mask, such as 0011, to specify
                          which corners should be rounded. 
        The first digit represents the top-left corner and the remaining digits
        represent the next three corners, moving clockwise around the rectangle.
  -w, --width <px>        The width, in pixels, of the outline to draw.
                          (default: 1)
  -o, --overwrite         If enabled, the source file will be replaced with the
                          tool's output. Otherwise, the tool will output the
                          new image at ./<InputFileName>_outlined.png. 
  -h, --help              Show help information.
```


# samples

![Screenshot Without Outline](docs/Screenshot.png)
![Screenshot With Top Corners Rounded With Outline](docs/Screenshot_outlined.png)
