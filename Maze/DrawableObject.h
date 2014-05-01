//
//  DrawableObject.h
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#import <Foundation/Foundation.h>
#import "NicShader.h"

@interface DrawableObject : NSObject
{
    @protected GLint numUniforms;
    @protected  GLint uniforms[9];
    @protected GLint numCoord;
    @protected GLint shader;
}

@property GLKMatrix4 projectionMatrix;
@property GLKMatrix4 viewMatrix;
@property GLKMatrix4 modelMatrix;
@property GLKMatrix3 normalMatrix;
@property GLKVector3 location;

@property float time;

-(void) update;
-(void)setMatries : (GLKMatrix4) projection : (GLKMatrix4) view;
-(id)init;
-(void)draw;
-(void)dealloc;
@end
