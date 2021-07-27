module dengine.render_engine.renderer;

import glfw3.api;
import bindbc.opengl;

import dengine.render_engine.game_object;

/// Handles rendering of all things
class Renderer {
public:
    /// Prepares window for rendering
    void prepare(){
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glClearColor(0.2, 0.3, 0.3, 1.0);
    }

    /// Render GameObject
    void renderGameObject(GameObject gameObject){
        glBindVertexArray(gameObject.getVaoID());
        if(gameObject.getHaveTexture()){
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, gameObject.getTextureID());
            glEnableVertexAttribArray(1);
            
        }
        glEnableVertexAttribArray(0);
        glDrawElements(GL_TRIANGLES, gameObject.getVertexCount(), GL_UNSIGNED_INT, null);
        glDisableVertexAttribArray(0);
        if(gameObject.getHaveTexture()){
            glDisableVertexAttribArray(1);
            glBindTexture(GL_TEXTURE_2D, 0);
        }

        glBindVertexArray(0);
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
}