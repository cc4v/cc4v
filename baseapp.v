module cc

pub struct BaseApp {
}

fn (mut app BaseApp) setup() {}
fn (mut app BaseApp) update() {}
fn (mut app BaseApp) draw() {}

interface IApp {
mut:
	setup()
	update()
	draw()
}