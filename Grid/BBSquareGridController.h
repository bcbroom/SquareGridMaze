//
//  BBSquareGridController.h
//  Grid
//
//  Created by Brian Broom on 2/13/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class SKSpriteNode;

@interface BBSquareGridController : NSObject

@property (assign, nonatomic) NSInteger faceWidth;
@property (assign, nonatomic) NSInteger faceHeight;
@property (assign, nonatomic) NSInteger padding;
@property (strong, nonatomic) SKSpriteNode *player;

- (instancetype)initWithGridOfWidth:(NSInteger)width andHeight:(NSInteger)height;

- (UIImage *)renderGrid;
- (void)setupPlayer:(SKSpriteNode *)player;

- (void)playerMoveNorth;
- (void)playerMoveSouth;
- (void)playerMoveEast;
- (void)playerMoveWest;

@end
