@import MetalKit;

@protocol MBEMetalViewDelegate;

@interface MBEMetalView : MTKView

/// The Metal layer that backs this view
@property (nonatomic, readonly) CAMetalLayer *metalLayer;

/// The desired pixel format of the color attachment
@property (nonatomic) MTLPixelFormat colorPixelFormat;

/// The color to which the color attachment should be cleared at the start of
/// a rendering pass
@property (nonatomic, assign) MTLClearColor clearColor;

/// The duration (in seconds) of the previous frame. This is valid only in the context
/// of a callback to the delegate's -drawInView: method.
@property (nonatomic, readonly) double frameDuration;

@end
