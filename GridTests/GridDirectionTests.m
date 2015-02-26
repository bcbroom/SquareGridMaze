//
//  GridDirectionTests.m
//  Grid
//
//  Created by Brian Broom on 2/26/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BBSquareGrid.h"
#import "BBFace.h"

@interface GridDirectionTests : XCTestCase

@property (strong, nonatomic) BBSquareGrid *grid;

@end

@implementation GridDirectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.grid = [BBSquareGrid new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAdjacentFaceInDirection {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    
    // adjacent faces
    // east is nil, since (2,1) is on the right edge
    BBFace *northFace = [self.grid faceAdjacentToFace:face inDirection:BBSquareGridDirectionNorth];
    BBFace *eastFace = [self.grid faceAdjacentToFace:face inDirection:BBSquareGridDirectionEast];
    BBFace *southFace = [self.grid faceAdjacentToFace:face inDirection:BBSquareGridDirectionSouth];
    BBFace *westFace = [self.grid faceAdjacentToFace:face inDirection:BBSquareGridDirectionWest];
    
    
    XCTAssertEqualObjects([self.grid faceForColumn:2 andRow:2], northFace);
    XCTAssertNil(eastFace);
    XCTAssertEqualObjects([self.grid faceForColumn:2 andRow:0], southFace);
    XCTAssertEqualObjects([self.grid faceForColumn:1 andRow:1], westFace);
}

@end
