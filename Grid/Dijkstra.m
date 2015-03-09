//
//  Dijkstra.m
//  Grid
//
//  Created by Brian Broom on 3/4/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "Dijkstra.h"
#import "BBSquareGrid.h"

@interface Dijkstra ()

@end

@implementation Dijkstra

- (void)calculateSimpleDijkstraOnGrid:(BBSquareGrid *)grid startFace:(BBFace *)startFace {
    [self zeroAllDistancesOnGrid:grid];
    
    NSMutableArray *frontierFaces = [NSMutableArray new];
    [frontierFaces addObject:startFace];
    
    while (frontierFaces.count > 0) {
        BBFace *visitedFace = [frontierFaces firstObject];
        [frontierFaces removeObjectAtIndex:0];
        if (visitedFace.visited) { NSLog(@"face visited previously - something went wrong"); }
        
        visitedFace.visited = YES;
        
        NSArray *connectedFaces = [grid connectedFacesForFace:visitedFace];
        NSPredicate *unvisitedFilter = [NSPredicate predicateWithFormat:@"visited == NO"];
        NSArray *unvisitedFaces = [connectedFaces filteredArrayUsingPredicate:unvisitedFilter];
        
        for (BBFace *newFace in unvisitedFaces) {
            newFace.distance = visitedFace.distance + 1;
            [frontierFaces addObject:newFace];
        }
    }
}

- (void)zeroAllDistancesOnGrid:(BBSquareGrid *)grid {
    for (BBFace *face in grid.allFaces) {
        face.distance = 0;
        face.visited = NO;
    }
}

- (NSArray *)solutionPathForGrid:(BBSquareGrid *)grid startFace:(BBFace *)startface endFace:(BBFace *)endface {
    if (endface.distance == 0) {
        [self calculateSimpleDijkstraOnGrid:grid startFace:startface];
    }
    
    NSMutableArray *path = [NSMutableArray new];
    [path addObject:endface];
    
    while (path.firstObject != startface) {
        BBFace *currentFace = path.firstObject;
        NSArray *connectedFaces = [grid connectedFacesForFace:currentFace];
        
        for (BBFace *newFace in connectedFaces) {
            if (newFace.distance == currentFace.distance - 1) {
                [path insertObject:newFace atIndex:0];                
            }
        }
    }
    
    return [path copy];
}

@end
