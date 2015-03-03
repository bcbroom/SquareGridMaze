//
//  BBGrid.m
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "BBSquareGrid.h"
#import "BBFace.h"
#import "BBEdge.h"
#import "BBVertex.h"

@interface BBSquareGrid ()

@property (strong, nonatomic) NSMutableDictionary *faces;
@property (strong, nonatomic) NSMutableDictionary *edges;
@property (strong, nonatomic) NSMutableDictionary *vertices;
//@property (strong, nonatomic) NSMutableDictionary *locationsForObjects;
@property (strong, nonatomic) NSMapTable *facesForObject;

@end

@implementation BBSquareGrid

- (instancetype)init {
    return [self initWithWidth:3 andHeight:4];
}

- (instancetype)initWithWidth:(NSInteger)width andHeight:(NSInteger)height {
    self = [super init];
    if (self) {
        _height = height;
        _width = width;
        
        [self buildDataStructures];
        
        [self addFaces];
        [self buildFaceConnections];
        
        [self addEdges];
        [self buildEdgeConnections];
        
        [self addVertices];
        [self buildVertexConnections];
    }
    return self;
}

- (void)buildDataStructures {
    _faces = [NSMutableDictionary new];
    
    _edges = [NSMutableDictionary new];
    
    _vertices = [NSMutableDictionary new];
    
    //_locationsForObjects = [NSMutableDictionary new];
    self.facesForObject = [NSMapTable strongToStrongObjectsMapTable];
}

#pragma mark Faces

- (void)addFaces {
    for (NSInteger i = 0; i < self.width ; i++) {
        for (NSInteger j = 0; j < self.height; j++) {
            BBFace *face = [[BBFace alloc] initWithColumn:i andRow:j];
            face.grid = self;
            [self.faces setObject:face forKey:face.key];
        }
    }
}

- (void)buildFaceConnections {
    for (NSInteger i = 0; i < self.width ; i++) {
        for (NSInteger j = 0; j < self.height; j++) {
            BBFace *face = [self faceForColumn:i andRow:j];
            
            if (i > 0) {
                face.westFace = [self faceForColumn:(i-1) andRow:j];
                [face.neighbors addObject:face.westFace];
            }
            
            if (j > 0) {
                face.southFace = [self faceForColumn:i andRow:(j-1)];
                [face.neighbors addObject:face.southFace];
            }
            
            if (j < self.height - 1) {
                face.northFace = [self faceForColumn:i andRow:(j+1)];
                [face.neighbors addObject:face.northFace];
            }
            
            if (i < self.width - 1) {
                face.eastFace = [self faceForColumn:(i+1) andRow:j];
                [face.neighbors addObject:face.eastFace];
            }
        }
    }
}

- (BBFace *)faceForColumn:(NSInteger)column andRow:(NSInteger)row {
    if (column >= self.width) {
        return nil;
    }
    
    if (row >= self.height) {
        return nil;
    }
    
    if (row < 0 || column < 0) {
        return nil;
    }
    
    return [self.faces objectForKey:[BBFace keyForFaceWithColumn:column andRow:row]];
}

- (NSArray *)allFaces {
    return [self.faces allValues];
}

#pragma mark Edges

- (void)addEdges {
    for (int i = 0; i < _width; i++) {
        for (int j = 0; j < _height; j++) {
            BBEdge *sEdge = [BBEdge edgeWithColumn:i andRow:j andSide:@"S"];
            sEdge.grid = self;
            [self.edges setObject:sEdge forKey:sEdge.key];
            
            BBEdge *wEdge = [BBEdge edgeWithColumn:i andRow:j andSide:@"W"];
            wEdge.grid = self;
            [self.edges setObject:wEdge forKey:wEdge.key];
        }
    }
    
    // add top edges, which are S edges for the face just beyond grid edge
    for (int i = 0; i < _width; i++) {
        BBEdge *topEdge = [BBEdge edgeWithColumn:i andRow:_height andSide:@"S"];
        topEdge.grid = self;
        [self.edges setObject:topEdge forKey:topEdge.key];
    }
    
    // add right edges, similarly, but these are W edges
    for (int j = 0; j < _height; j++) {
        BBEdge *rightEdge = [BBEdge edgeWithColumn:_width andRow:j andSide:@"W"];
        rightEdge.grid = self;
        [self.edges setObject:rightEdge forKey:rightEdge.key];
    }
}

- (void)buildEdgeConnections {
    for (BBFace *face in [self allFaces]) {
        face.westEdge = [self edgeForColumn:face.column andRow:face.row andSide:@"W"];
        face.southEdge = [self edgeForColumn:face.column andRow:face.row andSide:@"S"];
        face.eastEdge = [self edgeForColumn:face.column+1 andRow:face.row andSide:@"W"];
        face.northEdge = [self edgeForColumn:face.column andRow:face.row+1 andSide:@"S"];
        
        [face.edges addObjectsFromArray:@[face.westEdge, face.southEdge, face.eastEdge, face.northEdge]];
    }
}

