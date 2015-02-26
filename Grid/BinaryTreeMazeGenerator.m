//
//  BinaryTreeMazeGenerator.m
//  Grid
//
//  Created by Brian Broom on 2/19/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "BinaryTreeMazeGenerator.h"
#import "BBSquareGrid.h"


@implementation BinaryTreeMazeGenerator

- (void)buildMazeOnGrid:(BBSquareGrid *)grid {
    // reset all edges to not wall
    for (BBEdge *edge in grid.allEdges) {
        edge.isWall = NO;
    }
    
    
    for (BBFace *face in grid.allFaces) {
        // edge of grid should be solid
        if (face.row == 0) {
            face.southEdge.isWall = YES;
        }
        
        if (face.column == 0) {
            face.westEdge.isWall = YES;
        }
        
        if (face.row == grid.height - 1) {
            face.northEdge.isWall = YES;
        }
        
        if (face.column == grid.width - 1) {
            face.eastEdge.isWall = YES;
        }
        
        // pick north or east to make open
        if (face.northFace && face.eastFace) {
            NSInteger choice = arc4random_uniform(2);
            
            if (choice == 0) {
                face.eastEdge.isWall = YES;
            } else {
                face.northEdge.isWall = YES;
            }
        }
    }    
}


@end
