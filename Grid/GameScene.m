//
//  GameScene.m
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "GameScene.h"
#import "BBSquareGridController.h"

#import "BBSquareGrid.h"
#import "BinaryTreeMazeGenerator.h"

@interface GameScene ()

@property (strong, nonatomic) BBSquareGridController *gridController;
@property (strong, nonatomic) SKSpriteNode *gridSprite;
@property (strong, nonatomic) UISwipeGestureRecognizer *upSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *downSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipeRecognizer;

@property (strong, nonatomic) BBSquareGrid *grid;

@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) SKSpriteNode *goal;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    NSLog(@"scene size is (%f,%f)", self.size.width, self.size.height);
    
    self.grid = [[BBSquareGrid alloc] initWithWidth:5 andHeight:9];
    self.gridController = [[BBSquareGridController alloc] initWithGrid:self.grid width:5 height:9];
    
    BinaryTreeMazeGenerator *btmg = [BinaryTreeMazeGenerator new];
    [btmg buildMazeOnGrid:self.grid];
    
    UIImage *gridImage = [self.gridController renderGrid];
    SKTexture *gridTexture = [SKTexture textureWithImage:gridImage];
    self.gridSprite = [SKSpriteNode spriteNodeWithTexture:gridTexture];
    
    //gridSprite.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    self.gridSprite.position = CGPointMake(self.gridSprite.size.width/2, self.gridSprite.size.height/2);
    [self addChild:self.gridSprite];
    
    self.goal = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(20, 20)];
    //[self.grid setFace:[self.grid faceForColumn:self.grid.width - 1 andRow:self.grid.height - 1] forString:@"goal"];
    self.goal.position = [self.gridController pointForFaceCenter:[self.grid faceForString:@"goal"]];
    self.goal.zPosition = 1;
    [self addChild:self.goal];
    
    self.player = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
    //[self.grid setFace:[self.grid faceForColumn:0 andRow:0] forString:@"player"];
    //[self updatePlayerPosition];
    self.player.zPosition = 1;
    [self addChild:self.player];
    
    [self setStartAndGoal];
    
    self.upSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playerMoveNorth)];
    self.upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.upSwipeRecognizer];
    
    self.downSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playerMoveSouth)];
    self.downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.downSwipeRecognizer];
    
    self.leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playerMoveWest)];
    self.leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeRecognizer];
    
    self.rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playerMoveEast)];
    self.rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightSwipeRecognizer];
}

- (void)updatePlayerPosition {
    BBFace *face = [self.grid faceForString:@"player"];
    CGPoint newPosition = [self.gridController pointForFaceCenter:face];
    SKAction *animateMove = [SKAction moveTo:newPosition duration:0.25];
    
    [self.player runAction:animateMove completion:^{
        [self checkSolved];
    }];
}

- (void)checkSolved {
    BBFace *playerFace = [self.grid faceForString:@"player"];
    BBFace *goalFace = [self.grid faceForString:@"goal"];
    
    if (playerFace == goalFace) {
        [(GameScene *)self.player.scene youWin];
    }
}

- (void)youWin {
    SKLabelNode *winLabel = [SKLabelNode labelNodeWithText:@"You Win!"];
    winLabel.fontColor = [UIColor blackColor];
    winLabel.fontSize = 80;
    winLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    winLabel.alpha = 0.0;
    [self addChild:winLabel];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:2.0];
    
    [winLabel runAction:[SKAction sequence:@[fadeIn, fadeOut]] completion:^{
        [self resetMaze];
        [winLabel removeFromParent];
    }];
}

- (void)resetMaze {
    [self.grid setFace:[self.grid faceForColumn:0 andRow:0] forString:@"player"];
    [self updatePlayerPosition];
    
    BinaryTreeMazeGenerator *btmg = [BinaryTreeMazeGenerator new];
    [btmg buildMazeOnGrid:self.grid];
    
    UIImage *gridImage = [self.gridController renderGrid];
    SKTexture *gridTexture = [SKTexture textureWithImage:gridImage];
    self.gridSprite.texture = gridTexture;
    
    [self setStartAndGoal];
}

- (void)setStartAndGoal {
    NSInteger choice = arc4random_uniform(4);
    
    BBFace *startFace;
    BBFace *goalFace;
    
    switch (choice) {
        case 0:
            startFace = [self.grid faceForColumn:0 andRow:0];
            goalFace = [self.grid faceForColumn:self.grid.width - 1 andRow:self.grid.height - 1];
            break;
            
        case 1:
            startFace = [self.grid faceForColumn:0 andRow:self.grid.height - 1];
            goalFace = [self.grid faceForColumn:self.grid.width - 1 andRow:0];
            break;
            
        case 2:
            startFace = [self.grid faceForColumn:self.grid.width - 1 andRow:self.grid.height - 1];
            goalFace = [self.grid faceForColumn:0 andRow:0];
            break;
            
        case 3:
            startFace = [self.grid faceForColumn:self.grid.width - 1 andRow:0];
            goalFace = [self.grid faceForColumn:0 andRow:self.grid.height - 1];
            break;
            
        default:
            break;
    }
    self.goal.position = [self.gridController pointForFaceCenter:goalFace];
    [self.grid setFace:goalFace forString:@"goal"];
    
    [self.grid setFace:startFace forString:@"player"];
    [self updatePlayerPosition];
}

#pragma mark Player Movement

- (void)playerMove:(BBSquareGridDirection)direction {
    CGPoint bounceDist = [self.gridController centerToWallDistance];
    bounceDist = CGPointMake(bounceDist.x - self.player.size.width/2, bounceDist.y - self.player.size.height/2);
    BBFace *playerFace = [self.grid faceForString:@"player"];
    SKAction *moveToWall;
    BBFace *targetFace;
    BBEdge *passThroughEdge;
    
    switch (direction) {
        case BBSquareGridDirectionNorth:
            moveToWall = [SKAction moveByX:0 y:bounceDist.y duration:0.125];
            targetFace = playerFace.northFace;
            passThroughEdge = playerFace.northEdge;
            break;
            
        case BBSquareGridDirectionEast:
            moveToWall = [SKAction moveByX:bounceDist.x y:0 duration:0.125];
            targetFace = playerFace.eastFace;
            passThroughEdge = playerFace.eastEdge;
            break;
            
        case BBSquareGridDirectionSouth:
            moveToWall = [SKAction moveByX:0 y:-bounceDist.y duration:0.125];
            targetFace = playerFace.southFace;
            passThroughEdge = playerFace.southEdge;
            break;
            
        case BBSquareGridDirectionWest:
            moveToWall = [SKAction moveByX:-bounceDist.x y:0 duration:0.125];
            targetFace = playerFace.westFace;
            passThroughEdge = playerFace.westEdge;
            break;
            
        default:
            NSLog(@"Invalid direction in playerMove:direction");
            break;
    }
    
    if (!targetFace || passThroughEdge.isWall) {
        [self.player runAction:[SKAction sequence:@[moveToWall, [moveToWall reversedAction]]] withKey:@"moving"];
        NSLog(@"Can't move");
        return;
    }
    
    [self.grid setFace:targetFace forString:@"player"];
    [self updatePlayerPosition];    
}

- (void)playerMoveNorth {
    [self playerMove:BBSquareGridDirectionNorth];
}

- (void)playerMoveSouth {
    [self playerMove:BBSquareGridDirectionSouth];
}

- (void)playerMoveEast {
    [self playerMove:BBSquareGridDirectionEast];
}

- (void)playerMoveWest {
    [self playerMove:BBSquareGridDirectionWest];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
