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
	event_fn     ?gg.FNEvent
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
	config         CCConfig
	current_style  CCStyle
	style_history  datatypes.Stack[CCStyle]
	last_keycode   gg.KeyCode
	prev_keycode   gg.KeyCode
	last_keydown   bool
	prev_keydown   bool
	last_mousebutton   gg.MouseButton = .invalid
	prev_mousebutton   gg.MouseButton = .invalid
	last_mousedown bool
	prev_mousedown bool

pub mut:
	gg &gg.Context = unsafe { nil }
}

// ----------------

struct InitialPreference {
mut:
	size       ?vec.Vec2[int]
	init_fn    ?gg.FNCb
	cleanup_fn ?gg.FNCb
	event_fn   ?gg.FNEvent
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

	c.update_prev_key()
}

fn (mut c CC) update_prev_key() {
	c.prev_keycode = c.last_keycode
	c.prev_keydown = c.last_keydown
	c.prev_mousebutton = c.last_mousebutton
	c.prev_mousedown = c.last_mousedown
}

fn (mut c CC) update_last_key(e &gg.Event) {
	if e.typ == .key_down {
		c.last_keydown = true
	}
	if e.typ == .key_up {
		c.last_keydown = false
	}
	if e.typ == .mouse_down {
		c.last_mousedown = true
	}
	if e.typ == .mouse_up {
		c.last_mousedown = false
	}

	if e.typ == .key_down || e.typ == .key_up {
		c.last_keycode = e.key_code
	}

	if e.typ == .mouse_down || e.typ == .mouse_up {
		c.last_mousebutton = e.mouse_button
	}
}

fn (mut c CC) on_event(event &gg.Event, _ voidptr) {
	c.update_last_key(event)

	if c.config.event_fn != none {
		c.config.event_fn(event, c.config.user_data)
	}
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

	if c.config.event_fn == none && ctx.pref.event_fn != none {
		c.config.event_fn = ctx.pref.event_fn
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
		event_fn:      c.on_event
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
		event_fn: fn [mut app] (ev &gg.Event, _ voidptr) {
			app.on_event(ev)
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

pub fn on_event(event_fn fn (&gg.Event, voidptr)) {
	mut ctx := context()
	ctx.pref.event_fn = event_fn
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

pub fn run_with[T](draw_fn fn (voidptr), mut user_data T) {
	setup(CCConfig {
		draw_fn: draw_fn,
		user_data: user_data
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