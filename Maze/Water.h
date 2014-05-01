//
//  Water.h
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 4/9/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "DrawableObject.h"
#import <Foundation/Foundation.h>
#import "WorldShader.h"

@interface Water : DrawableObject
@property GLKMatrix4 modelViewProjectionMatrix;
-(id)init;
-(void)dealloc;

@end
