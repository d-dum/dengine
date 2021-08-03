module dengine.render_engine.camera;

import dengine.shaders.shader_program;
import dengine.render_engine.display_manager;

import gfm.math;
import bindbc.opengl;

import std.stdio;

abstract class Camera{
protected:
    vec3f position;
    float pitch = 0, 
        yaw = 0, 
        roll = 0;


    abstract void move(DisplayManager display);

public:

    void increasePosition(float dx, float dy, float dz){
        position += vec3f(dx, dy, dz);
    }
    void increasePosition(vec3f dPos){
        position += dPos;
    }

    void use(ShaderProgram shader, DisplayManager display){
        move(display);
        const mat4f rotX = Matrix!(float, 4, 4).rotateX(radians(pitch));
        const mat4f rotY = Matrix!(float, 4, 4).rotateY(radians(yaw));
        const viewMatrix = Matrix!(float, 4, 4).translation(-position) * rotX * rotY;
        const uint viewMatrixLocation = glGetUniformLocation(shader.getProgramID(), "viewMatrix");
        glUniformMatrix4fv(viewMatrixLocation, 1, GL_FALSE, viewMatrix.transposed().ptr());
    }
}