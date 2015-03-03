//
//  VertexTests.m
//  Grid
//
//  Created by Brian Broom on 2/26/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBSquareGrid.h"
#import "BBVertex.h"

@interface VertexTests : XCTestCase

@property (strong,nonatomic) BBSquareGrid *grid;

@end

@implementation VertexTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.grid = [BBSquareGrid new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVertexFromColumnAndRow {
    BBVertex *vertex = [self.grid vertexForColumn:2 andRow:1];
    
    XCTAssertNotNil(vertex);
    XCTAssertEqual(2, vertex.column);
    XCTAssertEqual(1, vertex.row);
}

- (void)testKeyForVertex {
    BBVertex *vertex = [self.grid vertexForColumn:2 andRow:1];
    NSString *key = [vertex key];
    XCTAssertEqualObjects(key, @"Vertex::2::1");
}

- (void)testFaceBackpointerToGrid {
    for (BBVertex *vert in [self.grid allVertices]) {
        XCTAssertEqualObjects(self.grid, vert.grid);
    }
}
@end
