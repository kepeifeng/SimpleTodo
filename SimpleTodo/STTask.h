//
//  STTask.h
//  SimpleTodo
//
//  Created by Kent on 10/15/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTask : NSObject<NSCoding>
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSDate * updateDate;
@property (nonatomic) BOOL done;
@end
