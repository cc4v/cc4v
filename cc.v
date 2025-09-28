module cc

import math.vec
import gg

pub struct CCConfig {
pub mut:
	init_fn ?gg.FNCb
	update_fn ?gg.FNCb
	draw_fn ?gg.FNCb
	cleanup_fn ?gg.FNCb
	user_data voidptr
}

// ---------------

@[heap]
pub struct CC {
mut:
	config CCConfig

pub mut:
	gg &gg.Context = unsafe { nil }
}

// ----------------

struct InitialPreference {
mut:
	size ?vec.Vec2[int]
	init_fn ?gg.FNCb
	cleanup_fn ?gg.FNCb
	bg_color ?gg.Color
	user_data voidptr
}

@[heap]
struct CCContext {
mut:
	cc &CC = unsafe { nil }
	pref InitialPreference
}

fn (mut c CC) init(_ voidptr) {
	if c.config.init_fn != none {
		c.config.init_fn(c.config.user_data)
	}
}

fn (mut c CC) frame(_ voidptr) {
	if c.config.update_fn != none {
		c.config.update_fn(c.config.user_data)
	}

	c.gg.begin()
	if c.config.draw_fn != none {
		c.config.draw_fn(c.config.user_data)
	}
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
		window_title:  'Canvas'
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

pub fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.size = vec.vec2[int](w, h)
	}else{
		ctx.cc.gg.resize(w, h)
	}
}

pub fn background(c gg.Color) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.bg_color = c
	}else{
		ctx.cc.gg.set_bg_color(c)
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