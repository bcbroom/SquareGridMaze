//
//  BBFace.m
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//
#import "BBSquareGrid.h"
#import "BBFace.h"

@interface BBFace ()



@end

@implementation BBFace

+ (instancetype)edgeWithColumn:(NSInteger)column andRow:(NSInteger)row {
    BBFace *face = [[BBFace alloc] initWithColumn:column andRow:row];
    return face;
}

+ (NSString *)keyForFaceWithColumn:(NSInteger)column andRow:(NSInteger)row {
    return [NSString stringWithFormat:@"Face::%ld::%ld", column, row];
}

- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
        
        _neighbors = [NSMutableArray new];
        _edges = [NSMutableArray new];
        _vertices = [NSMutableArray new];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithColumn:0 andRow:0];
    if (self) {
        
    }
    return self;
}

- (NSString *)key {
    return [BBFace keyForFaceWithColumn:self.column andRow:self.row];
}

@end
