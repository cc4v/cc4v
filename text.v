// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc
import gg

pub fn text_size(size int) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		text_cfg := ctx.cc.current_style.text_config
		ctx.cc.current_style.text_config = gg.TextCfg{
			...text_cfg,
			size: size
		}
		// ctx.cc.apply_style()
	}
}

pub fn text(msg string, x f32, y f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		draw_text(msg, x, y, ctx.cc.current_style.text_config)
	}
}

fn draw_text(msg string, x f32, y f32, cfg gg.TextCfg) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.gg.draw_text(int(x), int(y), msg, cfg)
	}
}