//
//  GridTests.m
//  GridTests
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBSquareGrid.h"
#import "BBFace.h"

@interface FaceTests : XCTestCase

@property (strong, nonatomic) BBSquareGrid *grid;

@end

@implementation FaceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.grid = [BBSquareGrid new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testFaceFromColumnAndRow {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    
    XCTAssertNotNil(face);
    XCTAssertEqual(2, face.column);
    XCTAssertEqual(1, face.row);
}



- (void)testCentralFaceNeighborCount {
    BBFace *face = [self.grid faceForColumn:1 andRow:1];
    NSArray *neighbors = face.neighbors;
    XCTAssertEqual(neighbors.count, 4);
}

- (void)testEdgeFaceNeighborCount {
    BBFace *face = [self.grid faceForColumn:1 andRow:3];
    NSArray *neighbors = face.neighbors;
    XCTAssertEqual(neighbors.count, 3);
}

- (void)testCornerFaceNeighborCount {
    BBFace *face = [self.grid faceForColumn:2 andRow:3];
    NSArray *neighbors = face.neighbors;
    XCTAssertEqual(neighbors.count, 2);
}

- (void)testFaceConnections {
    BBFace *centralFace = [self.grid faceForColumn:1 andRow:1];
    BBFace *expectedEast = [self.grid faceForColumn:2 andRow:1];
    BBFace *expectedSouth = [self.grid faceForColumn:1 andRow:0];
    BBFace *expectedWest = [self.grid faceForColumn:0 andRow:1];
    BBFace *expectedNorth = [self.grid faceForColumn:1 andRow:2];
    
    XCTAssertEqualObjects(centralFace.eastFace, expectedEast);
    XCTAssertEqualObjects(centralFace.southFace, expectedSouth);
    XCTAssertEqualObjects(centralFace.westFace, expectedWest);
    XCTAssertEqualObjects(centralFace.northFace, expectedNorth);
}

- (void)testFaceConnectionsNilOnEdgeAndCorner {
    BBFace *bottomEdgeFace = [self.grid faceForColumn:1 andRow:0];
    XCTAssertNil(bottomEdgeFace.southFace);
    
    BBFace *bottomLeftCornerFace = [self.grid faceForColumn:0 andRow:0];
    XCTAssertNil(bottomLeftCornerFace.westFace);
    
    BBFace *upperRightCornerFace = [self.grid faceForColumn:2 andRow:3];
    XCTAssertNil(upperRightCornerFace.northFace);
    XCTAssertNil(upperRightCornerFace.eastFace);
}

- (void)testKeyForFace {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    NSString *key = [face key];
    XCTAssertEqualObjects(key, @"Face::2::1");
}

- (void)testKeyForColumnAndRow {
    NSString *testKey = [BBFace keyForFaceWithColumn:2 andRow:1];
    XCTAssertEqualObjects(testKey, @"Face::2::1");
}

- (void)testFaceBackpointerToGrid {
    for (BBFace *face in [self.grid allFaces]) {
        XCTAssertEqualObjects(self.grid, face.grid);
    }
}

@end
