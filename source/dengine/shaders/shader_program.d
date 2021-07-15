module dengine.shaders.shader_program;


import glfw3.api;
import bindbc.opengl;


private immutable string vertexShaderSource = "#version 330
layout(location = 0) in vec2 position;
out vec3 fragColor;
void main() {
	gl_Position = vec4(position, 0.0, 1.0);
	fragColor = vec3(1.0, 0.0, 0.0);
}";

private immutable string fragmentShaderSource = "#version 330
in vec3 fragColor;
out vec4 outColor;
void main() {
	outColor = vec4(fragColor, 1.0);
}";

/// Base class for all shaders
class ShaderProgram{
private:
    uint programID;
    uint vertexShaderID;
    uint fragmentShaderID;

    uint createShader(uint type, string shaderPath){
        uint shader = glCreateShader(GL_VERTEX_SHADER);
        {
            const GLint[1] lengths = [vertexShaderSource.length];
            const(char)*[1] sources = [vertexShaderSource.ptr];
            glShaderSource(shader, 1, sources.ptr, lengths.ptr);
            glCompileShader(shader);
        }
        vertexShaderID = shader;

        shader = glCreateShader(GL_FRAGMENT_SHADER);
        {
            const GLint[1] lengths = [fragmentShaderSource.length];
            const(char)*[1] sources = [fragmentShaderSource.ptr];
            glShaderSource(shader, 1, sources.ptr, lengths.ptr);
            glCompileShader(shader);
        }
        fragmentShaderID = shader;
        return shader;
    }

public:
    /// summary:
    this(){
        const uint shader = createShader(GL_FRAGMENT_SHADER, " ");
        const uint program = glCreateProgram();
        glAttachShader(program, vertexShaderID);
        glAttachShader(program, fragmentShaderID);
        glLinkProgram(program);
        programID = program;
        GLint linked;
		glGetProgramiv(program, GL_LINK_STATUS, &linked);
		if (!linked)
			throw new Exception("Failed to link shader: ");
    }

    /// summary
    void start(){
        glUseProgram(programID);
    }

    /// summary
    void stop(){
        glUseProgram(0);
    }
}