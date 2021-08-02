module dengine.render_engine.renderer;

import glfw3.api;
import bindbc.opengl;
import gfm.math;

import dengine.render_engine.game_object;
import dengine.render_engine.entity;
import dengine.shaders.shader_program;

import std.stdio;

/// Handles rendering of all things
class Renderer {
private:
    bool done = false;

    void loadTransformationMatrx(Entity entity, ShaderProgram shader){
        const mat4f rotX = Matrix!(float, 4, 4).rotateX(entity.getRotation()[0]);
        const mat4f rotY = Matrix!(float, 4, 4).rotateY(entity.getRotation()[1]);
        const mat4f rotZ = Matrix!(float, 4, 4).rotateZ(entity.getRotation()[2]);
        const mat4f rotationMatrix = Matrix!(float, 4, 4).identity() * rotX * rotY * rotZ;
        const mat4f scaleMatrix = Matrix!(float, 4, 4).scaling(entity.getScale());
        const mat4f translationMatrix = Matrix!(float, 4, 4).translation(entity.getPosition());
        const mat4f transformationMatrix = Matrix!(float, 4, 4).identity() * translationMatrix * rotationMatrix * scaleMatrix;
        const uint transformationMatrixLocation = glGetUniformLocation(shader.getProgramID(), "transformationMatrix");
        glUniformMatrix4fv(transformationMatrixLocation, 1, GL_FALSE, transformationMatrix.transposed().ptr());
    }

public:
    /// Prepares window for rendering
    void prepare(){
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glClearColor(0.2, 0.3, 0.3, 1.0);
    }

    void render(GLuint vao, GLuint textureID, int vertexCount){
        glBindVertexArray(vao);
        // if(gameObject.getHaveTexture()){
        //     glEnableVertexAttribArray(1);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, textureID);
        // }
        glEnableVertexAttribArray(1);
        glEnableVertexAttribArray(0);
        glDrawElements(GL_TRIANGLES, vertexCount, GL_UNSIGNED_SHORT, null);
        glDisableVertexAttribArray(0);
        glDisableVertexAttribArray(1);
        //if(gameObject.getHaveTexture()) glDisableVertexAttribArray(1);
        glBindVertexArray(0);
    }

    void render(GameObject gameObject){
        render(gameObject.getVaoID, gameObject.getTextureID(), gameObject.getVertexCount());
    }

    void render(Entity entity, ShaderProgram shader){
        GameObject gameObject = entity.getGameObject();
        loadTransformationMatrx(entity, shader);
        render(gameObject);
    }
}