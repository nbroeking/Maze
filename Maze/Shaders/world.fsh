//
//  world.fsh
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

varying lowp vec2 texCoordOut;

uniform sampler2D Texture;

void main()
{
    gl_FragColor = texture2D(Texture, texCoordOut);
    //gl_FragColor = vec4(1,texCoordOut,1);
}
