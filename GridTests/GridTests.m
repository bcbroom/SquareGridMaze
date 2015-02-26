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

- (void)testCountAllFaces {
    NSArray *faces = [self.grid allFaces];
    XCTAssertEqual(faces.count, 12);
}

- (void)testAllEdgesCount {
    XCTAssertEqual(self.grid.allEdges.count, 31);
}

- (void)testFaceForKey {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    NSString *key = [face key];
    XCTAssertEqualObjects(face, [self.grid faceForKey:key]);
}

- (void)testFaceForString {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    [self.grid setFace:face forString:@"object"];
    
    XCTAssertEqualObjects(face, [self.grid faceForString:@"object"]);
}

- (void)testUpdateFaceForString {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    [self.grid setFace:face forString:@"object"];
    BBFace *updateFace = [self.grid faceForColumn:2 andRow:2];
    [self.grid setFace:updateFace forString:@"object"];
    
    XCTAssertEqualObjects(updateFace, [self.grid faceForString:@"object"]);
}

- (void)testRemoveFaceForString {
    BBFace *face = [self.grid faceForColumn:2 andRow:1];
    [self.grid setFace:face forString:@"object"];
    [self.grid removeFaceForString:@"object"];
    
    XCTAssertNil([self.grid faceForString:@"object"]);
}


@end
