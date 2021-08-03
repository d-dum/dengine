module dengine.render_engine.entity;

import dengine.render_engine.game_object;
import gfm.math;

/// Class controls position of model in world and on screen
class Entity{
private:
    GameObject game_object;
    vec3f rotation;
    vec3f position;
    vec3f scale;

public:

    this(GameObject game_object, vec3f position, vec3f rotation, vec3f scale){
        this.game_object = game_object;
        this.position = position;
        this.rotation = rotation;
        this.scale = scale;
    }

    this(GameObject game_object, vec3f position, vec3f rotation, float scale){
        this(game_object, position, rotation, vec3f(scale, scale, scale));
    }

    void increasePosition(vec3f d_pos){
        this.position += d_pos;
    }

    void increasePosition(float dx, float dy, float dz){
        this.position += vec3f(dx, dy, dz);
    }

    void increaseRotaion(vec3f d_rot){
        this.rotation += d_rot;
    }

    void increaseRotaion(float dx, float dy, float dz){
        this.rotation += vec3f(dx, dy, dz);
    }

    GameObject getGameObject(){
        return this.game_object;
    }

    vec3f getPosition(){
        return this.position;
    }

    vec3f getRotation(){
        return this.rotation;
    }

    vec3f getScale(){
        return this.scale;
    }
}