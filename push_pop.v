// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// Reference:
// https://github.com/openframeworks/openFrameworks/blob/996f7880bc250254480561a2f2dab3554a830084/libs/openFrameworks/gl/ofGLProgrammableRenderer.cpp

module cc
import gg
import sokol.sgl
import log

const cc_max_style_history = 32

pub fn push_matrix() {
	sgl.push_matrix()
}

pub fn pop_matrix() {
	sgl.pop_matrix()
}

fn (mut c CC) apply_style() {
	mut style := &c.current_style
	style.text_config = gg.TextCfg{
		...style.text_config
		color: style.color
	}
}

fn (mut c CC) set_style(style &CCStyle) {
	c.current_style = style
	c.apply_style()
}

pub fn push_style() {
	sgl.push_pipeline()

	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.style_history.push(ctx.cc.current_style)
		if ctx.cc.style_history.len() > cc_max_style_history {
			ctx.cc.style_history.pop() or { panic(err) }
			log.warn("cc: push_style() maximum number of style pushes ${cc_max_style_history} reached, did you forget to pop somewhere?")
		}
	}
}

pub fn pop_style() {
	sgl.pop_pipeline()

	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		if ctx.cc.style_history.len() > 0 {
			style := ctx.cc.style_history.pop() or { panic(err) }
			ctx.cc.set_style(style)
		}
	}
}