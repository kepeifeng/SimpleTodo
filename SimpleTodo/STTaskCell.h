//
//  STTaskCell.h
//  SimpleTodo
//
//  Created by Kent on 10/15/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STTask.h"

@interface STTaskCell : AKView

@property (nonatomic, strong) NSTextField * textField;
@property (nonatomic, strong) NSButton * checkBox;
@property (nonatomic, strong) AKView * spliter;
@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, assign, getter=isActived) BOOL actived;

+(CGSize)cellSizeForTask:(STTask * )task width:(CGFloat)width;
@end
