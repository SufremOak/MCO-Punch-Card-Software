/*
   Project: MCO Flipent

   Copyright (C) 2025 Free Software Foundation

   Author: miguel,,,

   Created: 2025-02-27 18:24:02 -0300 by miguel

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface FlipentApp : NSObject <NSApplicationDelegate>
@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) NSTabView *tabView;
@property (strong, nonatomic) NSTextField *inputField;
@property (strong, nonatomic) NSTextView *outputView;
@end

@implementation FlipentApp

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 400)
                                              styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable)
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    [self.window setTitle:@"Flipent UI"];
    [self.window center];

    self.tabView = [[NSTabView alloc] initWithFrame:NSMakeRect(10, 10, 480, 380)];

    NSTabViewItem *scanTab = [[NSTabViewItem alloc] initWithIdentifier:@"Scan Card"];
    scanTab.label = @"Scan Card";
    scanTab.view = [self createScanCardView];

    NSTabViewItem *inputTab = [[NSTabViewItem alloc] initWithIdentifier:@"Input Bits"];
    inputTab.label = @"Input Bits";
    inputTab.view = [self createInputBitsView];

    NSTabViewItem *aboutTab = [[NSTabViewItem alloc] initWithIdentifier:@"About"];
    aboutTab.label = @"About";
    aboutTab.view = [self createAboutView];

    [self.tabView addTabViewItem:scanTab];
    [self.tabView addTabViewItem:inputTab];
    [self.tabView addTabViewItem:aboutTab];

    [self.window.contentView addSubview:self.tabView];
    [self.window makeKeyAndOrderFront:nil];
}

- (NSView *)createScanCardView {
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 480, 350)];
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 200, 440, 24)];
    [label setStringValue:@"Scan feature is not available on GNUstep."];
    [label setEditable:NO];
    [label setBordered:NO];
    [label setBackgroundColor:[NSColor clearColor]];
    [view addSubview:label];
    return view;
}

- (NSView *)createInputBitsView {
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 480, 350)];

    self.inputField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 300, 300, 24)];
    [view addSubview:self.inputField];

    NSButton *parseButton = [[NSButton alloc] initWithFrame:NSMakeRect(340, 300, 100, 24)];
    [parseButton setTitle:@"Parse"];
    [parseButton setTarget:self];
    [parseButton setAction:@selector(parsePattern)];
    [view addSubview:parseButton];

    self.outputView = [[NSTextView alloc] initWithFrame:NSMakeRect(20, 20, 440, 260)];
    [self.outputView setEditable:NO];
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(20, 20, 440, 260)];
    [scrollView setDocumentView:self.outputView];
    [scrollView setHasVerticalScroller:YES];
    [view addSubview:scrollView];

    return view;
}

- (void)parsePattern {
    NSString *pattern = [self.inputField stringValue];
    NSString *parsedOutput = [NSString stringWithFormat:@"Parsed: %@", pattern];
    [self.outputView setString:parsedOutput];
}

- (NSView *)createAboutView {
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 480, 350)];
    NSTextField *aboutLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 200, 440, 24)];
    [aboutLabel setStringValue:@"Flipent UI - A tool for MCO Punch Cards"];
    [aboutLabel setEditable:NO];
    [aboutLabel setBordered:NO];
    [aboutLabel setBackgroundColor:[NSColor clearColor]];
    [view addSubview:aboutLabel];
    return view;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        FlipentApp *delegate = [[FlipentApp alloc] init];
        [app setDelegate:delegate];
        [app run];
    }
    return 0;
}


// add your C++ methods here
