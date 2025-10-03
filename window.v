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

pub fn title(str string) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.title = str
	}else{
		gg.set_window_title(str)
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

pub fn mouse_button() gg.MouseButton {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.last_mousebutton
	}else{
		return .invalid // WORKAROUND
	}
}

pub fn mouse_pressed() bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.last_mousedown
	}else{
		return false // WORKAROUND
	}
}

pub fn mouse_released() bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return !ctx.cc.last_mousedown
	}else{
		return true // WORKAROUND
	}
}

pub fn mouse_just_pressed(mouse_button gg.MouseButton) bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		c := ctx.cc
		return c.last_mousedown && c.last_mousebutton == mouse_button
			&& (c.prev_mousebutton != c.last_mousebutton || c.prev_mousedown != c.last_mousedown)
	}else{
		return false // WORKAROUND
	}
}

pub fn mouse_just_released(mouse_button gg.MouseButton) bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		c := ctx.cc
		return !c.last_mousedown && c.last_mousebutton == mouse_button
			&& (c.prev_mousebutton != c.last_mousebutton || c.prev_mousedown != c.last_mousedown)
	}else{
		return false // WORKAROUND
	}
}

pub fn key() gg.KeyCode {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.last_keycode
	}else{
		return .invalid // WORKAROUND
	}
}

pub fn key_pressed() bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.last_keydown
	}else{
		return false // WORKAROUND
	}
}

pub fn key_released() bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return !ctx.cc.last_keydown
	}else{
		return true // WORKAROUND
	}
}

pub fn key_just_pressed(keycode gg.KeyCode) bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		c := ctx.cc
		return c.last_keydown && c.last_keycode == keycode
			&& (c.prev_keycode != c.last_keycode || c.prev_keydown != c.last_keydown)
	}else{
		return false // WORKAROUND
	}
}

pub fn key_just_released(keycode gg.KeyCode) bool {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		c := ctx.cc
		return !c.last_keydown && c.last_keycode == keycode
			&& (c.prev_keycode != c.last_keycode || c.prev_keydown != c.last_keydown)
	}else{
		return false // WORKAROUND
	}
}