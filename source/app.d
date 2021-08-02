module app;

import std.stdio;
import std.string;
import dengine;

import gfm.math;

int main() {
	auto dm = new DisplayManager(800, 600, "dengine");

	auto shader = new ShaderProgram("shaders/vert.glsl", "shaders/frag.glsl");
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

	// change to whatever texture you like (powers of 2 only like 256*256, 512*512, etc.)
	auto gb = new GameObject(vertices, indices, "res/crate1.png");
	auto en = new Entity(gb, vec3f(0, 0, 0), vec3f(0, 0, 1), 1);

	while (!dm.isCloseRequested()) {
		rn.prepare();
		en.increaseRoataion(0, 0, 0.01);

		shader.start();
			rn.render(gb);
			rn.render(en, shader);
		shader.stop();

		dm.update();
	}
	return 0;
}

