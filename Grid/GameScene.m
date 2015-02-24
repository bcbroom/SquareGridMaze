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

@property (strong, nonatomic) BBFace *playerFace;

@property (strong, nonatomic) BBFace *startFace;
@property (strong, nonatomic) BBFace *endFace;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    NSLog(@"scene size is (%f,%f)", self.size.width, self.size.height);
    
    self.grid = [[BBSquareGrid alloc] initWithWidth:5 andHeight:9];
    self.gridController = [[BBSquareGridController alloc] initWithGrid:self.grid width:5 height:9];
    
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
    
    UIImage *gridImage = [self.gridController renderGrid];
    SKTexture *gridTexture = [SKTexture textureWithImage:gridImage];
    self.gridSprite = [SKSpriteNode spriteNodeWithTexture:gridTexture];
    //gridSprite.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.gridSprite.position = CGPointMake(self.gridSprite.size.width/2, self.gridSprite.size.height/2);
    [self addChild:self.gridSprite];
    
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
    [self setupPlayer:player];
    [self addChild:player];
    player.zPosition = 1;
    
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
    self.gridController = [self.gridController initWithGrid:self.grid width:5 height:9];
    
    UIImage *gridImage = [self.gridController renderGrid];
    SKTexture *gridTexture = [SKTexture textureWithImage:gridImage];
    self.gridSprite.texture = gridTexture;
}


- (void)setupPlayer:(SKSpriteNode *)player {
    self.player = player;
    self.playerFace = [self.grid faceForColumn:0 andRow:0];
    
    [self updatePlayerPosition];
}

- (void)playerMoveNorth {
    CGPoint bounceDist = [self.gridController centerToWallDistance];
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
    CGPoint newPosition = [self.gridController pointForFaceCenter:self.playerFace];
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
