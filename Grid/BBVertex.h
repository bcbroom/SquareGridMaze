//
//  BBVertex.h
//  Grid
//
//  Created by Brian Broom on 2/12/15.
//  Copyright (c) 2015 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBVertex : NSObject

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;

+ (instancetype)vertexWithColumns:(NSInteger)column andRow:(NSInteger)row;
- (instancetype)initWithColumn:(NSInteger)column andRow:(NSInteger)row;

@end
