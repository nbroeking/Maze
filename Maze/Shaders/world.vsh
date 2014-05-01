//
//  world.vsh
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

attribute vec4 position;
attribute vec2 texCoord;

varying vec2 texCoordOut;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    texCoordOut = texCoord;
    gl_Position = modelViewProjectionMatrix * position;
}
