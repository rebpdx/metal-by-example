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
    _scale = 1.0;

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

- (BOOL) acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (void)mouseDown:(NSEvent *) event {
    _lastDragLocation = [[self superview] convertPoint:[event locationInWindow] fromView:nil];
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint newDragLocation = [[self superview] convertPoint:[event locationInWindow] fromView:nil];
    NSPoint thisRotation = _rotation;
    thisRotation.x += (-_lastDragLocation.x + newDragLocation.x);
    thisRotation.y += (-_lastDragLocation.y + newDragLocation.y);
    _rotation = thisRotation;
    _lastDragLocation = newDragLocation;
}

- (void)scrollWheel:(NSEvent *)event {
    CGFloat scaleDelta = [event scrollingDeltaY];
    _scale = MAX((CGFloat) 0.0, (scaleDelta / 10) + _scale);
}

@end
