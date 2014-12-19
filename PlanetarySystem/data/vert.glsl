#define PROCESSING_TEXLIGHT_SHADER

uniform mat4 myModelview;
uniform mat4 myTransform;
uniform mat3 normalMatrix;
//uniform mat3 myNormal;
uniform mat4 texMatrix;

uniform vec4 lightPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;
/*

varying vec3 ecNormal;
varying vec3 lightDir;

*/
varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = myTransform * vertex;    
  //mat4 myNormal = myModelview * normalMatrix;
  //mat3 temp = inverse(transpose(myNormal));
  //mat3 normalMatrix = transpose(temp);
  vec3 ecVertex = vec3(myModelview * vertex);
  vec3 ecNormal = normalize(normalMatrix * normal);
  //vec3 ecNormal = normalize(myNormal * normal);

  vec3 direction = normalize(lightPosition.xyz - ecVertex);
  //vec3 direction = normalize(vec3(0,0,0) - ecVertex);  
  float intensity = max(0.0, dot(direction, ecNormal));
  vertColor = vec4(intensity, intensity, intensity, 1) * color;     
  
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);        
}

/*
void main() {
  gl_Position = myTransform * vertex;
  vec3 ecVertex = vec3(myModelview * vertex);
  ecNormal = normalize(normalMatrix * normal);
  
  vec3 lightPos = vec3(0,0,0);
  //lightDir = normalize((myTransform * lightPosition).xyz -ecVertex);
  //lightDir = normalize(lightPosition.xyz - ecVertex);
  lightDir = normalize(lightPosition.xyz - ecVertex);
  //lightDir = normalize(vec3(100,10,-100) - ecVertex);
  vertColor = color;
  
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}

/*
attribute vec4 vertex;
attribute vec4 color;

varying vec4 vertColor;

void main() {
  gl_Position = myTransform * vertex;
  vertColor = color;
}
*/