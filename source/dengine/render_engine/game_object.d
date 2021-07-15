module dengine.render_engine.game_object;

import glfw3.api;
import bindbc.opengl;

/// Struct that describes model
struct Vertex {
    /// positions
	float[3] position;
}

import std.stdio;

/// Class that represents game object
class GameObject {
private:
    // Data needed for rendering
    uint vaoID;
    int vertexCount;
    bool have_texture;

    // Data not needed for rendering, need it to cleanup
    uint vboID;
    uint eboID;

    uint getVaoID(Vertex* vertices, uint* indices, ulong vertices_size, ulong indices_len){
        uint vao;
        glGenVertexArrays(1, &vao);

        glBindVertexArray(vao);
        uint vbo;
        glGenBuffers(1, &vbo);

        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, vertices_size, vertices, GL_STATIC_DRAW);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, null);

        vboID = vbo;

        uint ebo;
        glGenBuffers(1, &ebo);
        eboID = ebo;

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, uint.sizeof * indices_len, indices, GL_STATIC_DRAW);

        glBindBuffer(GL_ARRAY_BUFFER, 0);

        glBindVertexArray(0);

        return vao;
    }

public:
    /// Constructor for game object
    this(Vertex* vertices, uint* indices, ulong vertices_size, ulong indices_len,
        string texture_path, float* texture_coords, ulong texture_size){
        // Creating vertex array object
        
    }

    ~this(){
        glDeleteVertexArrays(1, &vaoID);
        glDeleteBuffers(1, &vboID);
        glDeleteBuffers(1, &eboID);
    }

    uint getVaoID(){
        return vaoID;
    }

    int getVertexCount(){
        return vertexCount;
    }
}