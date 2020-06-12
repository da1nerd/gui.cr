#version 140

in vec2 textureCoords;

out vec4 out_Color;

// uniform sampler2D guiTexture;
uniform vec3 color;

void main(void){

	out_Color = vec4(color, 1.0); //texture(guiTexture,textureCoords);

}