- (BBEdge *)edgeForColumn:(NSInteger)column andRow:(NSInteger)row andSide:(NSString *)side {
    return [self.edges objectForKey:[BBEdge keyForEdgeWithColumn:column andRow:row andSide:side]];
}

- (NSArray *)allEdges {
    return [self.edges allValues];
}

#pragma mark Vertices

- (void)addVertices {
    for (NSInteger i = 0; i <= self.width ; i++) {
        for (NSInteger j = 0; j <= self.height; j++) {
            BBVertex *vertex = [[BBVertex alloc] initWithColumn:i andRow:j];
            vertex.grid = self;
            [self.vertices setObject:vertex forKey:vertex.key];
        }
    }
}

- (void)buildVertexConnections {
    
}

- (BBVertex *)vertexForColumn:(NSInteger)column andRow:(NSInteger)row {
    return [self.vertices objectForKey:[BBVertex keyForVertexWithColumn:column andRow:row]];
}

- (NSArray *)allVertices {
    return [self.vertices allValues];
}

#pragma mark connections
- (BBFace *)neighborForFace:(BBFace *)face inDirection:(BBSquareGridDirection)direction {
    BBFace *adjacentFace;
    
    switch (direction) {
        case BBSquareGridDirectionNorth:
            adjacentFace = [self faceForColumn:face.column andRow:face.row + 1];
            break;
            
        case BBSquareGridDirectionEast:
            adjacentFace = [self faceForColumn:face.column + 1 andRow:face.row];
            break;
            
        case BBSquareGridDirectionSouth:
            adjacentFace = [self faceForColumn:face.column andRow:face.row - 1];
            break;
            
        case BBSquareGridDirectionWest:
            adjacentFace = [self faceForColumn:face.column - 1 andRow:face.row];
            break;
            
        default:
            break;
    }
    
    return adjacentFace;
}

- (NSArray *)neighborsForFace:(BBFace *)face {
    return [NSArray new];
}

- (BBEdge *)borderForFace:(BBFace *)face inDirection:(BBSquareGridDirection)direction {
    BBEdge *edge;
    
    switch (direction) {
        case BBSquareGridDirectionNorth:
            edge = [self edgeForColumn:face.column andRow:face.row + 1 andSide:@"S"];
            break;
            
        case BBSquareGridDirectionEast:
            edge = [self edgeForColumn:face.column + 1 andRow:face.row andSide:@"W"];
            break;
            
        case BBSquareGridDirectionSouth:
            edge = [self edgeForColumn:face.column andRow:face.row andSide:@"S"];
            break;
            
        case BBSquareGridDirectionWest:
            edge = [self edgeForColumn:face.column andRow:face.row andSide:@"W"];
            break;
            
        default:
            break;
    }
    
    return edge;
}

- (NSArray *)bordersForFace:(BBFace *)face {
    NSMutableArray *borders = [NSMutableArray new];
    
    [borders addObject:[self edgeForColumn:face.column andRow:face.row andSide:@"W"]];
    [borders addObject:[self edgeForColumn:face.column andRow:face.row andSide:@"S"]];
    [borders addObject:[self edgeForColumn:face.column+1 andRow:face.row andSide:@"W"]];
    [borders addObject:[self edgeForColumn:face.column andRow:face.row+1 andSide:@"S"]];
    
    return [borders copy];
}

- (BBVertex *)cornerForFace:(BBFace *)face inDirection:(BBSquareGridDiagonalDirection)direction {
    NSAssert(false, @"Method not implemented yet");
    return [BBVertex new];
}

- (NSArray *)cornersForFace:(BBFace *)face {
    NSAssert(false, @"Method not implemented yet");
    return [NSArray new];
}

- (BBFace *)faceJoinedByEdge:(BBEdge *)edge inDirection:(BBSquareGridDirection)direction {
    NSAssert(false, @"Method not implemented yet");
    return [BBFace new];
}

- (NSArray *)facesJoinedByEdge:(BBEdge *)edge {
    NSAssert(false, @"Method not implemented yet");
    return [NSArray new];
}

- (BBEdge *)edgeContinuingEdge:(BBEdge *)edge inDirection:(BBSquareGridDirection)direction {
    NSAssert(false, @"Method not implemented yet");
    return [BBEdge new];
}

- (NSArray *)edgesContinuingEdge:(BBEdge *)edge {
    NSAssert(false, @"Method not implemented yet");
    return [NSArray new];
}

- (BBVertex *)endpointForEdge:(BBEdge *)edge inDirection:(BBSquareGridDirection)direction {
    NSAssert(false, @"Method not implemented yet");
    return [BBVertex new];
}

