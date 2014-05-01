//
//  NicShader.h
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "NicShader.h"
#import <GLKit/GLKit.h>
#import <Foundation/Foundation.h>

@interface WorldShader : NicShader

+ (GLint)loadShaders : (NSString*) name;

+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
+ (BOOL)linkProgram:(GLuint)prog;
+ (BOOL)validateProgram:(GLuint)prog;

@end
