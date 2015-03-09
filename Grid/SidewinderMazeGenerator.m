//
//  SidewinderMazeGenerator.m
//  Grid
//
//  Created by Brian Broom on 3/4/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "SidewinderMazeGenerator.h"
#import "BBSquareGrid.h"

@implementation SidewinderMazeGenerator

- (void)buildMazeOnGrid:(BBSquareGrid *)grid {
    // reset all edges to not wall
    for (BBEdge *edge in grid.allEdges) {
        edge.isWall = NO;
    }
    
    NSArray *faces = [grid allFaces];
    
    NSSortDescriptor *byRows = [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
    NSSortDescriptor *byCols = [NSSortDescriptor sortDescriptorWithKey:@"column" ascending:YES];
    
    NSArray *sortedFaces = [faces sortedArrayUsingDescriptors:@[byRows, byCols]];
    
    NSMutableArray *runOfCells = [NSMutableArray new];
    
    // start with all walls
    // will carve out
    
    for (BBEdge *edge in grid.allEdges) {
        edge.isWall = YES;
    }
    
    for (BBFace *face in sortedFaces) {
        if (face.column == 0) {
            // new row - reset run of cells
            [runOfCells removeAllObjects];
        }
        
        [runOfCells addObject:face];
        bool atEastBoundary = face.column == grid.width - 1;
        bool atNorthBoundary = face.row == grid.height - 1;
        
        bool shouldCloseOut = atEastBoundary || ( !atNorthBoundary && arc4random_uniform(2) == 0);
        
        if (shouldCloseOut) {
            NSInteger randomIndex = arc4random_uniform((int)runOfCells.count);
            BBFace *selectedFace = runOfCells[randomIndex];
            if (selectedFace.row != grid.height - 1) {
                selectedFace.northEdge.isWall = NO;
            }
            [runOfCells removeAllObjects];
        } else {
            face.eastEdge.isWall = NO;
        }
        
    }
}

@end
