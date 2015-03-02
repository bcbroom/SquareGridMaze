//
//  BBSquareGridController.h
//  Grid
//
//  Created by Brian Broom on 2/13/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIImage;
@class SKSpriteNode;

@class BBFace;
@class BBEdge;
@class BBVertex;
@class BBSquareGrid;

@interface BBSquareGridController : NSObject

@property (assign, nonatomic) NSInteger faceWidth;
@property (assign, nonatomic) NSInteger faceHeight;
@property (assign, nonatomic) NSInteger padding;

- (instancetype)initWithGrid:(BBSquareGrid *)grid;

- (UIImage *)renderGrid;

- (CGPoint)pointForFaceCenter:(BBFace *)face;

- (CGPoint)centerToWallDistance;

@end
