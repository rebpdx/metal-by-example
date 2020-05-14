#import "MBEMetalView.h"
@import Metal;

@interface MBEMetalView ()
@property (readonly) id<MTLDevice> device;
@end

@implementation MBEMetalView

@synthesize device=device;

+ (Class)layerClass
{
    return [CAMetalLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        device = MTLCreateSystemDefaultDevice();
        self.metalLayer.device = device;
        self.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    }

    return self;
}

- (CAMetalLayer *)metalLayer {
    return (CAMetalLayer *)self.layer;
}

- (void)draw
{
    [self redraw];
}

- (void)redraw
{
    id<CAMetalDrawable> drawable = [self.metalLayer nextDrawable];
    id<MTLTexture> texture = drawable.texture;

    MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    passDescriptor.colorAttachments[0].texture = texture;
    passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1);

    id<MTLCommandQueue> commandQueue = [self.device newCommandQueue];

    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];

    id <MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
    [commandEncoder endEncoding];

    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];

}

@end
