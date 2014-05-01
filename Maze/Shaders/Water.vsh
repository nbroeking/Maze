//
//  Base.vsh
//  Maze
//
//  Created by Nicolas Charles Herbert Broeking on 3/21/14.
//  Copyright (c) 2014 NicolasBroeking. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec2 texCoordOut;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;

uniform vec3 eyePos;
uniform float time;
//const vec4 lightPos = vec4(117.0,215.0,155.0,1.0); //Sun

uniform vec4 lightPos;

//Light Varying
varying vec3 View;
varying vec3 Light;
varying vec3 Normal;
varying vec4 Ambient;

varying vec3 Pd;

varying float height;

void main()
{
    //
    //  Lighting values needed by fragment shader
    //

    vec4 realPos = modelMatrix*position;
    float r = sqrt (realPos.x*realPos.x + realPos.z*realPos.z);
    float z = 50.0*(sin (r) / r);
    
    realPos.y = realPos.y + cos(realPos.x+time)*sin(realPos.x+time) + sin(time) + cos(realPos.z +time);
    
    vec3 normal1 = normal;
    if( realPos.x == -122.0 || realPos.x == 123.0 || realPos.z == -122.0 || realPos.z == 123.0 || (realPos.x*realPos.x + realPos.z*realPos.z) < 6000.0)
    {
        realPos.y = 6.0;
        
        normal1 = normal;
    }
    else
    {
        //Bottom
       vec3 point1 = vec3(realPos.x - 5.0, realPos.y + cos((realPos.x-5.0)+time)*sin((realPos.x-5.0)+time) + sin(time) + cos((realPos.z-5.0) +time), realPos.z - 5.0);
        
       vec3 point2 = vec3( realPos.x, realPos.y + cos((realPos.x-0.0)+time)*sin((realPos.x-0.0)+time) + sin(time) + cos((realPos.z-5.0) +time), realPos.z-5.0);
        
       vec3 point3 = vec3( realPos.x + 5.0,realPos.y + cos((realPos.x+5.0)+time)*sin((realPos.x+5.0)+time) + sin(time) + cos((realPos.z-5.0) +time), realPos.z - 5.0);
        
       vec3 point4 = vec3( realPos.x + 5.0,realPos.y + cos((realPos.x+5.0)+time)*sin((realPos.x+5.0)+time) + sin(time) + cos((realPos.z) +time), realPos.z);
        
        vec3 point5 = vec3( realPos.x + 5.0,realPos.y + cos((realPos.x+5.0)+time)*sin((realPos.x+5.0)+time) + sin(time) + cos((realPos.z+5.0) +time), realPos.z + 5.0);
        
        vec3 point6 = vec3( realPos.x ,realPos.y + cos((realPos.x)+time)*sin((realPos.x)+time) + sin(time) + cos((realPos.z+5.0) +time), realPos.z + 5.0);
        
        vec3 point7 = vec3( realPos.x - 5.0,realPos.y + cos((realPos.x-5.0)+time)*sin((realPos.x-5.0)+time) + sin(time) + cos((realPos.z+5.0) +time), realPos.z - 5.0);
        
        vec3 point8 = vec3( realPos.x - 5.0,realPos.y + cos((realPos.x-5.0)+time)*sin((realPos.x-5.0)+time) + sin(time) + cos((realPos.z) +time), realPos.z);
        //Right
        
        /*vec3 point1 = vec3(realPos.x - 5.0, 6.0, realPos.z - 5.0);
        
        vec3 point2 = vec3( realPos.x, 6.0, realPos.z-5.0);
        
        vec3 point3 = vec3( realPos.x + 5.0, 6.0 , realPos.z - 5.0);
        
        vec3 point4 = vec3( realPos.x + 5.0, 6.0 , realPos.z);
        
        vec3 point5 = vec3( realPos.x + 5.0, 6.0, realPos.z + 5.0);
        
        vec3 point6 = vec3( realPos.x , 6.0, realPos.z + 5.0);
        
        vec3 point7 = vec3( realPos.x - 5.0, 6.0, realPos.z - 5.0);
        
        vec3 point8 = vec3( realPos.x - 5.0, 6.0, realPos.z);*/
        
        //normals
        normal1 =  normalize(cross( point2 - vec3(realPos) , point1 - vec3(realPos)));
        normal1 += normalize(cross( point3 - vec3(realPos) , point2 - vec3(realPos)));
        normal1 += normalize(cross( point4 - vec3(realPos) , point3 - vec3(realPos)));
        normal1 += normalize(cross( point5 - vec3(realPos) , point4 - vec3(realPos)));
        normal1 += normalize(cross( point6 - vec3(realPos) , point5 - vec3(realPos)));
        normal1 += normalize(cross( point7 - vec3(realPos) , point6 - vec3(realPos)));
        normal1 += normalize(cross( point8 - vec3(realPos) , point7 - vec3(realPos)));
        normal1 += normalize(cross( point1 - vec3(realPos) , point8 - vec3(realPos)));
        
        normal1 = normalize(normal1);
    }
    
    
    
    //Calculate the new normal
    
    //  Vertex location in modelview coordinates
    vec3 P = vec3(realPos);
    
    Pd = P;
    
    //  Light position
    Light  = vec3(lightPos) - P;
    //  Normal
    
    Normal = normalize(normal1);
    //  Eye position
    View  = eyePos-P;
    //  Ambient color
    Ambient = vec4(0.0,0.0,0.3,1.0);
    
    //  Texture coordinate for fragment shader
    texCoordOut = texCoord;
    //  Set vertex position
    
    vec4 newPos = position;
    newPos.y = realPos.y;
    gl_Position = modelViewProjectionMatrix * newPos;
}


