module dengine.helpers.model_loader;

import dengine.render_engine.game_object;

import wavefront.obj;

import std.stdio;

struct UV{
    float[2] uv;
}

class ModelLoader{
private:

    ushort[] getIndices(Model model){
        ushort[] indices;

        auto faces = model.faces;
        foreach (Face[] face; faces)
        {
            foreach (Face key; face)
            {
                indices ~= cast(ushort)key.v;
            }
        }

        return indices;
    }

    UV[] getUV(Model model){
        UV[] uvRaw;
        foreach(Vec2f vec; model.textures){
            uvRaw ~= UV(vec.raw);
        }
        //auto faces = model.faces;

        return uvRaw;
    }

    Face[] getRawFaces(Model model){
        auto faces = model.faces;
        Face[] result;
        foreach (f; faces){
            foreach (face; f)
            {
                result ~= face;
            }
        }
        return result;
    }

    Vertex[] getVertices(Model model){
        Vertex[] vertices;
        UV[] uv = getUV(model);
        int uvCounter = 0;
        auto faces = getRawFaces(model);
        for(int i = 0; i < model.nverts; i++){
            float[2] u;
            foreach (face; faces){
                if(face.v == i){
                    u = uv[face.t].uv;
                    break;
                }
            }
            vertices ~= Vertex(model.vert(i).raw, u);
        }

        return vertices;
    }


public:

    this(){

    }

    GameObject loadOBJModel(string modelPath){
        auto model = new Model(modelPath);
        
        return new GameObject(getVertices(model), getIndices(model));
    }

    GameObject loadOBJModel(string modelPath, string texturePath){
        auto model = new Model(modelPath);

        return new GameObject(getVertices(model), getIndices(model), texturePath);
    }
}