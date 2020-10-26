//
//  shader.vsh
//  Light
//
//  Created by 3i_yang on 2020/10/22.
//

attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec3 a_normal;

uniform mat4 u_mvpMatrix;
uniform mat4 u_modelMatrix;
uniform vec3 u_lightPos;
uniform vec3 u_lightColor;
uniform vec3 u_viewPos;


varying vec2 v_texCoord;
varying vec3 v_ambient;
varying vec3 v_diffuse;
varying vec3 v_specular;

void main() {
    vec3 fragPos = vec3(u_modelMatrix * a_position);
    
    // Ambient light
    float ambientStrength = 0.1; // Ambient factor
    v_ambient = ambientStrength * u_lightColor;
    
    // Diffuse
    float diffuseStrength = 0.8;
    vec3 unitNormal = normalize(vec3(u_modelMatrix * vec4(a_normal, 1.0)));
    vec3 lightDirection = normalize(u_lightPos - fragPos);
    float diff = max(dot(unitNormal, lightDirection), 0.0);
    v_diffuse = diffuseStrength * diff * u_lightColor;
    
    // specular
    float specularStrength = 0.5;
    vec3 viewDirection = normalize(u_viewPos - fragPos);
    vec3 reflectDirection = reflect(-lightDirection, unitNormal);
    float spec = pow(max(dot(unitNormal, reflectDirection), 0.0), 16.0);
    v_specular = specularStrength * spec * u_lightColor;
    
    v_texCoord = a_texCoord;
    gl_Position = u_mvpMatrix * a_position;
    
}
