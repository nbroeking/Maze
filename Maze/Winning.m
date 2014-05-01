//
//  Winning.m
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 4/23/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "Winning.h"
#include <stdlib.h>

@interface Winning ()
{
    GLuint buffer;
    GLuint array;
        
    GLKTextureInfo *texture;
    
    GLKVector3 lightPos;
}
@end;
@implementation Winning
@synthesize modelViewProjectionMatrix;

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"Initilizing the particle system!");
        numCoord = 100;
        
        GLfloat coord[numCoord*8];
        
        //double deg = deg = 3.1415927/180;
        for( int i = 0; i < numCoord*8; i+=8)
        {

            //int r = arc4random() % 10;
            double r = arc4random() % 5;
            double ph = arc4random() % 360;
            double th = arc4random() % 90;
            
            coord[i] = ph;
            coord[i+1] = th;
            coord[i+2] = r;
            
            coord[i+3] = 0;
            coord[i+4] = 0;
            coord[i+5] = 0;
            
            coord[i+6] = 0;
            coord[i+7] = 0;
        }
        
        self.modelMatrix = GLKMatrix4MakeTranslation(-45, 10, -60);
        self.viewMatrix = GLKMatrix4Identity;
        self.projectionMatrix = GLKMatrix4Identity;
        
        
        modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix));
        shader = [NicShader loadShaders:@"particle"];
        
        uniforms[0] = glGetUniformLocation(shader, "modelViewProjectionMatrix");
        uniforms[1] = glGetUniformLocation(shader, "Time");
        uniforms[2] = glGetUniformLocation(shader, "eyePos");
        uniforms[3] = glGetUniformLocation(shader, "modelMatrix");
        
        glGenVertexArraysOES(1, &array);
        glBindVertexArrayOES(array);
        
        glGenBuffers(1, &buffer);
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(coord), coord, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
        
        glBindVertexArrayOES(0);
    }
    return self;
}
-(void)update
{
    //double deg = 3.1415927/180;
    
    modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix));
    //self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix)), NULL);
    //self.normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix), NULL));
    //NSLog(@"Updated the Matricies for the ground.");
    
    /*double x=25*cos(deg*self.time*50);
     double y= 20.0;
     double z = 25*sin(deg*self.time*50);
     lightMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, GLKMatrix4MakeTranslation(x, y, z)));*/
    
    
    //NSLog(@"Time = %f" ,self.time);
    // lightPos = GLKVector3Make(x, y, z);
    
    
    //GLKVector3 answer = GLKMatrix3MultiplyVector3(self.normalMatrix, GLKVector3Make(0, 25, 0));
    
    // NSLog(@"LightPos = < %f, %f, %f >", answer.x, answer.y, answer.z);
    //NSLog(@"Time = %f", self.time);
}

-(void)draw
{
    //NSLog(@"Drawing the shape");
    glUseProgram(shader);
    
    glBindVertexArrayOES(array);
    
    glUniformMatrix4fv(uniforms[0], 1, 0, modelViewProjectionMatrix.m);
    glUniform1f(uniforms[1], self.time);
    //NSLog(@"Open 4 gl Error = %d" , glGetError());
    glUniform3fv(uniforms[2], 1, self.location.v);
    glUniformMatrix4fv(uniforms[3], 1, 0, self.modelMatrix.m);
    
   // NSLog(@"Open 4.5 gl Error = %d" , glGetError());
    
    glDrawArrays(GL_POINTS, 0, numCoord);
    
    //NSLog(@"Po1 = < %f, %f, %f >", self.location.x, self.location.y, self.location.z);
    
}

-(void)dealloc
{
    //[super dealloc];
    NSLog(@"Deallocating the ground");
    
    glDeleteBuffers(1, &(buffer));
    glDeleteProgram(shader);
    glDeleteBuffers(1, &(array));
    
    /* if(uniforms)
     {
     free(uniforms);
     uniforms=NULL;
     }*/
    /* if( coord)
     {
     free(coord);
     coord = NULL;
     }*/
}

@end
