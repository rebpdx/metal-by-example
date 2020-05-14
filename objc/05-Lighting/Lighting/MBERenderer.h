#import "MBEMetalView.h"

@interface MBERenderer : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MBEMetalView *) mtkView;

@end
