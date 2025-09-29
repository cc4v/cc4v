// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc
import gg
// import log

pub fn background(c gg.Color) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.bg_color = c
	}else{
		ctx.cc.gg.set_bg_color(c)
	}
}

pub fn set_color(c gg.Color){
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.current_style.color = c
		ctx.cc.apply_style()
	}
}

pub fn set_circle_resolution(resolution int){
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.current_style.circle_resolution = resolution
		ctx.cc.apply_style()
	}
}

pub fn set_curve_resolution(resolution int){
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.current_style.curve_resolution = resolution
		ctx.cc.apply_style()
	}
}

pub fn set_sphere_resolution(resolution int){
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.current_style.sphere_resolution = resolution
		ctx.cc.apply_style()
	}
}

pub fn get_color() gg.Color {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.current_style.color
	}else{
		// log.error("cc: failed to get color")
		panic("cc: failed to get color")
	}
}

pub fn fill(){
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.current_style.fill = true
		// ctx.cc.apply_style()
	}
}

pub fn no_fill(){
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.current_style.fill = false
		// ctx.cc.apply_style()
	}
}