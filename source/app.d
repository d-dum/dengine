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
	auto rn = new Renderer(45, 0.1, 100, shader, dm);
	
	auto cam = new FpsCamera(vec3f(0, 0, 2));
	auto loader = new ModelLoader();
	auto stall = loader.loadOBJModel("res/stall.obj", "res/crate1.png");
	auto stallEn = new Entity(stall, vec3f(0, -1, 0), vec3f(0, 0, 0), 0.3);
	
	while (!dm.isCloseRequested()) {
		rn.prepare();

		shader.start();
			cam.move(dm, shader);
			rn.render(stallEn, shader);
		shader.stop();

		dm.update();
		rn.updateProjectionMatrix(dm, shader);
	}
	return 0;
}

