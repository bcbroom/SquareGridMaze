//
//  GameScene.m
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import "GameScene.h"
#import "BBSquareGridController.h"


@interface GameScene ()

@property (strong, nonatomic) BBSquareGridController *gridController;
@property (strong, nonatomic) SKSpriteNode *gridSprite;
@property (strong, nonatomic) UISwipeGestureRecognizer *upSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *downSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipeRecognizer;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    NSLog(@"scene size is (%f,%f)", self.size.width, self.size.height);
    
    self.gridController = [[BBSquareGridController alloc] initWithGridOfWidth:5 andHeight:9];
    
    UIImage *gridImage = [self.gridController renderGrid];
    SKTexture *gridTexture = [SKTexture textureWithImage:gridImage];
    self.gridSprite = [SKSpriteNode spriteNodeWithTexture:gridTexture];
    //gridSprite.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.gridSprite.position = CGPointMake(self.gridSprite.size.width/2, self.gridSprite.size.height/2);
    [self addChild:self.gridSprite];
    
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
    [self.gridController setupPlayer:player];
    [self addChild:player];
    player.zPosition = 1;
    
    self.upSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.gridController action:@selector(playerMoveNorth)];
    self.upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.upSwipeRecognizer];
    
    self.downSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.gridController action:@selector(playerMoveSouth)];
    self.downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.downSwipeRecognizer];
    
    self.leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.gridController action:@selector(playerMoveWest)];
    self.leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeRecognizer];
    
    self.rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.gridController action:@selector(playerMoveEast)];
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
    self.gridController = [self.gridController initWithGridOfWidth:5 andHeight:9];
    
    UIImage *gridImage = [self.gridController renderGrid];
    SKTexture *gridTexture = [SKTexture textureWithImage:gridImage];
    self.gridSprite.texture = gridTexture;
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
////    for (UITouch *touch in touches) {
////        CGPoint location = [touch locationInNode:self];
////        
////        if (location.y > self.size.height / 2) {
////            NSLog(@"Move up");
////            [self.gridController playerMoveUp];
////        }
////        
////        if (location.y < self.size.height / 2) {
////            NSLog(@"Move down");
////            [self.gridController playerMoveDown];
////        }
////        
////    }
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
