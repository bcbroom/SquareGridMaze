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

@property (strong, nonatomic) NSMutableArray *faces;
@property (strong, nonatomic) NSMutableArray *edges;
@property (strong, nonatomic) NSMutableArray *vertices;
@property (strong, nonatomic) NSMutableDictionary *locationsForObjects;
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
    _faces = [NSMutableArray new];
    for (int i = 0; i < _width; i++) {
        [_faces addObject:[NSMutableArray new]];
    }
    
    _edges = [NSMutableArray new];
    // +1 to both dimensions since the outside E,N edges are
    // technically in the next cell, outside the face bounds
    for (int i = 0; i < _width + 1; i++) {
        [_edges addObject:[NSMutableArray new]];
        
        for (int j = 0; j < _height + 1; j++) {
            _edges[i][j] = [NSMutableDictionary new];
        }
    }
    
    _vertices = [NSMutableArray new];
    
    _locationsForObjects = [NSMutableDictionary new];
    _facesForObject = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
}

#pragma mark Faces

- (void)addFaces {
    for (NSInteger i = 0; i < self.width ; i++) {
        for (NSInteger j = 0; j < self.height; j++) {
            BBFace *face = [[BBFace alloc] initWithColumn:i andRow:j];
            face.grid = self;
            self.faces[i][j] = face;
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
    
    return self.faces[column][row];
}

- (NSArray *)allFaces {
    NSMutableArray *allFaces = [NSMutableArray new];
    
    for (NSMutableArray *column in self.faces) {
        [allFaces addObjectsFromArray:column];
    }
    
    return allFaces;
}

#pragma mark Edges

- (void)addEdges {
    for (int i = 0; i < _width; i++) {
        for (int j = 0; j < _height; j++) {
            BBEdge *sEdge = [BBEdge edgeWithColumn:i andRow:j andSide:@"S"];
            sEdge.grid = self;
            _edges[i][j][@"S"] = sEdge;
            
            BBEdge *wEdge = [BBEdge edgeWithColumn:i andRow:j andSide:@"W"];
            wEdge.grid = self;
            _edges[i][j][@"W"] = wEdge;
        }
    }
    
    // add top edges, which are S edges for the face just beyond grid edge
    for (int i = 0; i < _width; i++) {
        BBEdge *topEdge = [BBEdge edgeWithColumn:i andRow:_height andSide:@"S"];
        _edges[i][_height][@"S"] = topEdge;
    }
    
    // add right edges, similarly, but these are W edges
    for (int j = 0; j < _height; j++) {
        BBEdge *rightEdge = [BBEdge edgeWithColumn:_width andRow:j andSide:@"W"];
        _edges[_width][j][@"W"] = rightEdge;
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
    return self.edges[column][row][side];
}

- (NSArray *)allEdges {
    NSMutableArray *allEdges = [NSMutableArray new];
    
    for (NSMutableArray *row in self.edges) {
        for (NSMutableDictionary *dict in row) {
            [allEdges addObjectsFromArray:dict.allValues];
        }
    }
    
    return allEdges;
}

#pragma mark Vertices

- (void)addVertices {
    
}

- (void)buildVertexConnections {
    
}

- (BBVertex *)vertexForColumn:(NSInteger)column andRow:(NSInteger)row {
    return [BBVertex new];
}

- (NSMutableArray *)allVertices {
    return self.vertices;
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

# pragma mark Object Storage

// This part is not working, using objects for the key copies the obj, so it has a different address

- (void)setFace:(BBFace *)face forObject:(id)obj {
    [self.facesForObject setObject:face forKey:obj];
}

- (BBFace *)faceForObject:(id)obj {
    return [self.facesForObject objectForKey:obj];
}

// hack version until obj to obj dictionary works
- (void)setFace:(BBFace *)face forString:(NSString *)key {
    [self.locationsForObjects setValue:face forKey:key];
}

- (BBFace *)faceForString:(NSString *)key {
    return (BBFace *)[self.locationsForObjects valueForKey:key];
}

- (void)removeFaceForString:(NSString *)key {
    [self.locationsForObjects removeObjectForKey:key];
}

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
    //NSString *secondKeyString = [key substringWithRange:secondRange];
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

- (NSString *)keyForFaceWithColumn:(NSInteger)column andRow:(NSInteger)row {
    return [NSString stringWithFormat:@"Face::%ld::%ld", column, row];
}

@end
