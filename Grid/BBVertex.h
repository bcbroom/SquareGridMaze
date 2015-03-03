//
//  BBVertex.h
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBSquareGrid;
@class SKSpriteNode;

@interface BBVertex : NSObject

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;
@property (strong, nonatomic) SKSpriteNode *sprite;

@property (weak, nonatomic) BBSquareGrid *grid;

+ (instancetype)vertexWithColumns:(NSInteger)column andRow:(NSInteger)row;
+ (NSString *)keyForVertexWithColumn:(NSInteger)column andRow:(NSInteger)row;

- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row;
- (NSString *)key;

@end
