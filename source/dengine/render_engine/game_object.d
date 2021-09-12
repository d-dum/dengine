module dengine.render_engine.game_object;

import glfw3.api;
import bindbc.opengl;


import std.string;
import std.file;

import imaged;

/// Struct that describes model
struct Vertex {
    /// positions
	float[3] position;
    /// texture coordinates
    float[2] uv;

    float[3] normals;
}

import std.stdio;

/// Class that represents game object
class GameObject {
private:
    // Data needed for rendering
    uint vaoID;
    int vertexCount;
    bool have_texture = false;
    uint textureID;

    // Data not needed for rendering, need it for cleanup
    uint vboID;
    uint eboID;
    uint tboID;

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

        vertexCount = cast(int)indices_len;

        glBindVertexArray(0);

        return vao;
    }

    uint getTexture(uint vao, string texture_path, float* texture_coords, ulong texture_size, bool rgba){
        glBindVertexArray(vao);

        uint tbo;
        glGenBuffers(1, &tbo);
        glBindBuffer(GL_ARRAY_BUFFER, tbo);
        glBufferData(GL_ARRAY_BUFFER, texture_size, texture_coords, GL_STATIC_DRAW);
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, null);
        glBindBuffer(GL_ARRAY_BUFFER, 0);

        tboID = tbo;
        
        uint texture;
        glGenTextures(1, &texture);
        

        uint mode = GL_RGB;
        if(rgba) mode = GL_RGBA;

        IMGError err;
        Image img = load(texture_path, err);

        GLenum texformat;
        GLint nchannels;

        if (img.pixelFormat == Px.R8G8B8)
        {
            nchannels = 3;
            texformat = GL_RGB;
            debug { writeln("Texture format is: GL_RGB"); }
        }
        else if (img.pixelFormat == Px.R8G8B8A8)
        {
            nchannels = 4;
            texformat = GL_RGBA;
            debug { writeln("Texture format is: GL_RGBA"); }
        }

        glBindTexture(GL_TEXTURE_2D, texture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, cast(int)img.width, cast(int)img.height, 0, 
            GL_RGB, GL_UNSIGNED_BYTE, img.pixels.ptr);

        return texture;
    }

    uint getTexture(string texture_path){
        uint texture;
        glGenTextures(1, &texture);
        

        IMGError err;
        Image img = load(texture_path, err);

        GLenum texformat;
        GLint nchannels;

        if (img.pixelFormat == Px.R8G8B8)
        {
            nchannels = 3;
            texformat = GL_RGB;
        }
        else if (img.pixelFormat == Px.R8G8B8A8)
        {
            nchannels = 4;
            texformat = GL_RGBA;
        }

        
        glBindTexture(GL_TEXTURE_2D, texture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, cast(int)img.width, cast(int)img.height, 0, 
            GL_RGB, GL_UNSIGNED_BYTE, img.pixels.ptr);

        return texture;
    }

public:
    // /// Constructor for game object
    // this(Vertex* vertices, uint* indices, ulong vertices_size, ulong indices_len){
    //     vaoID = getVaoID(vertices, indices, vertices_size, indices_len);
    // }

    // /// Same thing but with texture
    // this(Vertex* vertices, uint* indices, ulong vertices_size, ulong indices_len,
    //     string texture_path, float* texture_coords, ulong texture_size, bool rgba = false){
    //     // Creating vertex array object
    //     vaoID = getVaoID(vertices, indices, vertices_size, indices_len);
    //     have_texture = true;
    //     textureID = getTexture(vaoID, texture_path, texture_coords, texture_size, rgba);
    // }
    this(Vertex[] v, ushort[] i) {
	    // Upload data to GPU
        GLuint vbo;
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * v.length, v.ptr, /*usage hint*/ GL_STATIC_DRAW);

        
        // Describe layout of data for the shader program
        GLuint vao;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        glEnableVertexAttribArray(0);
        glVertexAttribPointer(
            /*location*/ 0, /*num elements*/ 3, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
            Vertex.sizeof, cast(void*) Vertex.position.offsetof
        );
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(
            /*location*/ 1, /*num elements*/ 2, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
            Vertex.sizeof, cast(void*) Vertex.uv.offsetof
        );

        GLuint ebo;
        glGenBuffers(1, &ebo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, ushort.sizeof * i.length, i.ptr, GL_STATIC_DRAW);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glDisableVertexAttribArray(0);
        glDisableVertexAttribArray(1);

        vaoID = vao;
        vboID = vbo;
        eboID = ebo;
        vertexCount = cast(int)i.length;
    }

    this(Vertex* v_ptr, ushort* i_ptr, ulong v_len, ulong i_len) {
	    // Upload data to GPU
        GLuint vbo;
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * v_len, v_ptr, /*usage hint*/ GL_STATIC_DRAW);

        
        // Describe layout of data for the shader program
        GLuint vao;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        glEnableVertexAttribArray(0);
        glVertexAttribPointer(
            /*location*/ 0, /*num elements*/ 3, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
            Vertex.sizeof, cast(void*) Vertex.position.offsetof
        );
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(
            /*location*/ 1, /*num elements*/ 2, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
            Vertex.sizeof, cast(void*) Vertex.uv.offsetof
        );

        GLuint ebo;
        glGenBuffers(1, &ebo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, ushort.sizeof * i_len, i_ptr, GL_STATIC_DRAW);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glDisableVertexAttribArray(0);
        glDisableVertexAttribArray(1);

        vaoID = vao;
        vboID = vbo;
        eboID = ebo;
        vertexCount = cast(int)i_len;
    }

    this(Vertex* v_ptr, ushort* i_ptr, ulong v_len, ulong i_len, string texture_path){
        this(v_ptr, i_ptr, v_len, i_len);
        textureID = getTexture(texture_path);
        have_texture = true;
    }

    this(Vertex[] v, ushort[] i, string texture_path){
        this(v.ptr, i.ptr, v.length, i.length);
        textureID = getTexture(texture_path);
        have_texture = true;
    }

    ~this(){
        glDeleteVertexArrays(1, &vaoID);
        glDeleteBuffers(1, &vboID);
        glDeleteBuffers(1, &eboID);
    }

    uint getVaoID(){
        return vaoID;
    }

    uint getTextureID(){
        return textureID;
    }

    int getVertexCount(){
        return vertexCount;
    }

    bool getHaveTexture(){
        return have_texture;
    }
}