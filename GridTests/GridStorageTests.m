//
//  GridStorageTests.m
//  Grid
//
//  Created by Brian Broom on 2/28/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBSquareGrid.h"
#import "BBFace.h"
#import <SpriteKit/SpriteKit.h>

@interface GridStorageTests : XCTestCase

@property (strong, nonatomic) BBSquareGrid *grid;
@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) SKSpriteNode *goal;

@end

@implementation GridStorageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.grid = [BBSquareGrid new];
    
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    self.player = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(20, 20)];
    self.goal = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(20, 20)];
    [self.grid setFace:face forObject:self.player];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFaceForObject {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    
    BBFace *result = [self.grid faceForObject:self.player];
    
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(face, result);
}

@end
