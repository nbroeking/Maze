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
//const vec4 lightPos = vec4(117.0,215.0,155.0,1.0); //Sun

uniform vec4 lightPos;

//Light Varying
varying vec3 Light;
varying vec3 Normal;
varying vec4 Ambient;

varying float height;

varying vec3 eyePosd;
varying vec3 Pd;

void main()
{
    //
    //  Lighting values needed by fragment shader
    //
    //  Vertex location in modelview coordinates
    vec3 P = vec3(modelMatrix* position);
    //  Light position
    Light  = vec3(lightPos) - P;
    //  Normal
    
    //highp mat4 normalM = transpose(inverse(viewMatrix*modelMatrix));
    
    //highp mat3 normalMat = mat3(normalM);
    
    Normal = normalize(normalMatrix*normal);
    //  Eye position
  
    eyePosd = eyePos;
    
    Pd = P;
    //  Ambient color
    Ambient = vec4(.3,.3,.3,1.0);
    
    //  Texture coordinate for fragment shader
    texCoordOut = texCoord;
    
    height = P.y;
    //  Set vertex position
    gl_Position = modelViewProjectionMatrix * position;
}


