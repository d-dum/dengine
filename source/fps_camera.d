module fps_camera;

import dengine;
import gfm.math;

import std.stdio;

class FpsCamera : Camera {
private:
    float speed = 0.02;

protected:
    override void move(DisplayManager display){
        if(display.getKey(KEY_W))
            this.increasePosition(0, 0, -speed);
        if(display.getKey(KEY_S))
            this.increasePosition(0, 0, speed);
        if(display.getKey(KEY_D))
            this.increasePosition(speed, 0, 0);
        if(display.getKey(KEY_A))
            this.increasePosition(-speed, 0, 0);
    }

public:
    this(vec3f position){
        this.position = position;
    }
}