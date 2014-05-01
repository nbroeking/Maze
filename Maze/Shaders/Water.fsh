//
//  Base.fsh
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

varying highp vec3 View;
varying highp vec3 Light;
varying highp vec3 Normal;
varying highp vec4 Ambient;
varying highp vec3 Pd;
//varying sampler2D Texture;

varying highp vec2 texCoordOut;
uniform highp sampler2D Texture;
uniform highp sampler2D Texture1;
uniform highp sampler2D Texture2;
uniform highp vec3 eyePos;

const highp float level1 = 6.0;
const highp float level2 = 7.0;
const highp float level3 = 9.0;
const highp float level4 = 10.0;

highp vec4 phong()
{
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
        color += Id*vec4( 0.0, 0.3, 0.5, 1.0);
        //  R is the reflected light vector R = 2(L.N)N - L
        highp vec3 R = reflect(-L,N);
        //  V is the view vector (eye vector)
        highp vec3 V = normalize(View);
        //  Specular is cosine of reflected and view vectors
        highp float Is = dot(R,V);
        if (Is>0.0) color += pow(Is, 20.0)*vec4(0.8, 0.8, 0.8, 1.0);
    }
    
    //  Return sum of color components
    return color;
}

void main()
{
    if( eyePos.y < 6.0)
    {
        highp vec3 View = eyePos - Pd;
        
        highp float distanced = length(View);
        
        lowp vec4 realColor = vec4( 0.0, 0.3, 0.5, 1.0)* texture2D(Texture, texCoordOut);
        realColor.w = .3;
        
        gl_FragColor = mix( realColor, vec4( 0.0, 0.1, 0.3, 1.0), distanced/20.0);
        return;
    }
    //gl_FragColor = vec4( texCoordOut, 0, 0);
    lowp vec4 light = phong() * texture2D(Texture, texCoordOut);
    light.w = 0.3;
    gl_FragColor = light;
    //gl_FragColor = phong();
    //gl_FragColor = vec4( , 1.0);
}

