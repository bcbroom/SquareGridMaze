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

@end

@implementation BBSquareGridController

- (instancetype)initWithGrid:(BBSquareGrid *)grid width:(NSInteger)width height:(NSInteger)height {
    self  = [super init];
    if (self) {
        _grid = grid;
        _faceHeight = 60;
        _faceWidth = 60;
        _padding = 10;
    }
    

    
    return self;
}

//- (instancetype)init {
//    return [self initWithGridOfWidth:3 andHeight:4];
//}

- (CGPoint)pointForFaceCenter:(BBFace *)face {
    return CGPointMake(face.column * self.faceWidth + self.faceWidth/2 + self.padding,
                face.row * self.faceHeight + self.faceHeight/2 + self.padding);
}

- (CGPoint)centerToWallDistance {
    return CGPointMake((self.faceWidth)/2, (self.faceHeight)/2);
}

- (UIImage *)renderGrid {
    NSInteger totalHeight = self.grid.height * self.faceHeight + 2 * self.padding;
    NSInteger totalWidth = self.grid.width * self.faceWidth + 2 * self.padding;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(totalWidth, totalHeight), YES, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, totalWidth, totalHeight));
    
    //Then draw whatever you need, remember to set fill and stroke colors.
    
    // init for random colors
    srand48(time(0));
    
    // rects for faces
    
    for (BBFace *face in [self.grid allFaces]) {
        [[UIColor colorWithHue:drand48() saturation:0.2 brightness:0.8 alpha:1.0] setFill];
        CGContextFillRect(ctx, CGRectMake(face.column * self.faceWidth + self.padding,
                                          totalHeight - (face.row * self.faceHeight + self.padding + self.faceHeight), self.faceWidth, self.faceHeight));
        
//        [[UIColor blackColor] setFill];
//        
//        [[NSString stringWithFormat:@"(%ld,%ld)", face.column, face.row] drawAtPoint:CGPointMake(face.column * self.faceWidth + self.padding,
//                                          totalHeight - (face.row * self.faceHeight + self.padding + self.faceHeight)) withFont:[UIFont systemFontOfSize:14.0]];
    }
    
    //[[UIColor whiteColor] setStroke];
    //CGContextSetLineWidth(ctx, 1.0);
    
    // lines for edges
    
    for (BBEdge *edge in [self.grid allEdges]) {
        if (edge.isWall) {
            [[UIColor blackColor] setStroke];
            CGContextSetLineWidth(ctx, 2.0);
        } else {
            [[UIColor whiteColor] setStroke];
            CGContextSetLineWidth(ctx, 1.0);
        }
        
        if ([edge.side isEqualToString:@"S"]) {
            CGContextMoveToPoint(ctx, edge.column * self.faceWidth + self.padding,
                                 totalHeight - (edge.row * self.faceHeight + self.padding));
            CGContextAddLineToPoint(ctx, (edge.column + 1) * self.faceWidth + self.padding,
                                    totalHeight - (edge.row * self.faceHeight + self.padding));
        }
        
        if ([edge.side isEqualToString:@"W"]) {
            CGContextMoveToPoint(ctx, edge.column * self.faceWidth  + self.padding,
                                 totalHeight - (edge.row * self.faceHeight + self.padding));
            CGContextAddLineToPoint(ctx, edge.column * self.faceWidth + self.padding,
                                    totalHeight - ((edge.row + 1) * self.faceHeight + self.padding));
        }
        CGContextStrokePath(ctx);
    }
    
    
    
    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return textureImage;
}

#pragma mark Position Helpers

@end
