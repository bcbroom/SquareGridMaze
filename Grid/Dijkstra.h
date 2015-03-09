//
//  Dijkstra.h
//  Grid
//
//  Created by Brian Broom on 3/4/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBSquareGrid;
@class BBFace;

@interface Dijkstra : NSObject

- (void)calculateSimpleDijkstraOnGrid:(BBSquareGrid *)grid startFace:(BBFace *)startFace;
- (NSArray *)solutionPathForGrid:(BBSquareGrid *)grid startFace:(BBFace *)startface endFace:(BBFace *)endface;

@end
