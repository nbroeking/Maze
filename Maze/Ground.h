//
//  Ground.h
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//
#import "DrawableObject.h"
#import <Foundation/Foundation.h>
#import "WorldShader.h"


@interface Ground : DrawableObject
@property GLKMatrix4 modelViewProjectionMatrix;

-(id)init;
-(void)dealloc;
//-(void)draw;
@end