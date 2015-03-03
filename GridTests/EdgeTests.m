//
//  EdgeTests.m
//  Grid
//
//  Created by Brian Broom on 2/13/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBSquareGrid.h"
#import "BBFace.h"

@interface EdgeTests : XCTestCase

@property (strong, nonatomic) BBSquareGrid *grid;

@end

@implementation EdgeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.grid = [BBSquareGrid new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCentralFaceEdgeCount {
    BBFace *face = [self.grid faceForColumn:1 andRow:1];
    XCTAssertEqual(face.edges.count, 4);
}

- (void)testSharedEdgeEquality {
    BBFace *leftFace = [self.grid faceForColumn:1 andRow:1];
    BBFace *rightFace = [self.grid faceForColumn:2 andRow:1];

    NSMutableSet *leftFaceEdges = [NSMutableSet setWithArray:leftFace.edges];
    NSMutableSet *rightFaceEdges = [NSMutableSet setWithArray:rightFace.edges];
    [leftFaceEdges intersectSet:rightFaceEdges];
    XCTAssertEqual(leftFaceEdges.count, 1);
}

- (void)testNonAdjacentFacesDontShareEdges {
    BBFace *faceOne = [self.grid faceForColumn:1 andRow:1];
    BBFace *faceTwo = [self.grid faceForColumn:1 andRow:3];
    
    NSMutableSet *faceOneEdges = [NSMutableSet setWithArray:faceOne.edges];
    NSMutableSet *faceTwoEdges = [NSMutableSet setWithArray:faceTwo.edges];
    [faceOneEdges intersectSet:faceTwoEdges];
    XCTAssertEqual(faceOneEdges.count, 0);
}

- (void)testKey {
    BBEdge *edge = [self.grid edgeForColumn:2 andRow:1 andSide:@"W"];
    XCTAssertEqualObjects(edge.key, @"Edge::2::1::W");
}

- (void)testFaceBackpointerToGrid {
    for (BBEdge *edge in [self.grid allEdges]) {
        XCTAssertEqualObjects(self.grid, edge.grid);
    }
}





@end
