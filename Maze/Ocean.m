#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Ocean.h"
#import "WorldShader.h"
@interface Ocean ()
{
    GLKMatrix4 modelViewProjectionMatrix;
    GLuint buffer;
    GLuint array;
    
    float dimention;
    
    GLKTextureInfo *texture;
    
    GLKVector3 lightPos;
    
    GLKMatrix4 lightMatrix;
    
    
}
@end;
@implementation Ocean

-(id)init
{
    if(self = [super init])
    {
        dimention = 200.0;
        NSLog(@"Initilizing the Ocean");
        numUniforms = 2;
        //numAttributes = 3;
        numCoord = 24;
        
        
        //attributes = malloc( sizeof(int)*numAttributes);
        
        GLfloat coord[numCoord*8];
        //coord = malloc(sizeof(float)*numCoord*8);
        
        shader = [NicShader loadShaders:@"Base"];
        
        if( shader < 1)
        {
            NSLog(@"Shader is a failure");
        }
        uniforms[0] = glGetUniformLocation(shader, "modelViewProjectionMatrix");
        uniforms[1] = glGetUniformLocation(shader, "Texture");
        uniforms[2] = glGetUniformLocation(shader, "modelMatrix");
        uniforms[3] = glGetUniformLocation(shader, "viewMatrix");
        uniforms[4] = glGetUniformLocation(shader, "normalMatrix");
        uniforms[5] = glGetUniformLocation(shader, "lightPos");
        uniforms[6] = glGetUniformLocation(shader, "eyePos");
        uniforms[7] = glGetUniformLocation(shader, "Texture1");
        uniforms[8] = glGetUniformLocation(shader, "Texture2");
        //Now we calculate whats in the world.
        
        self.projectionMatrix = self.viewMatrix = self.modelMatrix = modelViewProjectionMatrix = GLKMatrix4Identity;
        
        //Get the textures
        //----------------------------------
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"sand" ofType:@"png"]; // 1
        
        NSError *error = [[NSError alloc] init];
        texture = [GLKTextureLoader textureWithContentsOfFile:filePath1 options:@{GLKTextureLoaderGenerateMipmaps:[NSNumber numberWithBool:YES]} error:&error]; // 2
        glBindTexture(texture.target, texture.name); // 3
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        
        
        GLfloat temp[24*8] = {
            
            //Side to Side
            -122, 0 , -122, 0, 1, 0, 0, 0,
            -122, 6, -122, 0, 1, 0, 1, 0,
            -122, 6, 123, 0, 1, 0, 1, 49,
            
            -122, 0 , -122, 0, 1, 0, 0, 0,
            -122, 0, 123, 0, 1, 0, 1, 49,
            -122, 6, 123, 0, 1, 0, 0, 49,
            
            -122, 0 , -122, 0, 1, 0, 0, 0,
            -122, 6, -122, 0, 1, 0, 1, 0,
            123, 6, -122, 0, 1, 0, 1, 49,
            
            -122, 0 , -122, 0, 1, 0, 0, 0,
            123, 0, -122, 0, 1, 0, 1, 49,
            123, 6, -122, 0, 1, 0, 0, 49,
            
            //
            123, 0 , 123, 0, 1, 0, 0, 0,
            123, 6, 123, 0, 1, 0, 1, 0,
            -122, 6, 123, 0, 1, 0, 1, 49,
            
            123, 0 , 123, 0, 1, 0, 0, 0,
            -122, 0, 123, 0, 1, 0, 1, 49,
            -122, 6, 123, 0, 1, 0, 0, 49,
            
            
            123, 0 , 123, 0, 1, 0, 0, 0,
            123, 6, 123, 0, 1, 0, 1, 0,
            123, 6, -122, 0, 1, 0, 1, 49,
            
            123, 0 , 123, 0, 1, 0, 0, 0,
            123, 0, -122, 0, 1, 0, 1, 49,
            123, 6, -122, 0, 1, 0, 0, 49,
            
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
    modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix));
    //self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix)), NULL);
    self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(self.modelMatrix), NULL);
    //NSLog(@"Updated the Matricies");
}

-(void)draw
{
    //NSLog(@"Drawing the shape");
    
    glUseProgram(shader);
    glBindVertexArrayOES(array);

    glUniformMatrix4fv(uniforms[0], 1, 0, modelViewProjectionMatrix.m);
    glUniform1i(uniforms[1], 0);
    glUniformMatrix4fv(uniforms[2], 1, 0, self.modelMatrix.m);
    glUniformMatrix4fv(uniforms[3], 1, 0, self.viewMatrix.m);
    glUniformMatrix3fv(uniforms[4], 1, 0, self.normalMatrix.m);
    glUniform4fv(uniforms[5], 1, lightPos.v);
    
    glUniform3fv(uniforms[6], 1, self.location.v);
    glUniform1i(uniforms[7], 0);
    glUniform1i(uniforms[8], 0);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(texture.target, texture.name);
    glDrawArrays(GL_TRIANGLES, 0, numCoord);
    
   // NSLog(@"Pos = < %f, %f, %f >", self.location.x, self.location.y, self.location.z);
    
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
