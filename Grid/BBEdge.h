//
//  BBEdge.h
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBEdge : NSObject

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;
@property (copy, nonatomic) NSString *side;

@property (assign, nonatomic) BOOL isSolid;

+ (instancetype)edgeWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side;
- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side;

@end
