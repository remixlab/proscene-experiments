#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D tex;
uniform vec2 texcoordOffset;

varying vec4 vertColor;
varying vec4 vertTexcoord;

void main(void) {
  vec2 tc0 = vertTexcoord.st + vec2(-texcoordOffset.s, -texcoordOffset.t);
  vec2 tc1 = vertTexcoord.st + vec2(              0.0, -texcoordOffset.t);
  vec2 tc2 = vertTexcoord.st + vec2(+texcoordOffset.s, -texcoordOffset.t);
  vec2 tc3 = vertTexcoord.st + vec2(-texcoordOffset.s,               0.0);
  vec2 tc4 = vertTexcoord.st + vec2(              0.0,               0.0);
  vec2 tc5 = vertTexcoord.st + vec2(+texcoordOffset.s,               0.0);
  vec2 tc6 = vertTexcoord.st + vec2(-texcoordOffset.s, +texcoordOffset.t);
  vec2 tc7 = vertTexcoord.st + vec2(              0.0, +texcoordOffset.t);
  vec2 tc8 = vertTexcoord.st + vec2(+texcoordOffset.s, +texcoordOffset.t);
  
  vec4 col0 = texture2D(tex, tc0);
  vec4 col1 = texture2D(tex, tc1);
  vec4 col2 = texture2D(tex, tc2);
  vec4 col3 = texture2D(tex, tc3);
  vec4 col4 = texture2D(tex, tc4);
  vec4 col5 = texture2D(tex, tc5);
  vec4 col6 = texture2D(tex, tc6);
  vec4 col7 = texture2D(tex, tc7);
  vec4 col8 = texture2D(tex, tc8);

  vec4 sum = 8.0 * col4 - (col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8); 
  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}
