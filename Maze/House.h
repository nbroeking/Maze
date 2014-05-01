//
//  House.h
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 4/26/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "DrawableObject.h"

@interface House : DrawableObject
@property GLKMatrix4 modelViewProjectionMatrix;

-(id)init;
-(void)dealloc;
//-(void)draw;
@end
