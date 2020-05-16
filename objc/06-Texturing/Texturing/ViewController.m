#import "ViewController.h"
#import "MBEMetalView.h"

@interface ViewController ()
@property (nonatomic, strong) MBERenderer *renderer;
@end

@implementation ViewController
{
    MBEMetalView* _view;
    MBERenderer *_renderer;
};

- (MBEMetalView *)metalView {
    return (MBEMetalView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize the view
    _view = (MBEMetalView *)self.view;

    // Initialize the renderer
    self.renderer = [[MBERenderer alloc] initWithMetalKitView:_view];

    // Initialize our renderer with the view size
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _renderer;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
