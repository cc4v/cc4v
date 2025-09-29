// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc
// import gg

pub fn rect(x f32, y f32, w f32, h f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		col := ctx.cc.current_style.color
		if ctx.cc.current_style.fill {
			ctx.cc.gg.draw_rect_filled(x, y, w, h, col)
		} else {
			ctx.cc.gg.draw_rect_empty(x, y, w, h, col)
		}
	}
}

pub fn rounded_rect(x f32, y f32, w f32, h f32, radius f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		col := ctx.cc.current_style.color
		if ctx.cc.current_style.fill {
			ctx.cc.gg.draw_rounded_rect_filled(x, y, w, h, radius, col)
		} else {
			ctx.cc.gg.draw_rounded_rect_empty(x, y, w, h, radius, col)
		}
	}
}

pub fn circle(x f32, y f32, radius f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		col := ctx.cc.current_style.color
		segments := ctx.cc.current_style.circle_resolution
		if ctx.cc.current_style.fill {
			ctx.cc.gg.draw_circle_with_segments(x, y, radius, segments, col)
		} else {
			ctx.cc.gg.draw_circle_line(x, y, int(radius), segments, col)
		}
	}
}
