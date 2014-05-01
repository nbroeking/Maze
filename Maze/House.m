//
//  House.m
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 4/26/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "House.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@interface House()
{
    GLuint buffer;
    GLuint array;
    
    GLuint pbuffer;
    GLuint parray;
    
    GLKTextureInfo *texture;
    GLKTextureInfo *texture1;
    GLKTextureInfo *texture2;
    
    GLKVector3 lightPos;
    
    GLKMatrix4 lightMatrix;
    
    
}
@end;

@implementation House
@synthesize modelViewProjectionMatrix;
-(id)init
{
    if(self = [super init])
    {
        numUniforms = 9;
        
        NSLog(@"Initilizing the House");
        
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"building" ofType:@"png"]; // 1
        
        NSError *error = [[NSError alloc] init];
        texture = [GLKTextureLoader textureWithContentsOfFile:filePath1 options:@{GLKTextureLoaderGenerateMipmaps:[NSNumber numberWithBool:YES]} error:&error]; // 2
        glBindTexture(texture.target, texture.name); // 3
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        
        
        //DirtTexture
        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"Roof" ofType:@"png"]; // 1
        
        error = [[NSError alloc] init];
        texture1 = [GLKTextureLoader textureWithContentsOfFile:filePath2 options:@{GLKTextureLoaderGenerateMipmaps:[NSNumber numberWithBool:YES]} error:&error]; // 2
        glBindTexture(texture1.target, texture1.name); // 3
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        
        
        if( !texture || !texture1)
        {
            NSLog(@"Error Loading Texture");
            //NSLog(@"%@", error);
        }
        //int numIslandPoints = 6;
        //numAttributes = 3;
        numCoord = 42;
        
        //
        
      /*  GLfloat coord2[394];
        int i = 0;
        for( int th = 0; th < 360; th+=5)
        {
            coord2[i] = (double) cos(th);
            coord2[i+1] = 0;
            coord2[i+2] = (double) sin(th);
            coord2[i+3] = (double) cos(th);
            coord2[i+4] = 0;
            coord2[i+5] = (double) sin(th);
            coord2[i+6] = (th/4)%360;
            coord2[i+7] = 0;
            i+= 8;
            
            coord2[i] = (double) cos(th);
            coord2[i+1] = 1.75;
            coord2[i+2] = (double) sin(th);
            coord2[i+3] = (double) cos(th);
            coord2[i+4] = 0;
            coord2[i+5] = (double) sin(th);
            coord2[i+6] = (th/4)%360;
            coord2[i+7] = 7;
            i+= 8;
            
            coord2[i] = (double) cos(th+5);
            coord2[i+1] = 1.75;
            coord2[i+2] = (double) sin(th+5);
            coord2[i+3] = (double) cos(th+5);
            coord2[i+4] = 0;
            coord2[i+5] = (double) sin(th+5);
            coord2[i+6] = (th/4)%360;
            coord2[i+7] = 7;
            i+= 8;
            
            coord2[i] = (double) cos(th);
            coord2[i+1] = 0;
            coord2[i+2] = (double) sin(th);
            coord2[i+3] = (double) cos(th);
            coord2[i+4] = 0;
            coord2[i+5] = (double) sin(th);
            coord2[i+6] = (th/4)%360;
            coord2[i+7] = 0;
            i+= 8;
            
            coord2[i] = (double) cos(th+5);
            coord2[i+1] = 1.75;
            coord2[i+2] = (double) sin(th+5);
            coord2[i+3] = (double) cos(th+5);
            coord2[i+4] = 0;
            coord2[i+5] = (double) sin(th+5);
            coord2[i+6] = (th/4)%360;
            coord2[i+7] = 7;
            i+= 8;
            
            coord2[i] = (double) cos(th);
            coord2[i+1] = 1.75;
            coord2[i+2] = (double) sin(th);
            coord2[i+3] = (double) cos(th);
            coord2[i+4] = 0;
            coord2[i+5] = (double) sin(th);
            coord2[i+6] = (th/4)%360;
            coord2[i+7] = 7;
            i+= 8;
            
        }*/
        
        //NSLog(@"Num Coord = %d", i);
        
        //attributes = malloc( sizeof(int)*numAttributes);
        GLfloat coord[6*8*7] = {
            -1, 0, -1, -1, 0, 0, 0, 4,
            -1, 0, 1, -1, 0, 0, 4, 4,
            -1, 1, 1, -1, 0, 0, 4, 0,
            -1, 0, -1, -1, 0, 0, 0, 4,
            -1, 1, -1, -1, 0, 0, 0, 0,
            -1, 1, 1, -1, 0, 0, 4, 0,
            
            
            1, 0, -1, 1, 0, 0, 0, 4,
            1, 0, 1, 1, 0, 0, 4, 4,
            1, 1, 1, 1, 0, 0, 4, 0,
            1, 0, -1, 1, 0, 0, 0, 4,
            1, 1, -1, 1, 0, 0, 0, 0,
            1, 1, 1, 1, 0, 0, 4, 0,
            
            -1, 0, -1, 0, 0, -1, 0, 4,
            1, 0,  -1, 0, 0, -1, 4, 4,
            1, 1,  -1, 0, 0, -1, 4, 0,
            -1, 0, -1, 0, 0, -1, 0, 4,
            -1, 1, -1, 0, 0, -1, 0, 0,
            1, 1,  -1, 0, 0, -1, 4, 0,
            
            
            -1, 0, 1, 0, 0, 1, 0, 4,
            1, 0,  1, 0, 0, 1, 4, 4,
            1, 1,  1, 0, 0, 1, 4, 0,
            -1, 0, 1, 0, 0, 1, 0, 4,
            -1, 1, 1, 0, 0, 1, 0, 0,
            1, 1,  1, 0, 0, 1, 4, 0,
            
            //Roof

           -1, 1, -1, 0, .25, -1, 4, 4,
            -1, 1.25, 0, 0, .25, -1, 4, 0,
            1, 1.25, 0, 0, .25, -1, 0, 0,
            -1, 1, -1, 0, .25, -1, 4,4,
            1, 1.25, 0, 0, .25, -1, 0, 0,
            1, 1, -1, 0, .25, -1, 0, 4,
            
            -1, 1.25, 0, 0, .25, 1, 4, 4,
            -1, 1, 1, 0, .25, 1, 4, 0,
            1, 1, 1, 0, .25, 1, 0, 0,
            -1, 1.25, 0, 0, .25, 1, 4,4,
            1, 1, 1, 0, .25, 1, 0, 0,
            1, 1.25, 0, 0, .25, 1, 0, 4,
            
            
            -1, 1, -1, -1, 0, 0, 0, 0,
            -1, 1,  1, -1, 0, 0, 4, 0,
            -1, 1.25, 0, -1, 0,0, 2, -1,
            
            1, 1, -1, 1, 0, 0, 0, 0,
            1, 1,  1, 1, 0, 0, 4, 0,
            1, 1.25, 0, 1, 0, 0, 2, -1,
            
        };
        
        shader = [NicShader loadShaders:@"House"];
        
        uniforms[0] = glGetUniformLocation(shader, "modelViewProjectionMatrix");
        uniforms[1] = glGetUniformLocation(shader, "Texture");
        uniforms[2] = glGetUniformLocation(shader, "modelMatrix");
        uniforms[3] = glGetUniformLocation(shader, "viewMatrix");
        uniforms[4] = glGetUniformLocation(shader, "normalMatrix");
        uniforms[5] = glGetUniformLocation(shader, "lightPos");
        uniforms[6] = glGetUniformLocation(shader, "eyePos");
        
        //Now we calculate whats in the world.
        
        self.projectionMatrix = self.viewMatrix = self.modelMatrix = self.modelViewProjectionMatrix = GLKMatrix4Identity;
        self.normalMatrix = GLKMatrix3Identity;
        
        //Set up stuff
        
        self.modelMatrix = GLKMatrix4MakeScale(5, 5, 5);
        
        self.modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(-3, 13.5, -27),self.modelMatrix);
        
        
        modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix));
        
        lightPos = GLKVector3Make(-117.0,215.0,155.0);
        
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
    self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(self.modelMatrix), NULL);
    //self.normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix), NULL));
}
-(void)draw
{
    //NSLog(@"Drawing the House");
    glUseProgram(shader);
    
    glBindVertexArrayOES(array);
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(texture.target, texture.name);
    
    glUniformMatrix4fv(uniforms[0], 1, 0, modelViewProjectionMatrix.m);
    glUniform1i(uniforms[1], 0);
    glUniformMatrix4fv(uniforms[2], 1, 0, self.modelMatrix.m);
    glUniformMatrix4fv(uniforms[3], 1, 0, self.viewMatrix.m);
    glUniformMatrix3fv(uniforms[4], 1, 0, self.normalMatrix.m);
    glUniform4fv(uniforms[5], 1, lightPos.v);
    
    glUniform3fv(uniforms[6], 1, self.location.v);
    
    //NSLog(@"Open 4.5 gl Error = %d" , glGetError());
    
    glDrawArrays(GL_TRIANGLES, 0, 6*4);
    
    glBindTexture(texture1.target, texture1.name);
    
    glDrawArrays(GL_TRIANGLES, 6*4, 6*2);
    
    glBindTexture(texture.target, texture.name);
    glDrawArrays(GL_TRIANGLES, 6*4+6*2, 6);
    
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
