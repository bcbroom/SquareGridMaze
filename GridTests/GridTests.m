//
//  GridTests.m
//  Grid
//
//  Created by Brian Broom on 2/26/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBSquareGrid.h"
#import "BBFace.h"

@interface GridTests : XCTestCase

@property (strong, nonatomic) BBSquareGrid *grid;

@end

@implementation GridTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.grid = [BBSquareGrid new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFaceForColumnAndRow {
    BBFace *face = [self.grid faceForColumn:2 andRow:3];
    XCTAssertEqual(face.column, 2);
    XCTAssertEqual(face.row, 3);
}

- (void)testColumnOutOfBounds {
    XCTAssertNil([self.grid faceForColumn:self.grid.width andRow:0]);
    XCTAssertNil([self.grid faceForColumn:-1 andRow:0]);
}

- (void)testRowOutOfABounds {
    XCTAssertNil([self.grid faceForColumn:0 andRow:self.grid.height]);
    XCTAssertNil([self.grid faceForColumn:0 andRow:-1]);
}

- (void)testAllFaceCount {
    XCTAssertEqual([self.grid allFaces].count, self.grid.height * self.grid.width);
}

- (void)testAllEdgeCount {
    NSInteger numEdges = self.grid.width * self.grid.height * 2 + self.grid.height + self.grid.width;
    XCTAssertEqual([[self.grid allEdges] count], numEdges);
}

- (void)testAllVertexCount {
    NSInteger numVerts = self.grid.width * self.grid.height + self.grid.height + self.grid.width + 1;
    XCTAssertEqual([[self.grid allVertices] count], numVerts);
}

- (void)testFaceForKey {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    NSString *key = [face key];
    XCTAssertEqualObjects(face, [self.grid faceForKey:key]);
}

- (void)testVerticesForSEdge {
    BBEdge *edge = [self.grid edgeForColumn:2 andRow:1 andSide:@"S"];
    NSArray *verts = [self.grid endpointsForEdge:edge];
    XCTAssertEqual(verts.count, 2);
    XCTAssert([verts containsObject:[self.grid vertexForColumn:edge.column andRow:edge.row]]);
    XCTAssert([verts containsObject:[self.grid vertexForColumn:edge.column + 1 andRow:edge.row]]);
}

- (void)testVerticesForWEdge {
    BBEdge *edge = [self.grid edgeForColumn:2 andRow:1 andSide:@"W"];
    NSArray *verts = [self.grid endpointsForEdge:edge];
    XCTAssertEqual(verts.count, 2);
    XCTAssert([verts containsObject:[self.grid vertexForColumn:edge.column andRow:edge.row]]);
    XCTAssert([verts containsObject:[self.grid vertexForColumn:edge.column andRow:edge.row + 1]]);
}

@end
