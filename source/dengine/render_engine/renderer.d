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
        glEnableVertexAttribArray(0);
        glDrawElements(GL_TRIANGLES, gameObject.getVertexCount(), GL_UNSIGNED_INT, null);
        glDisableVertexAttribArray(0);
        glBindVertexArray(0);
    }
}