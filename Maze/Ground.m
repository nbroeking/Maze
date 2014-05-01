//
//  Ground.m
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Ground.h"
@interface Ground ()
{
    GLuint buffer;
    GLuint array;
    
    GLuint pbuffer;
    GLuint parray;
    
    GLKTextureInfo *texture;
    GLKTextureInfo *texture1;
    GLKTextureInfo *texture2;
    
    GLKVector3 lightPos;
    GLuint pointShader;
    
    GLKMatrix4 lightMatrix;
    
    GLint puniforms[6];

}
@end;
@implementation Ground
@synthesize modelViewProjectionMatrix;
-(id)init
{
    if(self = [super init])
    {
        //Light for testing
       /* pointShader = [WorldShader loadShaders:@"particle"];
        
        puniforms[0] = glGetUniformLocation(pointShader, "modelViewProjectionMatrix");
        
        glGenVertexArraysOES(1, &parray);
        glBindVertexArrayOES(parray);
        
        GLfloat pcoord[3] = {0, 0, 0};
        glGenBuffers(1, &pbuffer);
        glBindBuffer(GL_ARRAY_BUFFER, pbuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(pcoord), pcoord, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 12, BUFFER_OFFSET(0));
        
        glBindVertexArrayOES(0);*/

        numUniforms = 9;
        
        NSLog(@"Initilizing the Ground");
        
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"sand" ofType:@"png"]; // 1
        
        NSError *error = [[NSError alloc] init];
        texture = [GLKTextureLoader textureWithContentsOfFile:filePath1 options:@{GLKTextureLoaderGenerateMipmaps:[NSNumber numberWithBool:YES]} error:&error]; // 2
        glBindTexture(texture.target, texture.name); // 3
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        
       
        //DirtTexture
        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"dirt" ofType:@"png"]; // 1
        
        error = [[NSError alloc] init];
        texture1 = [GLKTextureLoader textureWithContentsOfFile:filePath2 options:@{GLKTextureLoaderGenerateMipmaps:[NSNumber numberWithBool:YES]} error:&error]; // 2
        glBindTexture(texture1.target, texture1.name); // 3
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        
        NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"grass" ofType:@"png"]; // 1
        
        error = [[NSError alloc] init];
        texture2 = [GLKTextureLoader textureWithContentsOfFile:filePath3 options:@{GLKTextureLoaderGenerateMipmaps:[NSNumber numberWithBool:YES]} error:&error]; // 2
        glBindTexture(texture2.target, texture2.name); // 3
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        
        if( !texture || !texture1 || !texture2)
        {
            NSLog(@"Error Loading Texture");
            NSLog(@"%@", error);
        }
        //int numIslandPoints = 6;
        //numAttributes = 3;
        numCoord = 14406;
        
        //
        //attributes = malloc( sizeof(int)*numAttributes);
        GLfloat coord[numCoord*8];
        
        shader = [NicShader loadShaders:@"Base"];
        
        uniforms[0] = glGetUniformLocation(shader, "modelViewProjectionMatrix");
        uniforms[1] = glGetUniformLocation(shader, "Texture");
        uniforms[2] = glGetUniformLocation(shader, "modelMatrix");
        uniforms[3] = glGetUniformLocation(shader, "viewMatrix");
        uniforms[4] = glGetUniformLocation(shader, "normalMatrix");
        uniforms[5] = glGetUniformLocation(shader, "lightPos");
        uniforms[6] = glGetUniformLocation(shader, "eyePos");
        uniforms[7] = glGetUniformLocation(shader, "Texture1");
        uniforms[8] = glGetUniformLocation(shader, "Texture2");
        
        //uniforms[2] = glGetUniformLocation(shader, "NormalMatrix");
        //Now we calculate whats in the world.
        
        self.projectionMatrix = self.viewMatrix = self.modelMatrix = self.modelViewProjectionMatrix = GLKMatrix4Identity;
        self.normalMatrix = GLKMatrix3Identity;
       
        NSString *fileNameMap = [[NSBundle mainBundle] pathForResource:@"Island" ofType:@"jpg"];
        
        UIImage *islandMap = [UIImage imageWithContentsOfFile:fileNameMap];

            // First get the image into your data buffer
        CGImageRef imageRef = [islandMap CGImage];
        NSUInteger width = CGImageGetWidth(imageRef);
        NSUInteger height = CGImageGetHeight(imageRef);
        CGColorSpaceRef colorSpace = CGImageGetColorSpace( imageRef );
            
        unsigned char *rawData = malloc(height * width * 4);
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                         bitsPerComponent, bytesPerRow, colorSpace,
                                                         kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
            
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGContextRelease(context);
        
       // NSLog(@"width = %d height = %d", width, height);
        //Create the normal addition
        
        GLKVector3 normalMap[(int)width][(int)height];
        
        for( int x = 0; x < (int)width - 1; x ++)
        {
            for( int y = 0; y < (int)height - 1; y++)
            {
                normalMap[x][y] = GLKVector3Make(0, 0, 0);
            }
        }
        
        int i = 0;
        for( int x = 0; x < (int)width - 1; x ++)
        {
            for( int y = 0; y < (int)height - 1; y++)
            {
                unsigned long byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            
                CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
                //CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
                double x0 , y0, z0;
                double x1, y1, z1;
                double x2, y2, z2;
                
                //First
                coord[i] = x0=  (double)x*5.0;
                coord[i+1] = y0 = red* 20.0;
                coord[i+2] = z0 = (double)y*5.0;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 0.0;
                coord[i+7] = 0.0;
                i+= 8;
                
                
                byteIndex = (bytesPerRow * y) + (x+1) * bytesPerPixel;
                red   = (rawData[byteIndex]     * 1.0) / 255.0;
                
                coord[i] = x1 = (double)(x+1)*5.0;
                coord[i+1] = y1 = red* 20.0;
                coord[i+2] = z1 = (double)y*5.0;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 1.0;
                coord[i+7] = 0.0;
                i+= 8;
                
                byteIndex = (bytesPerRow * (y+1)) + (x+1) * bytesPerPixel;
                red   = (rawData[byteIndex]     * 1.0) / 255.0;
                
                coord[i] = x2 = (double)(x+1)*5.0;
                coord[i+1] = y2 = red* 20.0;
                coord[i+2] = z2 =(double)(y+1)*5.0;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 1.0;
                coord[i+7] = 1.0;
                i+= 8;
                
                GLKVector3 v1 = GLKVector3Normalize( GLKVector3Make(x1-x0, y1-y0, z1-z0));
                GLKVector3 v2 = GLKVector3Normalize( GLKVector3Make(x2-x0, y2-y0, z2-z0));
                
                GLKVector3 ans = GLKVector3Normalize( GLKVector3CrossProduct(v2, v1) );
                
                i -= 8*3;
                normalMap[(int)x][(int)y] = GLKVector3Add(normalMap[x][y], ans);
                normalMap[(int)x+1][(int)y] = GLKVector3Add(normalMap[x+1][y], ans);
                normalMap[(int)x+1][(int)y+1] = GLKVector3Add(normalMap[x+1][y+1], ans);
                
                coord[i+3] = ans.x;
                coord[i+4] = ans.y;
                coord[i+5] = ans.z;
                i+=8;
                coord[i+3] = ans.x;
                coord[i+4] = ans.y;
                coord[i+5] = ans.z;
                i+= 8;
                coord[i+3] = ans.x;
                coord[i+4] = ans.y;
                coord[i+5] = ans.z;
                i+= 8;
                
                
                //Seccond Triangle
                byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
                
                red   = (rawData[byteIndex]     * 1.0) / 255.0;
                //CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
                
                //First
                coord[i] = x0 = (double)x*5.0;
                coord[i+1] = y0= red* 20.0;
                coord[i+2] = z0 =(double)y*5.0;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 0.0;
                coord[i+7] = 0.0;
                i+= 8;
                
                
                byteIndex = (bytesPerRow * (y+1)) + x * bytesPerPixel;
                red   = (rawData[byteIndex]     * 1.0) / 255.0;
                
                coord[i] = x1 =(double)(x)*5.0;
                coord[i+1] = y1 = red* 20.0;
                coord[i+2] = z1 = (double)(y+1)*5.0;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 0.0;
                coord[i+7] = 1.0;
                i+= 8;
                
                byteIndex = (bytesPerRow * (y+1)) + (x+1) * bytesPerPixel;
                red   = (rawData[byteIndex]     * 1.0) / 255.0;
                
                coord[i] = x2=(double)(x+1)*5.0;
                coord[i+1] = y2 = red* 20.0;
                coord[i+2] = z2 = (double)(y+1)*5.0;
                coord[i+3] = 0;
                coord[i+4] = 1;
                coord[i+5] = 0;
                coord[i+6] = 1.0;
                coord[i+7] = 1.0;
                i+= 8;
        
                v1 = GLKVector3Make(x1-x0, y1-y0, z1-z0);
                v2 = GLKVector3Make(x2-x0, y2-y0, z2-z0);
                
                ans = GLKVector3Normalize(GLKVector3CrossProduct(v1, v2));
                
                normalMap[(int)x][(int)y] = GLKVector3Add(normalMap[x][y], ans);
                normalMap[(int)x][(int)y+1] = GLKVector3Add(normalMap[x+1][y], ans);
                normalMap[(int)x+1][(int)y+1] = GLKVector3Add(normalMap[x+1][y+1], ans);
                
                i -= 8*3;
                
                coord[i+3] = ans.x;
                coord[i+4] = ans.y;
                coord[i+5] = ans.z;
                i+=8;
                coord[i+3] = ans.x;
                coord[i+4] = ans.y;
                coord[i+5] = ans.z;
                i+= 8;
                coord[i+3] = ans.x;
                coord[i+4] = ans.y;
                coord[i+5] = ans.z;
                i+= 8;
                
            }
        }
        
        i = 0;
        //Update all the normals
        for( int x = 0; x < (int)width - 1; x ++)
        {
            for( int y = 0; y < (int)height - 1; y++)
            {
                //x = 0 y = 0;
                
                GLKVector3 lookup = GLKVector3Normalize( normalMap[x][y]);
                coord[i+3] = lookup.x;
                coord[i+4] = lookup.y;
                coord[i+5] = lookup.z;
                i+= 8;
                
                lookup = GLKVector3Normalize( normalMap[x+1][y]);
                //x = 1 y = 0;
                coord[i+3] = lookup.x;
                coord[i+4] = lookup.y;
                coord[i+5] = lookup.z;
                i+= 8;
                
                lookup = GLKVector3Normalize( normalMap[x+1][y+1]);
                //x = 1 y = 1
                coord[i+3] = lookup.x;
                coord[i+4] = lookup.y;
                coord[i+5] = lookup.z;
                i+= 8;
                
                lookup = GLKVector3Normalize( normalMap[x][y]);
                //x = 0 y=0
                coord[i+3] = lookup.x;
                coord[i+4] = lookup.y;
                coord[i+5] = lookup.z;
                i+= 8;
                
                lookup = GLKVector3Normalize( normalMap[x][y+1]);
                //x = 0 y = 1
                coord[i+3] = lookup.x;
                coord[i+4] = lookup.y;
                coord[i+5] = lookup.z;
                i+= 8;
              
                lookup = GLKVector3Normalize( normalMap[x+1][y+1]);
                //x = 1 y =1
                coord[i+3] = lookup.x;
                coord[i+4] = lookup.y;
                coord[i+5] = lookup.z;
                i+= 8;
                
            }
        }

        
        //Now we have to blend all the normals
        
       // NSLog(@"Normal = < %f, %f, %f>", coord[3], coord[4], coord[5]);
        
        free(rawData);
 
        
        //Set up stuff
        
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
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(texture.target, texture.name);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(texture1.target, texture1.name);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(texture2.target, texture2.name);
    
    
    glUniformMatrix4fv(uniforms[0], 1, 0, modelViewProjectionMatrix.m);
    glUniform1i(uniforms[1], 0);
    glUniformMatrix4fv(uniforms[2], 1, 0, self.modelMatrix.m);
    glUniformMatrix4fv(uniforms[3], 1, 0, self.viewMatrix.m);
    glUniformMatrix3fv(uniforms[4], 1, 0, self.normalMatrix.m);
    glUniform4fv(uniforms[5], 1, lightPos.v);
    
    glUniform3fv(uniforms[6], 1, self.location.v);
    glUniform1i(uniforms[7], 1);
    glUniform1i(uniforms[8], 2);

    //NSLog(@"Open 4.5 gl Error = %d" , glGetError());
    
    glDrawArrays(GL_TRIANGLES, 0, numCoord);
    
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
