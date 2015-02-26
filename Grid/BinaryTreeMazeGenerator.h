//
//  BinaryTreeMazeGenerator.h
//  Grid
//
//  Created by Brian Broom on 2/19/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBSquareGrid;

@interface BinaryTreeMazeGenerator : NSObject

- (void)buildMazeOnGrid:(BBSquareGrid *)grid;

@end
