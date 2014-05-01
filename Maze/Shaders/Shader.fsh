//
//  Shader.fsh
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

varying lowp vec4 colorVarying;
varying highp vec2 texCoordOut;


void main()
{
    gl_FragColor = colorVarying;
    gl_FragColor = vec4( 1, texCoordOut, 1);
}
