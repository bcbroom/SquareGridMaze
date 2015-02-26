//
//  BBGrid.h
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBFace.h"
#import "BBEdge.h"
#import "BBVertex.h"

typedef NS_ENUM(NSInteger, BBSquareGridDirection) {
    BBSquareGridDirectionNorth,
    BBSquareGridDirectionEast,
    BBSquareGridDirectionSouth,
    BBSquareGridDirectionWest,
    BBSquareGridDirectionNorthEast,
    BBSquareGridDirectionSouthEast,
    BBSquareGridDirectionSouthWest,
    BBSquareGridDirectionNorthWest
};

@interface BBSquareGrid : NSObject

@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger width;

- (instancetype)initWithWidth:(NSInteger)width andHeight:(NSInteger)height;

- (NSArray *)allFaces;
- (NSArray *)allEdges;
- (NSArray *)allVertices;

- (BBFace *)faceForColumn:(NSInteger)column andRow:(NSInteger)row;
- (BBEdge *)edgeForColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side;
- (BBVertex *)vertexForColumn:(NSInteger)column andRow:(NSInteger)row;

// face connections
- (BBFace *)neighborForFace:(BBFace *)face inDirection:(BBSquareGridDirection)direction;
- (BBEdge *)borderForFace:(BBFace *)face inDirection:(BBSquareGridDirection)direction;

// intended object store
- (void)setFace:(BBFace *)face forObject:(id)obj;
- (BBFace *)faceForObject:(id)obj;

// working object store
- (void)setFace:(BBFace *)face forString:(NSString *)key;
- (BBFace *)faceForString:(NSString *)key;
- (void)removeFaceForString:(NSString *)key;

// internal methods, listed here for testing
- (BBFace *)faceForKey:(NSString *)key;
//- (NSString *)keyForFaceWithColumn:(NSInteger)column andRow:(NSInteger)row;
//- (NSString *)keyForEdgeWithColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side;
//- (NSString *)keyForVertexWithColumn:(NSInteger)column andRow:(NSInteger)row;

@end
