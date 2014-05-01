//
//  Base.fsh
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

varying highp vec3 Light;
varying highp vec3 Normal;
varying highp vec4 Ambient;
//varying sampler2D Texture;

varying highp vec2 texCoordOut;

varying highp vec3 eyePosd;
varying highp vec3 Pd;

uniform highp sampler2D Texture;

const highp float level0 = 6.0;
const highp float level1 = 8.0;
const highp float level2 = 9.0;
const highp float level3 = 10.0;
const highp float level4 = 11.0;

highp vec4 phong()
{
    highp vec3 View = eyePosd - Pd;
    
    //  N is the object normal
    //highp vec3 N = normalize(Normal);
    highp vec3 N = normalize(Normal);
    //  L is the light vector
    highp vec3 L = normalize(Light);
    
    //  Emission and ambient color
    highp vec4 color = Ambient;
    
    //  Diffuse light is cosine of light and normal vectors
    highp float Id = dot(L,N);
    if (Id>0.0)
    {
        //  Add diffuse
        color += Id*vec4( 0.7, 0.7, 0.7, 1.0);
        //  R is the reflected light vector R = 2(L.N)N - L
        highp vec3 R = reflect(-L,N);
        //  V is the view vector (eye vector)
        highp vec3 V = normalize(View);
        //  Specular is cosine of reflected and view vectors
        highp float Is = dot(R,V);
        if (Is>0.0) color += pow(Is, 16.0)*vec4(0.2, 0.2, 0.2, 1.0);
    }
    
    //  Return sum of color components
    return color;
}

void main()
{
    highp vec3 View = eyePosd - Pd;
    highp float distanced = length(View);
    
    //gl_FragColor = vec4(normalize(Normal), 1.0);
    gl_FragColor = phong() * texture2D(Texture, texCoordOut);
}

