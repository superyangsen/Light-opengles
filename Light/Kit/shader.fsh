//
//  shader.fsh
//  Light
//
//  Created by 3i_yang on 2020/10/22.
//
precision mediump float;
varying vec2 v_texCoord;
varying vec3 v_ambient;
varying vec3 v_diffuse;
varying vec3 v_specular;

uniform sampler2D u_texture;

void main() {
    vec4 objectColor = texture2D(u_texture, v_texCoord);
//    vec4 objectColor = vec4(1.0, 0.5, 0.31, 1.0);
    vec3 finalColor = (v_ambient + v_diffuse + v_specular) * vec3(objectColor);
    gl_FragColor = vec4(finalColor, 1.0);
    
//    gl_FragColor = vec4(objectColor, 1.0);
//    gl_FragColor = texture2D(u_texture, v_texCoord);
}
