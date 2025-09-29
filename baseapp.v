// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc
import gg

pub struct BaseApp {
}

fn (mut app BaseApp) setup() {}
fn (mut app BaseApp) update() {}
fn (mut app BaseApp) draw() {}
fn (mut app BaseApp) on_event(event &gg.Event) {}
fn (mut app BaseApp) exit() {}

interface IApp {
mut:
	setup()
	update()
	draw()
	on_event(&gg.Event)
	exit()
}