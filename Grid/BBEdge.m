//
//  BBEdge.m
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "BBEdge.h"

@implementation BBEdge

+ (instancetype)edgeWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side {
    BBEdge *edge = [[BBEdge alloc] initWithColumn:column andRow:row andSide:side];
    return edge;
}

+ (NSString *)keyForEdgeWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side {
    return [NSString stringWithFormat:@"Edge::%ld::%ld::%@", column, row, side];
}

- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
        _side = side;
    }
    return self;
}

- (NSString *)key {
    return [NSString stringWithFormat:@"Edge::%ld::%ld::%@", self.column, self.row, self.side];
}

@end
