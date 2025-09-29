// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc

import math.vec
import gg
import datatypes

pub struct CCConfig {
pub mut:
	init_fn      ?gg.FNCb
	update_fn    ?gg.FNCb
	draw_fn      ?gg.FNCb
	cleanup_fn   ?gg.FNCb
	user_data    voidptr
}

// CCStyle Reference: https://github.com/openframeworks/openFrameworks/blob/996f7880bc250254480561a2f2dab3554a830084/libs/openFrameworks/graphics/ofGraphicsBaseTypes.h

struct CCStyle {
mut:
	color             gg.Color = gg.black
	text_config       gg.TextCfg
	fill              bool = true
	circle_resolution int = 32
	sphere_resolution int = 32
	curve_resolution  int = 32
}

// ---------------

@[heap]
pub struct CC {
mut:
	config        CCConfig
	current_style CCStyle
	style_history datatypes.Stack[CCStyle]

pub mut:
	gg &gg.Context = unsafe { nil }
}

// ----------------

struct InitialPreference {
mut:
	size       ?vec.Vec2[int]
	init_fn    ?gg.FNCb
	cleanup_fn ?gg.FNCb
	bg_color   ?gg.Color
	title      string = "Canvas"
	user_data  voidptr
}

@[heap]
struct CCContext {
mut:
	cc   &CC = unsafe { nil }
	pref InitialPreference
}


// ----------------
// ----------------


fn (mut c CC) init(_ voidptr) {
	c.apply_style()

	if c.config.init_fn != none {
		c.config.init_fn(c.config.user_data)
	}
}

fn (mut c CC) frame(_ voidptr) {
	if c.config.update_fn != none {
		c.config.update_fn(c.config.user_data)
	}

	c.gg.begin()
	push_matrix()
	push_style()
	if c.config.draw_fn != none {
		c.config.draw_fn(c.config.user_data)
	}
	pop_style()
	pop_matrix()
	c.gg.end()
}

pub fn (c &CC) data[T]() &T {
	return unsafe { c.config.user_data }
}

pub fn (mut c CC) set_data(user_data_ptr voidptr) {
	c.config.user_data = user_data_ptr
}

fn (mut c CC) cleanup(_ voidptr) {
	if c.config.cleanup_fn != none {
		c.config.cleanup_fn(c.config.user_data)
	}
}

fn setup(config CCConfig) {
	mut ctx := context()

	mut w := 400
	mut h := 400
	mut bg_color := gg.white

	mut c := &CC{
		config: config
	}

	if unsafe { ctx.pref.user_data != nil } && unsafe { c.config.user_data == nil } {
		c.config.user_data = ctx.pref.user_data
	}

	if ctx.pref.size != none {
		w = ctx.pref.size.x
		h = ctx.pref.size.y
	}

	if ctx.pref.bg_color != none {
		bg_color = ctx.pref.bg_color
	}

	if c.config.init_fn == none && ctx.pref.init_fn != none {
		c.config.init_fn = ctx.pref.init_fn
	}

	if c.config.cleanup_fn == none && ctx.pref.cleanup_fn != none {
		c.config.cleanup_fn = ctx.pref.cleanup_fn
	}

	c.gg = gg.new_context(
		bg_color:      bg_color
		width:         w
		height:        h
		create_window: true
		window_title:  ctx.pref.title
		init_fn:       c.init
		frame_fn:      c.frame
		cleanup_fn:    c.cleanup
		user_data:     c.config.user_data
	)

	ctx.cc = c

	c.gg.run()
}

fn setup_app(mut app IApp, user_data voidptr) {
	mut config := CCConfig {
		init_fn: fn [mut app] (_ voidptr) {
			app.setup()
		}
		update_fn: fn [mut app] (_ voidptr) {
			app.update()
		}
		draw_fn: fn [mut app] (_ voidptr) {
			app.draw()
		}
		cleanup_fn: fn [mut app] (_ voidptr) {
			app.exit()
		}
		user_data: user_data
	}

	setup(config)
}

// get context
fn context() &CCContext {
	unsafe { 
		mut static ctx := voidptr(0)
		if ctx == nil {
			ctx = &CCContext{} 
		}
		return ctx
	}
}

// get gg context
pub fn g() &gg.Context {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		return unsafe {nil}
	}else{
		return ctx.cc.gg
	}
}

pub fn set_data(dat voidptr) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.user_data = dat
	}else{
		ctx.cc.set_data(dat)
	}
}

pub fn set_data_new[T]() {
	mut ctx := context()
	mut dat := &T{}
	if unsafe { ctx.cc == nil } {
		ctx.pref.user_data = dat
	}else{
		ctx.cc.set_data(dat)
	}
}

pub fn on_init(init_fn fn (voidptr)) {
	mut ctx := context()
	ctx.pref.init_fn = init_fn
}

pub fn on_exit(exit_fn fn (voidptr)) {
	mut ctx := context()
	ctx.pref.cleanup_fn = exit_fn
}

pub fn run(draw_fn fn (voidptr)) {
	setup(CCConfig {
		draw_fn: draw_fn
	})
}

pub fn run_new[T](draw_fn fn (voidptr)){
	setup(CCConfig {
		draw_fn: draw_fn,
		user_data: &T{}
	})
}

pub fn run_app[T](mut app T) {
	setup_app(mut app, app)
}

pub fn run_app_new[T](){
	unsafe {
		mut app := &T{}
		setup_app(mut app, app)
	}
}