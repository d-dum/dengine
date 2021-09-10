module dengine.render_engine.renderer;

import glfw3.api;
import bindbc.opengl;
import gfm.math;

import dengine.render_engine.game_object;
import dengine.render_engine.entity;
import dengine.shaders.shader_program;
import dengine.render_engine.display_manager;
import dengine.render_engine.mesh;

import std.stdio;
import std.conv;

/// Handles rendering of all things
class Renderer {
private:
    float FOV, nearPlane, farPlane;
    int width, height;

    void loadTransformationMatrx(Entity entity, ShaderProgram shader){
        const mat4f rotX = Matrix!(float, 4, 4).rotateX(entity.getRotation()[0]);
        const mat4f rotY = Matrix!(float, 4, 4).rotateY(entity.getRotation()[1]);
        const mat4f rotZ = Matrix!(float, 4, 4).rotateZ(entity.getRotation()[2]);
        const mat4f rotationMatrix = Matrix!(float, 4, 4).identity() * rotX * rotY * rotZ;
        const mat4f scaleMatrix = Matrix!(float, 4, 4).scaling(entity.getScale());
        const mat4f translationMatrix = Matrix!(float, 4, 4).translation(entity.getPosition());
        const mat4f transformationMatrix = Matrix!(float, 4, 4).identity() * 
            translationMatrix * rotationMatrix * scaleMatrix;
        const uint transformationMatrixLocation = glGetUniformLocation(shader.getProgramID(), "transformationMatrix");
        glUniformMatrix4fv(transformationMatrixLocation, 1, GL_FALSE, transformationMatrix.transposed().ptr());
    }

    void loadProjectionMatrix(float FOV, float nearPlane, float farPlane, int width, int height, ShaderProgram shader){
        const mat4f projectionMatrix = Matrix!(float, 4, 4).perspective(radians(FOV), 
            cast(float)width / cast(float)height, nearPlane, farPlane);
        shader.start();
        const uint projectionMatrixLocation = glGetUniformLocation(shader.getProgramID(), "projectionMatrix");
        glUniformMatrix4fv(projectionMatrixLocation, 1, GL_FALSE, projectionMatrix.transposed().ptr());
        shader.stop();
    }

public:
    this(float FOV, float nearPlane, float farPlane, ShaderProgram shader, DisplayManager display){
        this.FOV = FOV;
        this.nearPlane = nearPlane;
        this.farPlane = farPlane;
        this.width = display.getWidth();
        this.height = display.getHeight();
        loadProjectionMatrix(FOV, nearPlane, farPlane, display.getWidth(), display.getHeight(), shader);
    }

    /// Updates projection matrix when display size is changed
    void updateProjectionMatrix(DisplayManager display, ShaderProgram shader){
        if(display.getWidth() == width || display.getHeight() == height){
            
        }
        else {
            loadProjectionMatrix(FOV, nearPlane, farPlane, display.getWidth(), display.getHeight(), shader);
        }
    }

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

    void render(Mesh mesh, ShaderProgram shader){
        uint diffuseNr = 1;
        uint specularNr = 1;
        Texture[] textures = mesh.getTextures();
        for(uint i = 0; i < textures.length; i++){
            glActiveTexture(GL_TEXTURE0 + i);
            string number;
            string name = textures[i].type;
            if(name == "texture_diffuse")
                number = to!string(diffuseNr++);
            else if(name == "texture_specular")
                number = to!string(specularNr++);
            
            string variableName = "material." ~ name ~ number;
            glBindTexture(GL_TEXTURE_2D, textures[i].id);
        }
    }
}