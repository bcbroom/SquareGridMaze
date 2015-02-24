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
@property (strong, nonatomic) BBFace *playerFace;

@property (strong, nonatomic) BBFace *startFace;
@property (strong, nonatomic) BBFace *endFace;

@end

@implementation BBSquareGridController

- (instancetype)initWithGridOfWidth:(NSInteger)width andHeight:(NSInteger)height {
    self  = [super init];
    if (self) {
        _grid = [[BBSquareGrid alloc] initWithWidth:width andHeight:height];
        _faceHeight = 60;
        _faceWidth = 60;
        _padding = 10;
    }
    
    BinaryTreeMazeGenerator *btmg = [BinaryTreeMazeGenerator new];
    [btmg buildMaze:self.grid];
    
    self.endFace = [self.grid faceForColumn:self.grid.width - 1 andRow:self.grid.height - 1];
    
    // hack
    // TODO: move to a propper resetting method
    // propper way is to reset all the edges isSolid to NO, and rebuild
    if (_player) {
        _startFace = [_grid faceForColumn:0 andRow:0];
        _playerFace = _startFace;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithGridOfWidth:3 andHeight:4];
}

#pragma mark Player Setup and Movement

- (void)setupPlayer:(SKSpriteNode *)player {
    self.player = player;
    self.playerFace = [self.grid faceForColumn:0 andRow:0];
    
    [self updatePlayerPosition];
}

- (void)playerMoveNorth {
    CGPoint bounceDist = [self centerToWallDistance];
    if (!self.playerFace.northFace) {
        
        SKAction *moveToWall = [SKAction moveByX:0 y:bounceDist.y duration:0.125];
        SKAction *moveBack = [SKAction moveByX:0 y:-bounceDist.y duration:0.125];
        
        [self.player runAction:[SKAction sequence:@[moveToWall, moveBack]] withKey:@"moving"];
        
        NSLog(@"Can't move north");
        return;
    }
    
    if (!self.playerFace.northEdge.isSolid) {
        self.playerFace = self.playerFace.northFace;
        [self updatePlayerPosition];
    } else {
        
        SKAction *moveToWall = [SKAction moveByX:0 y:bounceDist.y duration:0.125];
        SKAction *moveBack = [SKAction moveByX:0 y:-bounceDist.y duration:0.125];
        
        [self.player runAction:[SKAction sequence:@[moveToWall, moveBack]] withKey:@"moving"];
        NSLog(@"Blocked by a wall");
    }
}

- (void)playerMoveSouth {
    if (!self.playerFace.southFace) {
        NSLog(@"Can't move south");
        return;
    }
    
    if (!self.playerFace.southEdge.isSolid) {
        self.playerFace = self.playerFace.southFace;
        [self updatePlayerPosition];
    } else {
        NSLog(@"Blocked by a wall");
    }
}

- (void)playerMoveEast {
    if (!self.playerFace.eastFace) {
        NSLog(@"Can't move east");
        return;
    }
    
    if (!self.playerFace.eastEdge.isSolid) {
        self.playerFace = self.playerFace.eastFace;
        [self updatePlayerPosition];
    } else {
        NSLog(@"Blocked by a wall");
    }
}

- (void)playerMoveWest {
    if (!self.playerFace.westFace) {
        NSLog(@"Can't move west");
        return;
    }
    
    if (!self.playerFace.westEdge.isSolid) {
        self.playerFace = self.playerFace.westFace;
        [self updatePlayerPosition];
    } else {
        NSLog(@"Blocked by a wall");
    }
}

- (void)updatePlayerPosition {
    CGPoint newPosition = [self pointForFaceCenter:self.playerFace];
    SKAction *animateMove = [SKAction moveTo:newPosition duration:0.25];
    [self.player runAction:animateMove completion:^{
        [self checkSolved];
    }];
}

- (void)checkSolved {
    if (self.playerFace == self.endFace) {
        
        self.playerFace = [self.grid faceForColumn:0 andRow:0];
        [self updatePlayerPosition];
        
        [(GameScene *)self.player.scene youWin];
    }
}

- (CGPoint)pointForFaceCenter:(BBFace *)face {
    return CGPointMake(face.column * self.faceWidth + self.faceWidth/2 + self.padding,
                face.row * self.faceHeight + self.faceHeight/2 + self.padding);
}

- (CGPoint)centerToWallDistance {
    return CGPointMake((self.faceWidth - self.player.size.width)/2, (self.faceHeight - self.player.size.height)/2);
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
        if (edge.isSolid) {
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
