//
//  World.m
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "World.h"
@interface World ()
{
    GLKMatrix4 modelViewProjectionMatrix;
    GLuint buffer;
    GLuint array;
    
    float dimention;
    
    GLKTextureInfo *front;
    GLKTextureInfo *left;
    GLKTextureInfo *right;
    GLKTextureInfo *back;
    GLKTextureInfo *top;
    
}
@end;
@implementation World

-(id)init
{
    if(self = [super init])
    {
        dimention = 200.0;
        NSLog(@"Initilizing the world");
        numUniforms = 2;
        //numAttributes = 3;
        numCoord = 30;
        
    
        //attributes = malloc( sizeof(int)*numAttributes);
        
        GLfloat coord[numCoord*8];
        //coord = malloc(sizeof(float)*numCoord*8);
        
        shader = [WorldShader loadShaders:@"world"];
        
        if( shader < 1)
        {
            NSLog(@"Shader is a failure");
        }
        uniforms[0] = glGetUniformLocation(shader, "modelViewProjectionMatrix");
        uniforms[1] = glGetUniformLocation(shader, "Texture");
        //uniforms[2] = glGetUniformLocation(shader, "NormalMatrix");
        //Now we calculate whats in the world.
        
        self.projectionMatrix = self.viewMatrix = self.modelMatrix = modelViewProjectionMatrix = GLKMatrix4Identity;
        
        //Get the textures
        //----------------------------------
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"mountains_back" ofType:@"jpg"]; // 1
        
        NSError *error = [[NSError alloc] init];
        back = [GLKTextureLoader textureWithContentsOfFile:filePath1 options:nil error:&error]; // 2
        glBindTexture(back.target, back.name); // 3
        
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        
        //Get the front tex
        
        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"mountains_front" ofType:@"jpg"]; // 1
        
        front = [GLKTextureLoader textureWithContentsOfFile:filePath2 options:nil error:&error]; // 2
        glBindTexture(front.target, front.name); // 3
        
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        
        //Get the Left Tex
        NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"mountains_left" ofType:@"jpg"]; // 1
        
        left = [GLKTextureLoader textureWithContentsOfFile:filePath3 options:nil error:&error]; // 2
        glBindTexture(left.target, left.name); // 3
        
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        //Get the right Tex
        NSString *filePath4 = [[NSBundle mainBundle] pathForResource:@"mountains_right" ofType:@"jpg"]; // 1
        
        right = [GLKTextureLoader textureWithContentsOfFile:filePath4 options:nil error:&error]; // 2
        glBindTexture(right.target, right.name); // 3
        
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        //Get the top Tex
        NSString *filePath5 = [[NSBundle mainBundle] pathForResource:@"mountains_top" ofType:@"jpg"]; // 1
        
        top = [GLKTextureLoader textureWithContentsOfFile:filePath5 options:nil error:&error]; // 2
        glBindTexture(top.target, top.name); // 3
        
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        
        GLfloat temp[30*8] = {
            
            //Side to Side
            -dimention, -dimention + 15, -dimention, 1, 0, 0, 1, 1,
            -dimention, dimention +15, -dimention, 1, 0, 0, 1, 0,
            -dimention, dimention +15, dimention, 1, 0, 0, 0, 0,
            
            -dimention, -dimention +15, -dimention , 1, 0, 0, 1, 1,
            -dimention, dimention+15, dimention, 1, 0, 0, 0, 0,
            -dimention, -dimention+15, dimention, 1, 0, 0, 0, 1,
            
            dimention, -dimention+15, -dimention, -1, 0, 0, 0, 1,
            dimention, dimention+15, -dimention, -1, 0, 0, 0, 0,
            dimention, dimention+15, dimention, -1, 0, 0, 1, 0,
            
            dimention, -dimention+15, -dimention , -1, 0, 0, 0, 1,
            dimention, dimention+15, dimention, -1, 0, 0, 1, 0,
            dimention, -dimention+15, dimention, -1, 0, 0, 1, 1,
            
            //Front and back
            -dimention, -dimention+15, dimention, 0, 0, -1, 1, 1,
            -dimention, dimention+15, dimention, 0, 0, -1, 1, 0,
            dimention, dimention+15, dimention, 0, 0, -1, 0, 0,
            
            -dimention, -dimention+15, dimention, 0, 0, -1, 1, 1,
            dimention, dimention+15, dimention, 0, 0, -1, 0, 0,
            dimention, -dimention+15, dimention, 0, 0, -1, 0, 1,
            
            -dimention, -dimention+15, -dimention, 0, 0, 1, 0, 1,
            -dimention, dimention+15, -dimention, 0, 0, 1, 0, 0,
            dimention, dimention+15, -dimention, 0, 0, 1, 1, 0,
            
            -dimention, -dimention+15, -dimention, 0, 0, 1, 0, 1,
            dimention, dimention+15, -dimention, 0, 0, 1, 1, 0,
            dimention, -dimention+15, -dimention, 0, 0, 1, 1, 1,
            //Top
            
            -dimention, dimention+15, -dimention, 0, -1, 0, 1, 0,
            dimention, dimention+15, -dimention, 0, -1, 0, 0, 0,
            dimention, dimention+15, dimention, 0, -1, 0, 0, 1,
            
            -dimention, dimention+15, -dimention, 0, -1, 0, 1, 0,
            dimention, dimention+15, dimention, 0, -1, 0, 0, 1,
            -dimention, dimention+15, dimention, 0, -1, 0, 1, 1
            
        };
        
        //Transfer to real coordinates
        
        for( int i = 0; i < numCoord*8; i++)
        {
            coord[i] = temp[i];
        }
        
        self.modelMatrix = GLKMatrix4Identity;
        self.viewMatrix = GLKMatrix4Identity;
        self.projectionMatrix = GLKMatrix4Identity;
        
   
        modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix));

        
        glGenVertexArraysOES(1, &array);
        glBindVertexArrayOES(array);
        
        glGenBuffers(1, &buffer);
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(coord), coord, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
        //glEnableVertexAttribArray(GLKVertexAttribNormal);
        //glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
        
        glBindVertexArrayOES(0);
        
    }
    
    return self;
}
-(void)update
{
    modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix));
    
    //NSLog(@"Updated the Matricies");
}

-(void)draw
{
    //NSLog(@"Drawing the shape");
    
    glUseProgram(shader);
    glBindVertexArrayOES(array);
    glUniformMatrix4fv(uniforms[0], 1, 0, modelViewProjectionMatrix.m);
    glUniform1i(uniforms[1], 0);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(right.target, right.name);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindTexture(left.target, left.name);
    
    glDrawArrays(GL_TRIANGLES, 6, 6);
    
    glBindTexture(front.target, front.name);
    
    glDrawArrays(GL_TRIANGLES, 12, 6);
    
    glBindTexture(back.target, back.name);
    glDrawArrays(GL_TRIANGLES, 18, 6);
    
    glBindTexture(top.target, top.name);
  
    glDrawArrays(GL_TRIANGLES, 24, 6);

    glBindVertexArrayOES(0);
}

-(void)dealloc
{
    //[super dealloc];
    NSLog(@"Deallocating the world");
    glDeleteBuffers(1, &(buffer));
    glDeleteProgram(shader);
    glDeleteBuffers(1, &(array));
    
  /*  if(uniforms)
    {
        free(uniforms);
        uniforms=NULL;
    }*/
    /*if( coord)
    {
        free(coord);
        coord = NULL;
    }*/
}
@end
