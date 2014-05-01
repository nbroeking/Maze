//
//  particle.vsh
//  HW9
//
//  Created by Nicolas Charles Herbert Broeking on 2/24/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

// Vertex Shader
 // Attributes


attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;

 // Uniforms
uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelMatrix;
uniform float Time;
uniform vec3 eyePos;
const float deg = 3.1415927/180.0;

varying vec4 pass;
 void main(void)
{
    vec3 junk = vec3 (texCoord, 1)*normal;
    
    float x = position.z*sin((position.y*deg+Time) )*cos(position.x*deg+(2.0*Time));
    float y = position.z*cos(position.y*deg+Time)*cos(position.x*deg + (2.0*Time));
    float z = position.z*sin(position.x*deg+(2.0*Time));
    
    vec4 newPos = vec4( x, y , z, 1.0);

    pass = vec4( 0.0, newPos.y, newPos.z, 1.0);

    
    float dist = length(vec3(modelMatrix*newPos) - eyePos);
    gl_Position = modelViewProjectionMatrix * newPos;
    
    if( dist > 50.0)
    {
        gl_PointSize = 1.0;
    }
    else if( dist > 35.0)
    {
        gl_PointSize = 2.0;
    }
    else if( dist > 20.0)
    {
        gl_PointSize = 3.0;
    }
    else
    {
        gl_PointSize = 4.0;
    }
}