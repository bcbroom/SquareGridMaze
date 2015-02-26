//
//  BBEdge.h
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBSquareGrid;

@interface BBEdge : NSObject

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;
@property (copy, nonatomic) NSString *side;

@property (weak, nonatomic) BBSquareGrid *grid;

@property (assign, nonatomic) BOOL isWall;

+ (instancetype)edgeWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side;
+ (NSString *)keyForEdgeWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side;

- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side;
- (NSString *)key;

@end
