//
//  AKView.m
//  SimpleTodo
//
//  Created by Kent on 10/15/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import "AKView.h"

@implementation AKView

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:

    
    if(self.backgroundColor){
        [self.backgroundColor setFill];
        NSRectFill(dirtyRect);
    }
    
    [super drawRect:dirtyRect];

}

-(BOOL)isFlipped{
    return YES;
}
@end
