//
//  groundShader.fsh
//  HW6
//
//  Created by Nicolas Charles Herbert Broeking on 2/24/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

//  Per-pixel Phong lighting
//  Fragment shader

varying highp vec4 pass;
void main()
{
    gl_FragColor = (pass + vec4( 1.0, 1.0, 1.0, 1.0))/2.0;
}
