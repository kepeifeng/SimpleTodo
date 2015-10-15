//
//  STTaskCell.h
//  SimpleTodo
//
//  Created by Kent on 10/15/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STTask.h"

@interface STTaskCell : NSTableCellView

//@property (nonatomic, strong) NSTextField * textField;
@property (nonatomic, strong) NSButton * checkBox;
@property (nonatomic, strong) AKView * spliter;
+(CGSize)cellSizeForTask:(STTask * )task width:(CGFloat)width;
@end
