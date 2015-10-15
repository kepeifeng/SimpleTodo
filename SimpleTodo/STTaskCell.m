//
//  STTaskCell.m
//  SimpleTodo
//
//  Created by Kent on 10/15/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import "STTaskCell.h"
#define FONT [NSFont systemFontOfSize:14]

@implementation STTaskCell{

    NSTextField * _textField;
}

-(instancetype)initWithCoder:(NSCoder *)coder{

    self = [super initWithCoder:coder];
    if (self) {
        [self initialSetup];
    }
    return self;
}
-(instancetype)initWithFrame:(NSRect)frameRect{

    self = [super initWithFrame:frameRect];
    if (self) {
        [self initialSetup];
    }
    return self;
}

-(void)initialSetup{

//    CGRect bounds = self.bounds;
    CGRect frame = CGRectMake(5, 5, CGRectGetWidth(self.bounds) - 10 - 20, CGRectGetHeight(self.bounds) - 10);
    _textField = [[NSTextField alloc] initWithFrame:frame];
    _textField.bordered = NO;
    _textField.bezeled = NO;
    _textField.editable = NO;
    _textField.cell.wraps = YES;
    _textField.cell.lineBreakMode = NSLineBreakByCharWrapping;
    _textField.font = FONT;
    _textField.textColor = [NSColor blackColor];
    _textField.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_textField];
    self.textField = _textField;
    
    _checkBox = [[NSButton alloc] initWithFrame:(NSMakeRect(CGRectGetWidth(self.bounds) - 20, (CGRectGetHeight(self.bounds) - 20)/2, 20,20))];
    [(NSButtonCell *)_checkBox.cell setButtonType:(NSSwitchButton)];
    _checkBox.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin | NSViewMaxYMargin;
    [self addSubview:_checkBox];
    

    _spliter = [[AKView alloc] initWithFrame:(NSMakeRect(0, CGRectGetHeight(self.bounds) - 1, CGRectGetWidth(self.bounds), 1))];
    _spliter.backgroundColor = [NSColor colorWithWhite:0.9 alpha:1];
    _spliter.autoresizingMask = NSViewMinYMargin | NSViewWidthSizable;
    [self addSubview:_spliter];

}




+(CGSize)cellSizeForTask:(STTask * )task width:(CGFloat)width{
    
    NSString * text = task.title;
    CGRect rect = [text boundingRectWithSize:NSMakeSize(width  - 10 - 20, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: FONT}];
    
    rect.size.height += 10;
    return rect.size;
    
}

@end
