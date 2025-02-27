#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTabView *tabView;
@property (strong) NSTextField *resumePatternField;
@property (strong) NSTextView *outputView;
@property (strong) NSImageView *imageView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect frame = NSMakeRect(100, 100, 400, 300);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                              styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable)
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    [self.window setTitle:@"Flipent Legacy"];

    self.tabView = [[NSTabView alloc] initWithFrame:NSMakeRect(10, 10, 380, 280)];

    NSTabViewItem *scanTab = [[NSTabViewItem alloc] initWithIdentifier:@"ScanCard"];
    [scanTab setLabel:@"Scan Card"];
    self.imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(20, 20, 340, 200)];
    [scanTab setView:self.imageView];

    NSTabViewItem *inputTab = [[NSTabViewItem alloc] initWithIdentifier:@"InputBits"];
    [inputTab setLabel:@"Input Bits"];
    self.resumePatternField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 200, 340, 24)];
    self.outputView = [[NSTextView alloc] initWithFrame:NSMakeRect(20, 50, 340, 140)];
    [inputTab setView:self.resumePatternField];

    NSTabViewItem *aboutTab = [[NSTabViewItem alloc] initWithIdentifier:@"About"];
    [aboutTab setLabel:@"About"];
    NSTextView *aboutView = [[NSTextView alloc] initWithFrame:NSMakeRect(20, 50, 340, 200)];
    [aboutView setString:@"Flipent Legacy - A tool for MCO Punch Cards"];
    [aboutTab setView:aboutView];

    [self.tabView addTabViewItem:scanTab];
    [self.tabView addTabViewItem:inputTab];
    [self.tabView addTabViewItem:aboutTab];

    [[self.window contentView] addSubview:self.tabView];
    [self.window makeKeyAndOrderFront:nil];
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate];
        [app run];
    }
    return 0;
}
