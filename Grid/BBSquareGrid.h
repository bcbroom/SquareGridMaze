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
    BBSquareGridDirectionWest
};

typedef NS_ENUM(NSInteger, BBSquareGridDiagonalDirection) {
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
- (BBVertex *)cornerForFace:(BBFace *)face inDirection:(BBSquareGridDiagonalDirection)direction;

- (NSArray *)neighborsForFace:(BBFace *)face;
- (NSArray *)connectedFacesForFace:(BBFace *)face;
- (NSArray *)bordersForFace:(BBFace *)face;
- (NSArray *)cornersForFace:(BBFace *)face;

// edge connections
- (BBFace *)faceJoinedByEdge:(BBEdge *)edge inDirection:(BBSquareGridDirection)direction;
- (BBEdge *)edgeContinuingEdge:(BBEdge *)edge inDirection:(BBSquareGridDirection)direction;
- (BBVertex *)endpointForEdge:(BBEdge *)edge inDirection:(BBSquareGridDirection)direction;

- (NSArray *)facesJoinedByEdge:(BBEdge *)edge;
- (NSArray *)edgesContinuingEdge:(BBEdge *)edge;
- (NSArray *)endpointsForEdge:(BBEdge *)edge;

// vertex connections
- (BBFace *)faceTouchesVertex:(BBVertex *)vertex inDirection:(BBSquareGridDiagonalDirection)direction;
- (BBEdge *)edgeProtrudesFromVertex:(BBVertex *)vertex inDirection:(BBSquareGridDirection)direction;
- (BBVertex *)vertexAdjacentToVertex:(BBVertex *)vertex inDirection:(BBSquareGridDirection)direction;

- (NSArray *)facesTouchingVertex:(BBVertex *)vertex;
- (NSArray *)edgesProtrudingFromVertex:(BBVertex *)vertex;
- (NSArray *)verticesAdjacentToVertex:(BBVertex *)vertex;

// intended object store
- (void)setFace:(BBFace *)face forObject:(id)obj;
- (BBFace *)faceForObject:(id)obj;
- (void)removeFaceForObject:(id)obj;
- (NSArray *)allObjectsInGrid;
- (NSArray *)allFacesInGrid;

// working object store
//- (void)setFace:(BBFace *)face forString:(NSString *)key;
//- (BBFace *)faceForString:(NSString *)key;
//- (void)removeFaceForString:(NSString *)key;

// internal methods, listed here for testing
- (BBFace *)faceForKey:(NSString *)key;


@end
