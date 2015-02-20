//
//  BBFace.h
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBEdge;
@class BBVertex;

@interface BBFace : NSObject

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;

@property (strong, nonatomic) NSMutableArray *neighbors;
@property (strong, nonatomic) NSMutableArray *edges;
@property (strong, nonatomic) NSMutableArray *vertices;

@property (strong, nonatomic) BBFace *northFace;
@property (strong, nonatomic) BBFace *eastFace;
@property (strong, nonatomic) BBFace *southFace;
@property (strong, nonatomic) BBFace *westFace;

@property (strong, nonatomic) BBEdge *northEdge;
@property (strong, nonatomic) BBEdge *eastEdge;
@property (strong, nonatomic) BBEdge *southEdge;
@property (strong, nonatomic) BBEdge *westEdge;

@property (strong, nonatomic) BBVertex *northEastVertex;
@property (strong, nonatomic) BBVertex *southEastVertex;
@property (strong, nonatomic) BBVertex *southWestVertex;
@property (strong, nonatomic) BBVertex *northWestVertex;

+ (instancetype)edgeWithColumn:(NSInteger)column andRow:(NSInteger)row;
- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row;

@end
