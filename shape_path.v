// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

module cc

import math
import gg
import sokol.sgl

struct PathPoint {
mut:
	x f32
	y f32
}

struct PathCommand {
	kind PathCommandKind
	points []PathPoint
}

enum PathCommandKind {
	move
	line
	bezier
	quadratic
	curve
}

struct PathState {
mut:
	commands []PathCommand
}

pub fn begin_shape() {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.path_state = PathState{}
	}
}

pub fn begin_shape_kind() {
	begin_shape()
}

pub fn vertex(x f32, y f32) {
	push_path_command(.line, [PathPoint{x, y}])
}

pub fn move_to(x f32, y f32) {
	push_path_command(.move, [PathPoint{x, y}])
}

pub fn bezier_vertex(cx1 f32, cy1 f32, cx2 f32, cy2 f32, x f32, y f32) {
	push_path_command(.bezier, [PathPoint{cx1, cy1}, PathPoint{cx2, cy2}, PathPoint{x, y}])
}

pub fn quadratic_vertex(cx f32, cy f32, x f32, y f32) {
	push_path_command(.quadratic, [PathPoint{cx, cy}, PathPoint{x, y}])
}

pub fn curve_vertex(x f32, y f32) {
	push_path_command(.curve, [PathPoint{x, y}])
}

pub fn bezier(x1 f32, y1 f32, cx1 f32, cy1 f32, cx2 f32, cy2 f32, x2 f32, y2 f32) {
	begin_shape()
	move_to(x1, y1)
	bezier_vertex(cx1, cy1, cx2, cy2, x2, y2)
	end_shape(false)
}

pub fn curve(x1 f32, y1 f32, x2 f32, y2 f32, x3 f32, y3 f32, x4 f32, y4 f32) {
	begin_shape()
	curve_vertex(x1, y1)
	curve_vertex(x2, y2)
	curve_vertex(x3, y3)
	curve_vertex(x4, y4)
	end_shape(false)
}

pub fn begin_contour() {
	move_to(f32(math.nan()), f32(math.nan()))
}

pub fn end_contour() {}

pub fn triangle(x1 f32, y1 f32, x2 f32, y2 f32, x3 f32, y3 f32) {
	begin_shape()
	move_to(x1, y1)
	vertex(x2, y2)
	vertex(x3, y3)
	end_shape(true)
}

pub fn arc(x f32, y f32, width f32, height f32, start f32, stop f32) {
	mut ctx := context()
	mut resolution := 32
	if unsafe { ctx.cc != nil } {
		resolution = ctx.cc.current_style.circle_resolution
	}
	steps := int(math.ceil(math.abs(stop - start) / (math.pi * 2.0) * f32(resolution)))
	begin_shape()
	move_to(x, y)
	for i in 0 .. steps + 1 {
		t := f32(i) / f32(steps)
		angle := start + (stop - start) * t
		vertex(x + width * 0.5 * f32(math.cos(angle)), y + height * 0.5 * f32(math.sin(angle)))
	}
	end_shape(true)
}

pub fn end_shape(close bool) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		return
	}
	commands := ctx.cc.path_state.commands.clone()
	ctx.cc.path_state = PathState{}
	mut paths := flatten_path(commands, close)
	if paths.len == 0 {
		return
	}
	color := ctx.cc.current_style.color
	if ctx.cc.current_style.fill {
		draw_filled_paths(paths, color)
	} else {
		for path in paths {
			for i in 0 .. path.len - 1 {
				ctx.cc.gg.draw_line(path[i].x, path[i].y, path[i + 1].x, path[i + 1].y, color)
			}
		}
	}
}

fn push_path_command(kind PathCommandKind, points []PathPoint) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.path_state.commands << PathCommand{kind: kind, points: points}
	}
}

fn flatten_path(commands []PathCommand, close bool) [][]PathPoint {
	mut paths := [][]PathPoint{}
	mut current := []PathPoint{}
	mut i := 0
	mut resolution := 32
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		resolution = ctx.cc.current_style.curve_resolution
	}
	for i < commands.len {
		command := commands[i]
		match command.kind {
			.move {
				if current.len > 0 { paths << current }
				current = []PathPoint{}
				if command.points[0].x == command.points[0].x {
					current << command.points[0]
				}
			}
			.line { current << command.points[0] }
			.bezier {
				if current.len > 0 {
					start := current.last()
					for step in 1 .. resolution + 1 {
						current << cubic(start, command.points[0], command.points[1], command.points[2], f32(step) / f32(resolution))
					}
				}
			}
			.quadratic {
				if current.len > 0 {
					start := current.last()
					for step in 1 .. resolution + 1 {
						current << quadratic(start, command.points[0], command.points[1], f32(step) / f32(resolution))
					}
				}
			}
			.curve {
				mut points := []PathPoint{}
				for i < commands.len && commands[i].kind == .curve {
					points << commands[i].points[0]
					i++
				}
				if points.len >= 4 {
					current << points[1]
					for j in 0 .. points.len - 3 {
						p0, p1, p2, p3 := points[j], points[j + 1], points[j + 2], points[j + 3]
						c1 := add(p1, path_scale(sub(p2, p0), 1.0 / 6.0))
						c2 := sub(p2, path_scale(sub(p3, p1), 1.0 / 6.0))
						for step in 1 .. resolution + 1 {
							current << cubic(p1, c1, c2, p2, f32(step) / f32(resolution))
						}
					}
				}
				continue
			}
		}
		i++
	}
	if current.len > 0 { paths << current }
	if close {
		for mut path in paths {
			if path.len > 1 && distance(path[0], path.last()) > 0.001 { path << path[0] }
		}
	}
	return paths.filter(it.len >= 2)
}

fn draw_filled_paths(paths [][]PathPoint, color gg.Color) {
	for path in paths {
		if path.len < 3 { continue }
		sgl.c4f(color.r, color.g, color.b, color.a)
		sgl.begin_triangles()
		for i in 1 .. path.len - 2 {
			sgl.v2f(path[0].x, path[0].y)
			sgl.v2f(path[i].x, path[i].y)
			sgl.v2f(path[i + 1].x, path[i + 1].y)
		}
		sgl.end()
	}
}

fn cubic(p0 PathPoint, p1 PathPoint, p2 PathPoint, p3 PathPoint, t f32) PathPoint {
	one := 1.0 - t
	return PathPoint{
		x: one * one * one * p0.x + 3.0 * one * one * t * p1.x + 3.0 * one * t * t * p2.x + t * t * t * p3.x
		y: one * one * one * p0.y + 3.0 * one * one * t * p1.y + 3.0 * one * t * t * p2.y + t * t * t * p3.y
	}
}

fn quadratic(p0 PathPoint, p1 PathPoint, p2 PathPoint, t f32) PathPoint {
	one := 1.0 - t
	return PathPoint{x: one * one * p0.x + 2.0 * one * t * p1.x + t * t * p2.x, y: one * one * p0.y + 2.0 * one * t * p1.y + t * t * p2.y}
}

fn add(a PathPoint, b PathPoint) PathPoint { return PathPoint{a.x + b.x, a.y + b.y} }
fn sub(a PathPoint, b PathPoint) PathPoint { return PathPoint{a.x - b.x, a.y - b.y} }
fn path_scale(p PathPoint, factor f32) PathPoint { return PathPoint{p.x * factor, p.y * factor} }
fn distance(a PathPoint, b PathPoint) f32 { return f32(math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y))) }