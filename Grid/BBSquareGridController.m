//
//  BBSquareGridController.m
//  Grid
//
//  Created by Brian Broom on 2/13/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "BBSquareGridController.h"
#import "BBSquareGrid.h"
#import "BinaryTreeMazeGenerator.h"

// HACK! TODO: move game end part to GameScene
#import "GameScene.h"

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface BBSquareGridController ()

@property (strong, nonatomic) BBSquareGrid *grid;

@property (assign, nonatomic, readonly) NSInteger totalHeight;
@property (assign, nonatomic, readonly) NSInteger totalWidth;

@end

@implementation BBSquareGridController

- (instancetype)initWithGrid:(BBSquareGrid *)grid {
    self  = [super init];
    if (self) {
        _grid = grid;
        _faceHeight = 60;
        _faceWidth = 60;
        _padding = 10;
    }
    
    return self;
}

- (NSInteger)totalHeight {
    return self.grid.height * self.faceHeight + 2 * self.padding;
}

- (NSInteger)totalWidth {
    return self.grid.width * self.faceWidth + 2 * self.padding;
}

- (CGPoint)pointForFaceCenter:(BBFace *)face {
    return CGPointMake(face.column * self.faceWidth + self.faceWidth/2 + self.padding,
                face.row * self.faceHeight + self.faceHeight/2 + self.padding);
}

- (CGRect)rectForFace:(BBFace *)face {
    return CGRectMake(face.column * self.faceWidth + self.padding,
                      self.totalHeight - (face.row * self.faceHeight + self.padding + self.faceHeight), self.faceWidth, self.faceHeight);
}

- (CGPoint)pointForVertex:(BBVertex *)vertex {
    return CGPointMake(0, 0);
}

- (CGPoint)centerToWallDistance {
    return CGPointMake((self.faceWidth)/2, (self.faceHeight)/2);
}

- (UIImage *)renderGrid {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.totalWidth, self.totalHeight), YES, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, self.totalWidth, self.totalHeight));
    
    // init for random colors
    srand48(time(0));
    
    // rects for faces
    
    for (BBFace *face in [self.grid allFaces]) {
        [[UIColor colorWithHue:drand48() saturation:0.2 brightness:0.8 alpha:1.0] setFill];
        CGContextFillRect(ctx, [self rectForFace:face]);
        
//        [[UIColor blackColor] setFill];
//        
//        [[NSString stringWithFormat:@"(%ld,%ld)", face.column, face.row] drawAtPoint:CGPointMake(face.column * self.faceWidth + self.padding,
//                                          totalHeight - (face.row * self.faceHeight + self.padding + self.faceHeight)) withFont:[UIFont systemFontOfSize:14.0]];
    }
    
    // lines for edges
    
    for (BBEdge *edge in [self.grid allEdges]) {
        if (edge.isWall) {
            [[UIColor blackColor] setStroke];
            CGContextSetLineWidth(ctx, 4.0);
            CGContextSetLineCap(ctx, kCGLineCapRound);
        } else {
            [[UIColor whiteColor] setStroke];
            CGContextSetLineWidth(ctx, 1.0);
        }
        
        NSArray *verts = [self.grid endpointsForEdge:edge];
        
        if ([edge.side isEqualToString:@"S"]) {
            CGContextMoveToPoint(ctx, edge.column * self.faceWidth + self.padding,
                                 self.totalHeight - (edge.row * self.faceHeight + self.padding));
            CGContextAddLineToPoint(ctx, (edge.column + 1) * self.faceWidth + self.padding,
                                    self.totalHeight - (edge.row * self.faceHeight + self.padding));
        }
        
        if ([edge.side isEqualToString:@"W"]) {
            CGContextMoveToPoint(ctx, edge.column * self.faceWidth  + self.padding,
                                 self.totalHeight - (edge.row * self.faceHeight + self.padding));
            CGContextAddLineToPoint(ctx, edge.column * self.faceWidth + self.padding,
                                    self.totalHeight - ((edge.row + 1) * self.faceHeight + self.padding));
        }
        CGContextStrokePath(ctx);
    }
    
    
    
    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return textureImage;
}

#pragma mark Position Helpers

@end
