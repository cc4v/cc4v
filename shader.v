// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc

import sokol.gfx
import sokol.sapp

pub struct Shader {
mut:
	raw gfx.Shader
}

pub fn shader_from_desc(desc &gfx.ShaderDesc) Shader {
	return Shader{raw: gfx.make_shader(desc)}
}

pub fn (s &Shader) raw_shader() gfx.Shader {
	return s.raw
}

pub fn (s &Shader) make_pipeline(mut desc gfx.PipelineDesc) gfx.Pipeline {
	desc.shader = s.raw
	return gfx.make_pipeline(&desc)
}

pub fn (s &Shader) begin(pipeline gfx.Pipeline, bindings &gfx.Bindings) {
	gfx.apply_pipeline(pipeline)
	gfx.apply_bindings(bindings)
}

pub fn (s &Shader) set_uniform(stage gfx.ShaderStage, slot int, data &gfx.Range) {
	gfx.apply_uniforms(stage, slot, data)
}

pub fn (s &Shader) draw(num_elements int) {
	gfx.draw(0, num_elements, 1)
}

pub fn (mut s Shader) destroy() {
	if s.raw.id != 0 {
		gfx.destroy_shader(s.raw)
		s.raw = gfx.Shader{}
	}
}

pub struct ShaderRect {
mut:
	shader Shader
	pipeline gfx.Pipeline
	bindings gfx.Bindings
}

pub fn shader_rect_from_desc(desc &gfx.ShaderDesc, position_attr int) ShaderRect {
	shader := shader_from_desc(desc)
	mut pipeline_desc := gfx.PipelineDesc{}
	pipeline_desc.shader = shader.raw_shader()
	pipeline_desc.primitive_type = .triangle_strip
	swapchain := sapp.glue_swapchain()
	pipeline_desc.colors[0].pixel_format = swapchain.color_format
	pipeline_desc.depth.pixel_format = swapchain.depth_format
	pipeline_desc.sample_count = swapchain.sample_count
	pipeline_desc.layout.attrs[position_attr].format = .float2
	pipeline := gfx.make_pipeline(&pipeline_desc)
	mut bindings := gfx.Bindings{}
	bindings.vertex_buffers[0] = gfx.make_buffer(&gfx.BufferDesc{
		size: usize(8 * sizeof(f32))
		usage: .dynamic
	})
	return ShaderRect{shader: shader, pipeline: pipeline, bindings: bindings}
}

pub fn (mut s ShaderRect) begin() {
	s.shader.begin(s.pipeline, &s.bindings)
}

pub fn (mut s ShaderRect) set_uniform(stage gfx.ShaderStage, slot int, data &gfx.Range) {
	s.shader.set_uniform(stage, slot, data)
}

pub fn (mut s ShaderRect) rect(x f32, y f32, width f32, height f32) {
	screen_width := f32(width_or_default())
	screen_height := f32(height_or_default())
	left := x / screen_width * 2.0 - 1.0
	right := (x + width) / screen_width * 2.0 - 1.0
	top := 1.0 - y / screen_height * 2.0
	bottom := 1.0 - (y + height) / screen_height * 2.0
	vertices := [left, bottom, right, bottom, left, top, right, top]
	range := gfx.Range{ptr: vertices.data, size: usize(vertices.len) * sizeof(f32)}
	gfx.update_buffer(s.bindings.vertex_buffers[0], &range)
	s.shader.draw(4)
}

pub fn (mut s ShaderRect) destroy() {
	if s.bindings.vertex_buffers[0].id != 0 {
		gfx.destroy_buffer(s.bindings.vertex_buffers[0])
	}
	if s.pipeline.id != 0 {
		gfx.destroy_pipeline(s.pipeline)
	}
	s.shader.destroy()
}

fn width_or_default() int {
	value := width()
	return if value > 0 { value } else { 1 }
}

fn height_or_default() int {
	value := height()
	return if value > 0 { value } else { 1 }
}