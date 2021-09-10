#version 330

in vec2 textureCoords;
out vec4 outColor;

uniform sampler2D textureSampler;

void main() {
	outColor = texture(textureSampler, textureCoords);
	//outColor = vec4(1.0, 0.0, 0.0, 1.0);
}