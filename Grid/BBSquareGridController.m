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

#import "Dijkstra.h"

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
        
        // some configs will use random colors
        // seed so that they are already setup
        // may not be needed, but don't have to check
        srand48(time(0));
        
    }
    
    return self;
}

- (NSInteger)totalHeight {
    return self.grid.height * self.faceHeight + 2 * self.padding;
}

- (NSInteger)totalWidth {
    return self.grid.width * self.faceWidth + 2 * self.padding;
}

#pragma mark Grid Geometry Conversions

- (CGPoint)pointForFaceCenter:(BBFace *)face {
    return CGPointMake(face.column * self.faceWidth + self.faceWidth/2 + self.padding,
                       self.totalHeight - (face.row * self.faceHeight + self.faceHeight/2 + self.padding));
}

- (CGPoint)pointForFaceCenterYReversed:(BBFace *)face {
    return CGPointMake(face.column * self.faceWidth + self.faceWidth/2 + self.padding,
                       face.row * self.faceHeight + self.faceHeight/2 + self.padding);
}

- (CGPoint)pointForEdgeCenterYReversed:(BBEdge *)edge {
    if ([edge.side isEqualToString:@"S"]) {
    return CGPointMake(edge.column * self.faceWidth + self.faceWidth/2 + self.padding,
                       edge.row * self.faceHeight + self.padding);
    }
    
    if ([edge.side isEqualToString:@"W"]) {
        return CGPointMake(edge.column * self.faceWidth + self.padding,
                           edge.row * self.faceHeight + self.faceHeight/2 + self.padding);
    }
    
    NSAssert(NO, @"Error - Invalid side designation for Edge");
    return CGPointZero;
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

#pragma mark Grid Image Render

- (void)drawBackgroundLayer:(CGContextRef)ctx {
    if (self.bgColor) {
        [self.bgColor setFill];
    } else {
        [[UIColor lightGrayColor] setFill];
    }
    CGContextFillRect(ctx, CGRectMake(0, 0, self.totalWidth, self.totalHeight));
}

-(UIColor *)randomFillColor {
    return [UIColor colorWithHue:drand48() saturation:0.2 brightness:0.8 alpha:1.0];
}

- (void)drawGridFaces:(CGContextRef)ctx {

    [self.faceColor setFill];
    if (!self.faceColor) { [[UIColor whiteColor] setFill]; }
    
    for (BBFace *face in [self.grid allFaces]) {
        if (self.randomFaceColors) { [[self randomFillColor] setFill]; }
        if ([self.path containsObject:face]) { [[UIColor yellowColor] setFill]; }
        CGContextFillRect(ctx, [self rectForFace:face]);
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
// this is only a diagnostic method, leaving it in for now

- (void)drawFaceLabels:(CGContextRef)ctx {
    //if (!self.drawFaceLabels) { return; }
    
    [[UIColor blackColor] setFill];
    
    for (BBFace *face in [self.grid allFaces]) {
        CGPoint faceCenter = [self pointForFaceCenter:face];
//        [[NSString stringWithFormat:@"(%ld,%ld)", face.column, face.row] drawAtPoint:CGPointMake(faceCenter.x - 14, faceCenter.y - 7)
//                                                                            withFont:[UIFont systemFontOfSize:14.0]];
        [[NSString stringWithFormat:@"%ld", face.distance] drawAtPoint:CGPointMake(faceCenter.x - 14, faceCenter.y - 7)
                                                                            withFont:[UIFont systemFontOfSize:14.0]];
        
    }
}

#pragma clang diagnostic pop

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

#pragma mark Grid Sprite Rendering

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

- (SKNode *)renderAsSpriteNode {
    UIColor *bgColor = self.bgColor ? self.bgColor : [UIColor lightGrayColor];
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithColor:bgColor size:CGSizeMake(self.totalWidth, self.totalHeight)];
    
    bgNode.anchorPoint = CGPointMake(0, 0);
    
    for (BBFace *face in [self.grid allFaces]) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[self randomFillColor] size:CGSizeMake(self.faceWidth, self.faceHeight)];
        face.sprite = sprite;
        sprite.position = [self pointForFaceCenterYReversed:face];
        [bgNode addChild:sprite];
        
    }
    
    for (BBEdge *edge in [self.grid allEdges]) {
        if ([edge.side isEqualToString:@"S"]) {
            if (!edge.isWall) { continue; }
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.faceWidth, 4)];
            edge.sprite = sprite;
            sprite.position = [self pointForEdgeCenterYReversed:edge];
            [bgNode addChild:sprite];
        }
        
        if ([edge.side isEqualToString:@"W"]) {
            if (!edge.isWall) { continue; }
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(4, self.faceHeight)];
            edge.sprite = sprite;
            sprite.position = [self pointForEdgeCenterYReversed:edge];
            [bgNode addChild:sprite];
        }
    }
    
    return bgNode;
}





@end
