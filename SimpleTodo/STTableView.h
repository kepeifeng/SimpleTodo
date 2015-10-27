//
//  STTableView.h
//  SimpleTodo
//
//  Created by Kent on 10/20/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STTableView;
@protocol STTableViewDelegate <NSObject>
-(void)tableView:(NSTableView *)tableView keyPressed:(NSString *)keys modifierFlags:(NSEventModifierFlags)modifierFlags;


@end
@interface STTableView : NSTableView
@property (nonatomic, weak) id<STTableViewDelegate, NSTableViewDelegate> delegate;
@end
