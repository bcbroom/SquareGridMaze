//
//  SidewinderMazeGenerator.h
//  Grid
//
//  Created by Brian Broom on 3/4/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBSquareGrid;

@interface SidewinderMazeGenerator : NSObject

- (void)buildMazeOnGrid:(BBSquareGrid *)grid;

@end
