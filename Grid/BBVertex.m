//
//  BBVertex.m
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "BBVertex.h"

@implementation BBVertex

+ (instancetype)vertexWithColumns:(NSInteger)column andRow:(NSInteger)row {
    return [[BBVertex alloc] initWithColumn:column andRow:row];
}

- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
    }
    return self;
}

- (NSString *)key {
    return [NSString stringWithFormat:@"Face::%ld::%ld", self.column, self.row];
}

@end
