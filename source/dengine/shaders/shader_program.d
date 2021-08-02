module dengine.shaders.shader_program;


import glfw3.api;
import bindbc.opengl;
import gfm.math;

import std.stdio;

/// Base class for all shaders
class ShaderProgram{
private:
    uint programID;
    uint vertexShaderID;
    uint fragmentShaderID;

    uint getShader(uint type, string shaderPath){
        string source;
        {
            File file = File(shaderPath, "r");
            while(!file.eof()){
                string line = file.readln();
                source ~= line;
            }
            file.close();
        }

        uint shader = glCreateShader(type);
        {
            const GLint[1] lengths = [cast(int)source.length];
            const(char)*[1] sources = [source.ptr];
            glShaderSource(shader, 1, sources.ptr, lengths.ptr);
            glCompileShader(shader);
        }

        return shader;
    }

public:
    this(string vertexPath, string fragmentPath){
        vertexShaderID = getShader(GL_VERTEX_SHADER, vertexPath);
        fragmentShaderID = getShader(GL_FRAGMENT_SHADER, fragmentPath);
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

    /// Begin shader usage
    void start(){
        glUseProgram(programID);
    }

    /// Stop shader usage
    void stop(){
        glUseProgram(0);
    }

    uint getProgramID(){
        return programID;
    }
}