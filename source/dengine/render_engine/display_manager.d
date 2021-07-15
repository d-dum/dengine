module dengine.render_engine.display_manager;

import glfw3.api;
import bindbc.opengl;

/// Manages windows and everything that connected
class DisplayManager {
private:
    int width, height;
    GLFWwindow* window;

public:
    /// Constructor for DisplayManager
    this(int w, int h, string name){
        width = w;
        height = h;

        if(!glfwInit)
            throw new Exception("Failed to init glfw");

        glfwWindowHint(GLFW_SAMPLES, 4); // 4x antialiasing
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        //glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

        window = glfwCreateWindow(width, height, name.ptr, null, null);
        if(!window)
            throw new Exception("Failed to open window");

        glfwMakeContextCurrent(window);

        const GLSupport retVal = loadOpenGL();
        if (retVal == GLSupport.badLibrary || retVal == GLSupport.noLibrary)
            throw new Exception("GLFW not found");

        glViewport(0, 0, w, h);
    }

    ~this(){
        glfwTerminate();
    }

    /// Returns true if user or/and os requested close of window
    bool isCloseRequested(){
        return cast(bool)glfwWindowShouldClose(window);
    }

    /// Updates display(swaps buffers) and polling window events
    void update(){
        int w, h;
        glfwGetFramebufferSize(window, &w, &h);
        if(w != width || h != height){
            width = w;
            height = h;
            glViewport(0, 0, w, h);
        }
        glfwSwapBuffers(window);
        glfwPollEvents();
    }
}