- (NSArray *)endpointsForEdge:(BBEdge *)edge {
    NSMutableArray *verts = [NSMutableArray new];
    
//    NSAssert([edge.grid isEqual:self], @"Edge is not a member of this grid");
    
    if ([edge.side isEqualToString:@"S"]) {
        [verts addObject:[self vertexForColumn:edge.column andRow:edge.row]];
        [verts addObject:[self vertexForColumn:edge.column + 1 andRow:edge.row]];
        return [verts copy];
    }
    
    if ([edge.side isEqualToString:@"W"]) {
        [verts addObject:[self vertexForColumn:edge.column andRow:edge.row]];
        [verts addObject:[self vertexForColumn:edge.column andRow:edge.row + 1]];
        return [verts copy];
    }
    
//    NSAssert(NO, @"Edge object contains invalid side designation");
    return nil;
    
}

- (BBFace *)faceTouchesVertex:(BBVertex *)vertex inDirection:(BBSquareGridDiagonalDirection)direction {
    NSAssert(false, @"Method not implemented yet");
    return [BBFace new];
}

- (NSArray *)facesTouchingVertex:(BBVertex *)vertex {
    NSAssert(false, @"Method not implemented yet");
    return [NSArray new];
}

- (BBEdge *)edgeProtrudesFromVertex:(BBVertex *)vertex inDirection:(BBSquareGridDirection)direction {
    NSAssert(false, @"Method not implemented yet");
    return [BBEdge new];
}

- (NSArray *)edgesProtrudingFromVertex:(BBVertex *)vertex {
    NSAssert(false, @"Method not implemented yet");
    return [NSArray new];
}

- (BBVertex *)vertexAdjacentToVertex:(BBVertex *)vertex inDirection:(BBSquareGridDirection)direction {
    NSAssert(false, @"Method not implemented yet");
    return [BBVertex new];
}

- (NSArray *)verticesAdjacentToVertex:(BBVertex *)vertex {
    NSAssert(false, @"Method not implemented yet");
    return [NSArray new];
}

# pragma mark Object Storage

// This part is not working, using objects for the key copies the obj, so it has a different address

- (void)setFace:(BBFace *)face forObject:(id)obj {
    if (!face) {
        NSLog(@"Warning - face value is nil");
    }
    [self.facesForObject setObject:face forKey:[NSNumber numberWithInteger:(NSInteger)obj]];
}

- (BBFace *)faceForObject:(id)obj {
    id facePtr = [self.facesForObject objectForKey:[NSNumber numberWithInteger:(NSInteger)obj]];
    BBFace *face = (BBFace *)facePtr;
    return face;
}

- (void)removeFaceForObject:(id)obj {
    [self.facesForObject removeObjectForKey:[NSNumber numberWithInteger:(NSInteger)obj]];
}

- (NSArray *)allObjectsInGrid {
    return [[self.facesForObject keyEnumerator] allObjects];
}

- (NSArray *)allFacesInGrid {
    return [[self.facesForObject objectEnumerator] allObjects];
}

// hack version until obj to obj dictionary works
//- (void)setFace:(BBFace *)face forString:(NSString *)key {
//    [self.locationsForObjects setValue:face forKey:key];
//}
//
//- (BBFace *)faceForString:(NSString *)key {
//    return (BBFace *)[self.locationsForObjects valueForKey:key];
//}
//
//- (void)removeFaceForString:(NSString *)key {
//    [self.locationsForObjects removeObjectForKey:key];
//}

- (BBFace *)faceForKey:(NSString *)key {
    // assert that string starts with Face
    if (![[key substringToIndex:4] isEqualToString:@"Face"]) {
        NSLog(@"Error - Key for grid face does not include \'Face\'.");
        return nil;
    }
    
    // parse Face::%ld::%ld
    
    NSUInteger keyLength = key.length;
    NSUInteger firstMarkerLocation = [key rangeOfString:@"::"].location;
    NSRange secondRange = NSMakeRange(firstMarkerLocation + 2, keyLength - firstMarkerLocation - 2);

    NSUInteger secondMarkerLocation = [key rangeOfString:@"::" options:NSLiteralSearch range:secondRange].location;
    
    if (firstMarkerLocation == NSNotFound) {
        NSLog(@"Error - first marker not found");
    }
    
    if (secondMarkerLocation == NSNotFound) {
        NSLog(@"Error - second marker not found");
    }
    
    NSString *columnString = [key substringWithRange:NSMakeRange(firstMarkerLocation + 2, secondMarkerLocation - firstMarkerLocation - 2)];
    NSString *rowString = [key substringWithRange:NSMakeRange(secondMarkerLocation + 2, keyLength - secondMarkerLocation - 2)];
    
    NSInteger col = [columnString integerValue];
    NSInteger row = [rowString integerValue];
    
    return [self faceForColumn:col andRow:row];
}

@end
