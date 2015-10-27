//
//  AppDelegate.m
//  SimpleTodo
//
//  Created by Kent on 10/13/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()<NSPopoverDelegate>

@end

@implementation AppDelegate{

    NSStatusItem * _statusItem;
    NSPopover * _popOver;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    _statusItem.title = @"Yo!";
    _statusItem.target = self;
    _statusItem.action = @selector(statusItemClicked:);

    NSLog(@"applicationDidFinishLaunching");
    
}

-(void)statusItemClicked:(NSStatusBarButton *)sender{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_popOver) {
            
            _popOver = [[NSPopover alloc] init];
            _popOver.behavior = NSPopoverBehaviorTransient;//close when user clicked out of the window
            MainViewController * viewController = [[MainViewController alloc] init];
            _popOver.contentViewController = viewController;
            _popOver.delegate = self;
            _popOver.animates = NO;
            //        _popOver.contentSize = CGSizeMake(400, 400);
            
            
            
            
        }
        
        if(_popOver.shown){
            
            [_popOver close];
            
        }else{
            
            [[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
            [_popOver showRelativeToRect:sender.bounds ofView:sender preferredEdge:(NSRectEdgeMinY)];
            
            
//            BOOL becomeFirstResponder = [_popOver becomeFirstResponder];
//            NSLog(@"becomeFirstResponder:%@",(becomeFirstResponder)?@"YES":@"NO");
            //        CGFloat padding = 10;
            //        _popOver.contentViewController.view.frame = NSMakeRect(padding, padding, _popOver.contentSize.width - padding * 2, _popOver.contentSize.height - padding * 2);
            
        }
//    });

        
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - Pop Over Delegate
-(void)popoverDidShow:(NSNotification *)notification{

    [_popOver becomeFirstResponder];
}

@end
