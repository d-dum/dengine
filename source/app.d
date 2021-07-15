module app;


import glfw3.api;
import bindbc.opengl;
import std.stdio;

import dengine.render_engine.game_object;
import dengine.render_engine.display_manager;
import dengine.render_engine.renderer;
import dengine.shaders.shader_program;


int main() {
	auto display = new DisplayManager(1900, 1000, "dengine");

	uint[] uindices = [
		0,1,3,//top left triangle (v0, v1, v3)
		3,1,2//bottom right triangle (v3, v1, v2)
	];

	Vertex[4] vertices = [
		Vertex([-0.5f, 0.5f, 0.0]),
		Vertex([ -0.5f, -0.5f, 0.0]),
		Vertex([ 0.5f,  -0.5f, 0.0]),
		Vertex([ 0.5f, 0.5f, 0.0]),
	];

	auto obj = new GameObject(vertices.ptr, uindices.ptr,
		vertices.sizeof, uindices.length, null, null, 0);
	auto renderer = new Renderer();

	auto shader = new ShaderProgram();

	while (!display.isCloseRequested()) {
		shader.start();
			renderer.renderGameObject(obj);
		shader.stop();

		display.update();
	}
	return 0;
}