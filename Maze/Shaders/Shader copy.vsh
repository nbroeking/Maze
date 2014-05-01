//
//  Shader.vsh
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

attribute vec4 position;

varying vec4 positionT;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    positionT = position;
    gl_Position = modelViewProjectionMatrix * position;
}
