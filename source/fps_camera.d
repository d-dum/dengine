import dengine;

import gfm.math;

import std.stdio;

class FpsCamera : Camera {
private:
    const float SPEED = 4;
    const float MOUSE_SENSITIVITY = 0.1;

    void processKeyboardMovement(DisplayManager display){
        vec3f movement = vec3f(0, 0, 0);
        const float movementSpeed = 1;

        if(display.getKey(KEY_A))
            movement[0] = movementSpeed;
        if(display.getKey(KEY_D))
            movement[0] = -movementSpeed;
        if(display.getKey(KEY_W))
            movement[2] = movementSpeed;
        if(display.getKey(KEY_S))
            movement[2] = -movementSpeed;
        
        if(movement != vec3f(0, 0, 0)) increasePositionLocal(movement.normalized() * SPEED * display.getDeltaTime());
        setPosition(1, 0);
    }

    void processMouseMovement(DisplayManager display){
        const mousePos = display.getMousePos();

        const xpos = mousePos.x;
        const ypos = mousePos.y;

        const double xOffset = (xpos - display.getWidth() / 2);
        const double yOffset = (display.getHeight() / 2 - ypos) * MOUSE_SENSITIVITY;

        if(xOffset != 0) increaseYaw(xOffset * MOUSE_SENSITIVITY);
        if(yOffset != 0) increasePitch(yOffset);
        display.setCursorPosition();
    }


public:

    this(vec3f position){
        super(position);
    }

    
    void move(DisplayManager display, ShaderProgram program){
        processKeyboardMovement(display);
        processMouseMovement(display);
        
        use(program);
    }
}