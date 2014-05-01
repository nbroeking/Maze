//
//  DrawableObject.m
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "DrawableObject.h"

@implementation DrawableObject
@synthesize projectionMatrix;
@synthesize modelMatrix;
@synthesize viewMatrix;
@synthesize normalMatrix;
@synthesize time;
@synthesize location;
-(id)init
{
    if(self = [super init])
    {
        self.time = 0.0;
        //numAttributes = 0;
        numUniforms = 9;
        for( int i = 0; i < numUniforms; i++)
        {
            uniforms[i] = 0;
        }
        //attributes = NULL;
        shader = 0;
    }
    return self;
}

-(void)draw
{
    NSLog(@"Drawing a drawable Object is not possible");
}

-(void)setMatries : (GLKMatrix4) projection : (GLKMatrix4) view
{
    //NSLog(@"Changed the matrix Values in the main");
    projectionMatrix = projection;
    viewMatrix = view;
}
-(void)dealloc
{
    glDeleteProgram(shader);
    
    NSLog(@"Deallocating a drawable Object");
    //[super dealloc];
    /*if(uniforms)
    {
        free(uniforms);
        uniforms = NULL;
    }*/
  /*  if(attributes)
    {
        free(attributes);
        attributes = NULL;
    }*/
}
-(void) update
{
    NSLog(@"Should never get called");
}
@end
