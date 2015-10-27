//
//  STTableView.m
//  SimpleTodo
//
//  Created by Kent on 10/20/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import "STTableView.h"

@implementation STTableView
@dynamic delegate;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)keyDown:(NSEvent *)theEvent{

//    unichar key = [[theEvent characters]  characterAtIndex:0];
    if ([self.delegate respondsToSelector:@selector(tableView:keyPressed:modifierFlags:)]) {
        [self.delegate tableView:self keyPressed:[theEvent charactersIgnoringModifiers] modifierFlags:theEvent.modifierFlags];
    }

}

@end
