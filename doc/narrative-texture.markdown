Title: Narrative Description of "texture" Demo

This is a simple narrative description of the `texture` application included
with the Lumen library as a demo.

The `texture` demo accepts one command-line parameter, which is the name of an
image in BMP format, or netpbm's portable bitmap, portable greymap, or
portable pixmap format (PBM, PGM, or PPM).  Yes yes, we'll be adding more
formats shortly.  One BMP and one PPM image are included in the `data`
directory for you to use with this demo.  You can convert other images to BMP
or PPM format using any of a number of free tools, like the netpbm toolkit,
GIMP, or ImageMagick.  You invoke `texture` by typing its name followed by an
image name, like `./texture ../data/ppm-test-8.ppm` if you're sitting in the
`bin` directory, or `bin/texture data/bmp-test-1.bmp` if you're in the `lumen`
directory.  When run, `texture` creates a window the same size as your image,
so for best results, use images that are smaller than your screen.  (The
actual image is displayed on a rectangle that's smaller, so it has room to
rotate.)

The window should have a light grey background with a slowly rotating
rectangle in it which has your image mapped on it.  It should complete one
full rotation every 15 seconds, since it advances the rotation one degree
every frame, and should run at 24 frames per second.  Terminate it by pressing
any key, or closing the window.

Incidentally, the image included in the demo directory named `ppm-test-8.ppm`,
is a public-domain photo of the Aurora Borealis, also known as the Northern
Lights.  It was taken in 2005 near Eielson Air Force Base, Alaska by Senior
Airman Joshua Strang of the United States Air Force.  The `bmp-test-1.ppm`
image is a public-domain raytraced image from Wikimedia Commons.

The `texture` demo is an enhancement of the [`spinner`][spinner] demo, mainly
intended to show how to use the `Lumen.Image` package.  It's getting closer to
what a real Lumen app might typically look like, though it's still very basic.

Like in `spinner`, creating a double-buffered rendering context (by allowing
the default `Animated => True` in [`Lumen.Window.Create`][window]) is actually
necessary here in order to get smooth animation.  And as with all d-b
contexts, we call [`Lumen.Window.Swap`][window] after we've finished our
scene, so as to sort of "publish" it to the user.

Event-wise, `texture` is just the same as `spinner`, using
[`Lumen.Events.Animate.Select_Event`][animate] for its event loop.

Much of the rest of the app is similar to `spinner`, with a few additions and
alterations.  First, instead of drawing a shaded square, it uses OpenGL's
texturing facility to draw a rectangle with the selected image drawn on it.
Second, it sets up a real 3D frustum instead of using the much simpler 2D
orthographic projection used by all previous demos.  Third, now that it has
real 3D space to move in, it rotates the square along two axes instead of just
one.

[spinner]:    narrative-spinner.html
[window]:     narrative-lumen-misc.html#lumen-window
[events]:     narrative-lumen-events.html#lumen-events
[animate]:    narrative-lumen-events.html#lumen-events-animate
