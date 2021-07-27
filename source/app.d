module app;

import glfw3.api;
import bindbc.opengl;
import imaged;
import std.stdio;

import dengine;

int main() {
	auto dm = new DisplayManager(800, 600, "dengine");

	auto shader = new ShaderProgram();
	auto rn = new Renderer();

	Vertex[4] vertices = [
		Vertex([ -0.5, 0.5, 0], [0.0, 0.0,]),
		Vertex([  -0.5, -0.5, 0,], [  0.0, 1.0,]),
		Vertex([  0.5, -0.5, 0,], [1.0, 1.0,]),
		Vertex([  0.5, 0.5, 0], [1.0, 0.0]),
	];

	ushort[] indices = [
		0, 1, 3, // first triangle
		3, 1, 2, // second triangle
	];

	auto gb = new GameObject(vertices, indices, "res/crate1.png");

	while (!dm.isCloseRequested()) {
		rn.prepare();

		shader.start();
			rn.render(gb);
		shader.stop();

		dm.update();
	}
	return 0;
}

