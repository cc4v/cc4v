// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc
import math.vec
import gg

pub fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.size = vec.vec2[int](w, h)
	}else{
		ctx.cc.gg.resize(w, h)
	}
}

pub fn mouse_x() int {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.gg.mouse_pos_x
	}else{
		return 0 // WORKAROUND
	}
}

pub fn mouse_y() int {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.gg.mouse_pos_y
	}else{
		return 0 // WORKAROUND
	}
}

pub fn mouse_dx() int {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.gg.mouse_dx
	}else{
		return 0 // WORKAROUND
	}
}

pub fn mouse_dy() int {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.gg.mouse_dy
	}else{
		return 0 // WORKAROUND
	}
}

pub fn scroll_x() int {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.gg.scroll_x
	}else{
		return 0 // WORKAROUND
	}
}

pub fn scroll_y() int {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.gg.scroll_y
	}else{
		return 0 // WORKAROUND
	}
}

pub fn mouse_buttons() gg.MouseButtons {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.gg.mouse_buttons
	}else{
		return unsafe { gg.MouseButtons(0) } // WORKAROUND
	}
}