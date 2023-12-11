shader_type canvas_item;

#include "sp_sprite_lib.gdshaderinc"

global uniform vec2 sp_pixel_camera_offset;
global uniform sampler2D sp_dither_pattern : filter_nearest, repeat_enable;

uniform sampler2D SCREEN_TEXUTRE : hint_screen_texture, filter_linear_mipmap;

uniform bool enable_dither_alpha = true;
uniform bool enable_dither_light = true;

void fragment() {
	if (enable_dither_alpha) {
		COLOR.a = screen_dither_mask(
			sp_dither_pattern,
			SCREEN_UV,
			SCREEN_PIXEL_SIZE,
			sp_pixel_camera_offset,
			1.0,
			COLOR.a
		);
	}
}

void light() {
	if (enable_dither_light) {
		vec2 screen_size = vec2(textureSize(SCREEN_TEXUTRE, 0));
		vec2 SCREEN_PIXEL_SIZE = 1.0 / screen_size;

		float dither_mask = screen_dither_mask(
			sp_dither_pattern,
			SCREEN_UV,
			SCREEN_PIXEL_SIZE,
			sp_pixel_camera_offset,
			1.0,
			LIGHT_COLOR.a
		);

		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, dither_mask);
	} else {
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, LIGHT_COLOR.a);
	}
}
