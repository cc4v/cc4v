// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc
// import gg

pub struct Image {
pub mut:
	id int
}

pub fn load_image(file_path string) !Image {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		image_id := ctx.cc.gg.create_image(file_path)!
		return Image {
			id: image_id.id
		}
	} else {
		panic("load_image cannot be called before run. Please consider to use on_init() or app.setup()")
	}
}

pub fn image(img &Image, x f32, y f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		img_gg := ctx.cc.gg.get_cached_image_by_idx(img.id)
		ctx.cc.gg.draw_image(x, y, img_gg.width, img_gg.height, img_gg)
	}
}

pub fn image_with_size(img &Image, x f32, y f32, width f32, height f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		img_gg := ctx.cc.gg.get_cached_image_by_idx(img.id)
		ctx.cc.gg.draw_image(x, y, width, height, img_gg)
	}
}

pub fn image_3d(img &Image, x f32, y f32, z f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		img_gg := ctx.cc.gg.get_cached_image_by_idx(img.id)
		ctx.cc.gg.draw_image_3d(x, y, z, img_gg.width, img_gg.height, img_gg)
	}
}

pub fn image_3d_with_size(img &Image, x f32, y f32, z f32, width f32, height f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		img_gg := ctx.cc.gg.get_cached_image_by_idx(img.id)
		ctx.cc.gg.draw_image_3d(x, y, z, width, height, img_gg)
	}
}