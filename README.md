# Metal by Example

This repository holds the sample code for the book _Metal by Example_ by Warren Moore.

### Converting to macOS App

This fork of the repo converts the code to work as macOS applications with NSViews.

#### Navigating the differences
Differences for converting to macOS applications have single commits for each
chapter so that you can diff them in GitHub.

 - [04-DrawingIn3D](https://github.com/rebpdx/metal-by-example/commit/aaf2526)

#### Notable changes so far

##### Metal Specific changes

1. Vertex Uniforms in the shader was changed from constant to device, this was
due to the constant address space specifications which align the offset to 256
bytes in macOS. [setVertexBuffer Documentation](https://developer.apple.com/documentation/metal/mtlrendercommandencoder/1515829-setvertexbuffer)

2. Setting the texture storage mode to `MTLStorageModePrivate` because it seems
the macOS version is a little less lenient on the memory management throwing an
error saying it must be allocated with `MTLResourceStorageModePrivate`. Since in
at least example 04 the texture is only accessed in the GPU we'll follow the
guidelines and override the default of `MTLStorageModeManaged` to avoid errors.
[Metal Best Practices Guide](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/MTLBestPracticesGuide/ResourceOptions.html)

##### NSView and Application Related

 1. MBERenderer interface makes use of MTKViewDelegate, this reduces the usage
 of the MBEMetalView but gives the advantage of utilizing the mtkView
 drawableSizeWillChange such that the macOS application window can be dynamically
 resized. Downside is that RenderPassDescriptor and depthTexture setup have been
 moved to the MBERenderer to achieve this.

 2. CADisplayLink doesn't exist in macOS but CVDisplayLink can be used to sync
 the timing of the redraw with the display. Since you could have multiple
 displays and determining the monitor the application windows was on seems
 overkill for owning one monitor this assumes you're running these examples on
 the main display with `CGMainDisplayID()`.
