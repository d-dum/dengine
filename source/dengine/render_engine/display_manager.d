module dengine.render_engine.display_manager;

import glfw3.api;
import bindbc.opengl;

import std.stdio;

/// Manages windows and everything that connected
class DisplayManager {
private:
    int width, height;
    GLFWwindow* window;

    bool cursorDisabled = true;

    float deltaTime = 0;
    float lastFrame = 0;

    void updateDeltaTime(){
        const float currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;
    }

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
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); // opengl core 3.3

        window = glfwCreateWindow(width, height, name.ptr, null, null);
        if(!window)
            throw new Exception("Failed to open window");

        glfwMakeContextCurrent(window);
        glfwSetInputMode(window, GLFW_STICKY_KEYS, GLFW_TRUE);

        const GLSupport retVal = loadOpenGL();
        if (retVal == GLSupport.badLibrary || retVal == GLSupport.noLibrary)
            throw new Exception("GLFW not found");
        
        glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
        glViewport(0, 0, w, h);
    }

    ~this(){
        glfwTerminate();
    }

    /// Returns true if user or/and os requested close of window
    bool isCloseRequested(){
        return cast(bool)glfwWindowShouldClose(window);
    }

    int getWidth(){
        return width;
    }

    int getHeight(){
        return height;
    }

    /// Returns true if key is pressed
    bool getKey(int key){
        const int state = glfwGetKey(window, key);
        switch(state){
            case GLFW_PRESS:
                return true;
            case GLFW_RELEASE:
                return false;
            default:
                return false;
        }
    }

    bool isCursorDisabled(){
        return cursorDisabled;
    }

    float getDeltaTime(){
        return deltaTime;
    }

    /// Updates display(swaps buffers) and polling window events
    void update(){
        int w, h;
        glfwGetFramebufferSize(window, &w, &h);
        width = w;
        height = h;
        glViewport(0, 0, w, h);
        glfwSwapBuffers(window);
        glfwPollEvents();
        updateDeltaTime();
    }
}