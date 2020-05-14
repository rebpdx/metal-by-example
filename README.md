# Metal by Example

This repository holds the sample code for the book _Metal by Example_ by Warren Moore.

### Converting to macOS App

This fork of the repo converts the code to work as macOS applications with NSViews.
Since Swift and iOS development is more popular it's difficult to come by
Objective-C and Metal resources so maybe this information will be helpful for
someone looking for something similar.

I had considered making the conversion dual iOS/macOS support such that they
coexisted in the same project and shared code but due to some changes that were
made it seemed that this type of conversion and the ability to diff the changes
in GitHub would be easier for reference material purposes.

#### Navigating the differences
Differences for converting to macOS applications have single commits for each
chapter so that you can diff them in GitHub. If you've already read the material
or want to better understand some of the differences between iOS and macOS
development.

 - [02-ClearScreen](https://github.com/rebpdx/metal-by-example/commit/d00928a)
 - [03-DrawingIn2D](https://github.com/rebpdx/metal-by-example/commit/6d09b0e)
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

##### NSView, MTKViews and Application related changes

 1. I suspect MTKView is newer than the book literature as this was found by
 looking at the examples and documentation on the Apple Developer site and appears
 to have UIView support as well as MTKView. In this conversion MBERenderer
 interface makes use of MTKViewDelegate, this reduces the usage of the
 MBEMetalView but gives the advantage of utilizing the MTKView
 drawableSizeWillChange such that the macOS application window can be dynamically
 resized. Downside is that RenderPassDescriptor and depthTexture setup have been
 moved to the MBERenderer to achieve this.

 2. CADisplayLink doesn't exist in macOS but CVDisplayLink can be used to sync
 the timing of the redraw with the display. Since you could have multiple
 displays and determining the monitor the application windows was on seems
 overkill for owning one monitor this assumes you're running these examples on
 the main display with `CGMainDisplayID()`.
