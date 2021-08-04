module fps_camera;

import dengine;
import gfm.math;

import std.stdio;

class FpsCamera : Camera {
private:
    const float SPEED = 2.5;

protected:
    override void move(DisplayManager display){
        const float movementSpeed = SPEED * display.getDeltaTime();
        if(display.getKey(KEY_W))
            this.increasePosition(0, 0, -movementSpeed);
        if(display.getKey(KEY_S))
            this.increasePosition(0, 0, movementSpeed);
        if(display.getKey(KEY_D))
            this.increasePosition(movementSpeed, 0, 0);
        if(display.getKey(KEY_A))
            this.increasePosition(-movementSpeed, 0, 0);
    }

public:
    this(vec3f position){
        this.position = position;
    }
}