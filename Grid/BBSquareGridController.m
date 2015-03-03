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

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface BBSquareGridController ()

@property (strong, nonatomic) BBSquareGrid *grid;

@property (assign, nonatomic, readonly) NSInteger totalHeight;
@property (assign, nonatomic, readonly) NSInteger totalWidth;

@property (assign, nonatomic) BOOL randomFaceColors;
@property (assign, nonatomic) BOOL drawNonWallEdges;
@property (assign, nonatomic) BOOL drawFaceLabels;
@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIColor *faceColor;
@property (strong, nonatomic) UIColor *edgeColor;
@property (strong, nonatomic) UIColor *wallColor;
@property (assign, nonatomic) NSInteger wallLineWidth;

@end

@implementation BBSquareGridController

- (instancetype)initWithGrid:(BBSquareGrid *)grid {
    self  = [super init];
    if (self) {
        _grid = grid;
        _faceHeight = 60;
        _faceWidth = 60;
        _padding = 10;
        
        _randomFaceColors = YES;
        _drawNonWallEdges = YES;
        _drawFaceLabels = NO;
        _wallLineWidth = 4;
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
                       self.totalHeight - (face.row * self.faceHeight + self.faceHeight/2 + self.padding));
}

- (CGPoint)pointForFaceCenterYReversed:(BBFace *)face {
    return CGPointMake(face.column * self.faceWidth + self.faceWidth/2 + self.padding,
                       face.row * self.faceHeight + self.faceHeight/2 + self.padding);
}

- (CGRect)rectForFace:(BBFace *)face {
    return CGRectMake(face.column * self.faceWidth + self.padding,
                      self.totalHeight - (face.row * self.faceHeight + self.padding + self.faceHeight), self.faceWidth, self.faceHeight);
}

- (CGPoint)pointForVertex:(BBVertex *)vertex {
    return CGPointMake(vertex.column * self.faceWidth + self.padding,
                       self.totalHeight - (vertex.row * self.faceHeight + self.padding));
}

- (CGPoint)centerToWallDistance {
    return CGPointMake((self.faceWidth)/2, (self.faceHeight)/2);
}

- (void)drawBackgroundLayer:(CGContextRef)ctx {
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, self.totalWidth, self.totalHeight));
}

-(void)randomFillColor {
    [[UIColor colorWithHue:drand48() saturation:0.2 brightness:0.8 alpha:1.0] setFill];
}

- (void)drawGridFaces:(CGContextRef)ctx {
    if (self.randomFaceColors) {
        srand48(time(0));
    }
    
    if (!self.faceColor) {
        [[UIColor whiteColor] setFill];
    } else {
        [self.faceColor setFill];
    }
    
    for (BBFace *face in [self.grid allFaces]) {
        if (self.randomFaceColors) { [self randomFillColor]; }
        CGContextFillRect(ctx, [self rectForFace:face]);
    }
}

- (void)drawFaceLabels:(CGContextRef)ctx {
    if (!self.drawFaceLabels) { return; }
    
    [[UIColor blackColor] setFill];
    
    for (BBFace *face in [self.grid allFaces]) {
        CGPoint faceCenter = [self pointForFaceCenter:face];
        [[NSString stringWithFormat:@"(%ld,%ld)", face.column, face.row] drawAtPoint:CGPointMake(faceCenter.x - 14, faceCenter.y - 7)
                                                                            withFont:[UIFont systemFontOfSize:14.0]];
    }
}

- (void)drawEdgesNotWalls:(CGContextRef)ctx {
    NSPredicate *notAWall = [NSPredicate predicateWithFormat:@"wall == NO"];
    NSArray *edgesNotWalls = [[self.grid allEdges] filteredArrayUsingPredicate:notAWall];

    if (!self.drawNonWallEdges) { return; }
    
    if (self.edgeColor) {
        [self.edgeColor setStroke];
    } else {
        [[UIColor whiteColor] setStroke];
    }
    
    for (BBEdge *edge in edgesNotWalls) {

        CGContextSetLineWidth(ctx, 1.0);
        NSArray *verts = [self.grid endpointsForEdge:edge];
        
        CGPoint firstPoint = [self pointForVertex:verts[0]];
        CGPoint secondPoint = [self pointForVertex:verts[1]];
        CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
        CGContextAddLineToPoint(ctx, secondPoint.x, secondPoint.y);
        
        CGContextStrokePath(ctx);
    }
}

- (void)drawWallEdges:(CGContextRef)ctx {
    NSPredicate *yesAWall = [NSPredicate predicateWithFormat:@"wall == YES"];
    NSArray *edgesAreWalls = [[self.grid allEdges] filteredArrayUsingPredicate:yesAWall];
    
    if (self.wallColor) {
        [self.wallColor setStroke];
    } else {
        [[UIColor blackColor] setStroke];
    }
    
    for (BBEdge *edge in edgesAreWalls) {

        CGContextSetLineWidth(ctx, self.wallLineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        NSArray *verts = [self.grid endpointsForEdge:edge];
        
        CGPoint firstPoint = [self pointForVertex:verts[0]];
        CGPoint secondPoint = [self pointForVertex:verts[1]];
        CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
        CGContextAddLineToPoint(ctx, secondPoint.x, secondPoint.y);
        
        CGContextStrokePath(ctx);
    }
}

- (UIImage *)renderGridAsImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.totalWidth, self.totalHeight), YES, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawBackgroundLayer:ctx];
    [self drawGridFaces:ctx];
    [self drawFaceLabels:ctx];
    [self drawEdgesNotWalls:ctx];    
    [self drawWallEdges:ctx];
    
    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return textureImage;
}

#pragma mark Position Helpers

@end
