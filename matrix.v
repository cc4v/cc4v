// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc

import sokol.sgl

pub fn scale(x f32, y f32, z f32) {
	sgl.scale(x, y, z)
}

pub fn translate(x f32, y f32, z f32) {
	sgl.translate(x, y, z)
}

pub fn rotate(angle_rad f32, x f32, y f32, z f32) {
	sgl.rotate(angle_rad, x, y, z)
}