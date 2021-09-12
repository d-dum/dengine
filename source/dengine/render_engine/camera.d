module dengine.render_engine.camera;

import dengine.shaders.shader_program;
import dengine.render_engine.display_manager;

import gfm.math;
import bindbc.opengl;

import std.stdio;
import std.math;

class Camera{
private:
    bool changed = true;
    float pitch, yaw, roll;
    vec3f position;
    mat4f viewMatrix;
    vec3f cameraFront;
    vec3f cameraRight;
    vec3f cameraUp;

    mat4f getViewMatrix(){
        if(changed){
            changed = false;
            const vec3f direction = vec3f(
                cos(radians(yaw)) * cos(radians(pitch)),
                sin(radians(pitch)),
                sin(radians(yaw)) * cos(radians(pitch))
            );
            cameraFront = direction.normalized();
            cameraRight = cross(vec3f(0, 1, 0), direction);
            cameraUp = cross(direction, cameraRight);
            viewMatrix = Matrix!(float, 4, 4).lookAt(position, position + cameraFront, cameraUp);
        }
        return viewMatrix;
    }

public:
    this(vec3f position){
        this.position = position;
        pitch = 0;
        yaw = -90;
        roll = 0;
    }

    void increasePosition(vec3f dVec){
        position += dVec;
        changed = true;
    }

    void increaseYPos(float dPos){
        position[1] += dPos;
        changed = true;
    }

    void increasePositionLocal(vec3f dVec){
        position += cameraFront * dVec[2];
        position += cameraRight * dVec[0];
        changed = true;
    }

    void setPosition(uint axis, float value){
        position[axis] = value;
        changed = true;
    }

    void increaseYaw(float dYaw){
        yaw += dYaw;
        changed = true;
    }

    void increasePitch(float dPitch){
        pitch += dPitch;
        changed = true;
    }

    float getYaw(){
        return yaw;
    }

    void look(float dYaw, float dPitch){
        yaw += dYaw;
        changed = true;
    }

    void increaseRoll(float dRoll){
        roll += dRoll;
        changed = true;
    }

    void use(ShaderProgram shader){
        const uint viewMatrixLocation = glGetUniformLocation(shader.getProgramID(), "viewMatrix");
        glUniformMatrix4fv(viewMatrixLocation, 1, GL_FALSE, getViewMatrix().transposed.ptr());
    }
}