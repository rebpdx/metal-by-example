#import "MBEMetalView.h"

@interface MBEMetalView ()
{
    CVDisplayLinkRef _displayLink;
}
-(CVReturn)getFrameForTime:(double)deltaSeconds;
@end

@implementation MBEMetalView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
        self.device = MTLCreateSystemDefaultDevice();
    }
    
    CVDisplayLinkCreateWithCGDisplay(CGMainDisplayID(), &_displayLink);
    CVDisplayLinkSetOutputCallback(_displayLink, &MyDisplayLinkCallback, (__bridge void*)self);
    CVDisplayLinkStart(_displayLink);
    
    return self;
}

- (void)commonInit
{
    self.clearColor = MTLClearColorMake(1, 1, 1, 1);

    self.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
}

static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink,
                                      const CVTimeStamp* now,
                                      const CVTimeStamp* outputTime,
                                      CVOptionFlags flagsIn,
                                      CVOptionFlags* flagsOut,
                                      void* displayLinkContext)
{
    double deltaSeconds = (outputTime->videoTime - now->videoTime) / (double)outputTime->videoTimeScale;
    if (deltaSeconds < 0.0)
        deltaSeconds = 0.0;
    
    return [(__bridge MBEMetalView*)displayLinkContext getFrameForTime:deltaSeconds];
}

- (CVReturn)getFrameForTime:(double)deltaSeconds
{
    _frameDuration = deltaSeconds;
    
    return kCVReturnSuccess;
}

@end
