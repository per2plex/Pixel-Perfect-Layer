shader_type canvas_item;
render_mode unshaded;

#include "sp_sprite_lib.gdshaderinc"

global uniform vec2 sp_camera_offset;
global uniform float sp_camera_zoom;
global uniform sampler2D sp_dither_pattern : filter_nearest, repeat_enable;

uniform sampler2D SCREEN_TEXUTRE : hint_screen_texture, filter_linear_mipmap;

uniform bool enable_dither_alpha = true;

void fragment() {
	if (enable_dither_alpha) {
		COLOR.a = screen_dither_mask(
			sp_dither_pattern,
			SCREEN_UV,
			SCREEN_PIXEL_SIZE,
			sp_camera_offset,
			sp_camera_zoom,
			COLOR.a
		);
	}
}
