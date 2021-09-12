module app;

import std.stdio;
import std.string;
import std.conv;

import dengine;


import gfm.math;

import fps_camera;

import std.math;

int main() {
	auto dm = new DisplayManager(1366, 768, "dengine");

	dm.setMouseLocked(true);
	dm.hideCursor(true);

	auto shader = new ShaderProgram("shaders/vert.glsl", "shaders/frag.glsl");
	auto objTestShader = new ShaderProgram("shaders/mesh_v.glsl", "shaders/mesh_f.glsl");
	auto rn = new Renderer(45, 0.1, 100, shader, dm);

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
	auto en1 = new Entity(gb, vec3f(1, 1, 0), vec3f(0, 0, 0), 1);
	//auto cam = new FpsCamera(vec3f(0, 0, 2));
	auto cam = new FpsCamera(vec3f(0, 0, 2));
	auto loader = new ModelLoader();
	auto stall = loader.loadOBJModel("res/stall.obj", "res/crate1.png");
	auto stallEn = new Entity(stall, vec3f(0, -0.5, 0), vec3f(0, 0, 0), 1);
	
	while (!dm.isCloseRequested()) {
		rn.prepare();
		en.increaseRotaion(0, 0, 0.01);
		en1.increaseRotaion(0, 0, -0.01);

		shader.start();
			//cam.use(shader, dm);
			//rn.render(gb);
			cam.move(dm, shader);
			//rn.render(en, shader);
			//rn.render(en1, shader);
			rn.render(stallEn, shader);
		shader.stop();

		// objTestShader.start();
		// 	cam.move(dm, objTestShader);
		// 	rn.render(stallEn, objTestShader);
		// objTestShader.stop();

		dm.update();
		rn.updateProjectionMatrix(dm, shader);
	}
	return 0;
}

