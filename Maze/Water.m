//
//  Water.m
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 4/9/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import "Water.h"
@interface Water ()
{
    GLuint buffer;
    GLuint array;
    
    GLuint pbuffer;
    GLuint parray;
    
    GLKTextureInfo *texture;
    
    GLKVector3 lightPos;
    GLuint pointShader;
    
    GLKMatrix4 lightMatrix;
    
    //First
    
}
@end;

@implementation Water
@synthesize modelViewProjectionMatrix;

-(id)init
{
    
    if( self = [super init])
    {
        
        NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"Water" ofType:@"png"]; // 1
        
        NSError *error = [[NSError alloc] init];
        texture = [GLKTextureLoader textureWithContentsOfFile:filePath3 options:@{GLKTextureLoaderGenerateMipmaps:[NSNumber numberWithBool:YES]} error:&error]; // 2
        glBindTexture(texture.target, texture.name); // 3
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
        
        numUniforms = 9;
        numCoord = 14406;
        GLfloat coord[numCoord*8];
        
        int i = 0;
        
        for( int x = 0; x < 49; x +=1)
        {
            for( int y = 0; y < 49; y+=1)
            {
                coord[i] = (double)x*5;
                coord[i+1] = 6;
                coord[i+2] =(double)y*5;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 0.0;
                coord[i+7] = 0.0;
                i+= 8;
                
                
                coord[i] = (double)(x+1)*5;
                coord[i+1] = 6;
                coord[i+2] = (double)y*5;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 1.0;
                coord[i+7] = 0.0;
                i+= 8;
          
                coord[i] = (double)(x+1)*5;
                coord[i+1] =  6;
                coord[i+2] =(double)(y+1)*5;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 1.0;
                coord[i+7] = 1.0;
                i+= 8;

                //First
                coord[i] = (double)x*5;
                coord[i+1] = 6;
                coord[i+2] =(double)y*5;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 0.0;
                coord[i+7] = 0.0;
                i+= 8;
                
        
                coord[i] = (double)(x)*5;
                coord[i+1] = 6;
                coord[i+2] = (double)(y+1)*5;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 0.0;
                coord[i+7] = 1.0;
                i+= 8;
              
                coord[i] =(double)(x+1)*5;
                coord[i+1] = 6.0;
                coord[i+2]  = (double)(y+1)*5;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 1.0;
                coord[i+7] = 1.0;
                i+= 8;
                //i+= 6*8;
                
            }
        }
        
        //NSLog(@"i = %d", i);
        
        //Get the shader
       shader = [NicShader loadShaders:@"Water"];
        //Get the uniforms
        uniforms[0] = glGetUniformLocation(shader, "modelViewProjectionMatrix");
        uniforms[1] = glGetUniformLocation(shader, "Texture");
        uniforms[2] = glGetUniformLocation(shader, "modelMatrix");
        uniforms[3] = glGetUniformLocation(shader, "viewMatrix");
        uniforms[4] = glGetUniformLocation(shader, "normalMatrix");
        uniforms[5] = glGetUniformLocation(shader, "lightPos");
        uniforms[6] = glGetUniformLocation(shader, "eyePos");
        uniforms[7] = glGetUniformLocation(shader, "time");
        
        
        //Initilize the everything
        self.modelMatrix = GLKMatrix4MakeTranslation(-245/2, 0.0, -245/2);
        self.viewMatrix = GLKMatrix4Identity;
        self.projectionMatrix = GLKMatrix4Identity;
        
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
        
        //free(coord);

    }
    return self;
}
-(void)update
{
    //double deg = 3.1415927/180;
    
    modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix));
    //self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix)), NULL);
    self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(self.modelMatrix), NULL);
   
}

-(void)draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    //NSLog(@"Drawing the shape");
    glUseProgram(shader);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(texture.target, texture.name);
    /*
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(texture1.target, texture1.name);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(texture2.target, texture2.name);*/
    
    glBindVertexArrayOES(array);
    glUniformMatrix4fv(uniforms[0], 1, 0, modelViewProjectionMatrix.m);
    
    glUniform1i(uniforms[1], 0);
    glUniformMatrix4fv(uniforms[2], 1, 0, self.modelMatrix.m);
    glUniformMatrix4fv(uniforms[3], 1, 0, self.viewMatrix.m);
    glUniformMatrix3fv(uniforms[4], 1, 0, self.normalMatrix.m);
    glUniform4fv(uniforms[5], 1, lightPos.v);
    glUniform3fv(uniforms[6], 1, self.location.v);
    glUniform1f(uniforms[7], self.time);
    
    glDrawArrays(GL_TRIANGLES, 0, numCoord);
    
    glDisable(GL_BLEND);
    
}
-(void)dealloc
{
    glDeleteBuffers(1, &(buffer));
    glDeleteProgram(shader);
    glDeleteBuffers(1, &(array));
}
@end
