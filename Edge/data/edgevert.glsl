uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

uniform vec3 position;

varying vec2 vUv;
varying vec4 vertTexCoord;

void main() {
	vUv = vertTexCoord.st;
	gl_Position = (projectionMatrix * modelViewMatrix) * vec4( position, 1.0 );
}
