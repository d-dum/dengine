module dengine.render_engine.mesh;

import bindbc.opengl;

import dengine.render_engine.game_object;

struct Texture {
    uint id;
    string type;
}

class Mesh {
private:
    Vertex[] vertices;
    uint[] indices;
    Texture[] textures;

    uint VAO, VBO, EBO;

    void setupMesh(){
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);
        glGenBuffers(1, &EBO);

        glBindVertexArray(VAO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);

        glBufferData(GL_ARRAY_BUFFER, vertices.length * Vertex.sizeof, &vertices[0], GL_STATIC_DRAW);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * Vertex.sizeof, &indices[0], GL_STATIC_DRAW);

        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*) Vertex.position.offsetof);

        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*) Vertex.uv.offsetof);

        glEnableVertexAttribArray(2);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*) Vertex.normals.offsetof);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

        glDisableVertexAttribArray(0);
        glDisableVertexAttribArray(1);
        glDisableVertexAttribArray(2);

        glBindVertexArray(0);

    }

public:

    this(Vertex[] vertices, uint[] indices, Texture[] textures){
        this.vertices = vertices.dup;
        this.indices = indices.dup;
        this.textures = textures.dup;

        setupMesh();
    }

    Texture[] getTextures(){
        return this.textures;
    }
}