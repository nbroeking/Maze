//
//  OBJLoader.h
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 4/23/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "DrawableObject.h"

@interface OBJLoader : NSObject
+(int*) LoadObj : (NSString*) name;
@end
