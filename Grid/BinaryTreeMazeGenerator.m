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

- (void)buildMaze:(BBSquareGrid *)grid {
    for (BBFace *face in grid.allFaces) {
        // edge of grid should be solid
        if (face.row == 0) {
            face.southEdge.isSolid = YES;
        }
        
        if (face.column == 0) {
            face.westEdge.isSolid = YES;
        }
        
        if (face.row == grid.height - 1) {
            face.northEdge.isSolid = YES;
        }
        
        if (face.column == grid.width - 1) {
            face.eastEdge.isSolid = YES;
        }
        
        // pick north or east to make open
        if (face.northFace && face.eastFace) {
            NSInteger choice = arc4random_uniform(2);
            
            if (choice == 0) {
                face.eastEdge.isSolid = YES;
            } else {
                face.northEdge.isSolid = YES;
            }
        }
    }    
}


@end
