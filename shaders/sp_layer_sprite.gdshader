// Based on https://godotshaders.com/shader/dither-gradient-shader/
shader_type canvas_item;

global uniform vec2 sp_pixel_camera_offset;
global uniform sampler2D sp_dither_pattern : filter_nearest, repeat_enable;

uniform sampler2D SCREEN_TEXUTRE : hint_screen_texture, filter_linear_mipmap;

uniform bool enable_dither_alpha = true;
uniform bool enable_dither_light = true;

void fragment() {
	if (enable_dither_alpha) {
		vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;

		vec2 dither_pattern_size = vec2(textureSize(sp_dither_pattern, 0));
		vec2 dither_pattern_pixel_size = 1.0 / dither_pattern_size;

		vec2 noise_uv = (SCREEN_UV + (sp_pixel_camera_offset * SCREEN_PIXEL_SIZE))
			* dither_pattern_pixel_size * screen_size;

		float dither_value = texture(sp_dither_pattern, noise_uv).r;
		float dither_mask = step(dither_value, COLOR.a);

		COLOR.a = dither_mask;
	}
}

void light() {
	if (enable_dither_light) {
		vec2 screen_size = vec2(textureSize(SCREEN_TEXUTRE, 0));
		vec2 SCREEN_PIXEL_SIZE = 1.0 / screen_size;

		vec2 dither_pattern_size = vec2(textureSize(sp_dither_pattern, 0));
		vec2 dither_pattern_pixel_size = 1.0 / dither_pattern_size;

		vec2 noise_uv = (SCREEN_UV + (sp_pixel_camera_offset * SCREEN_PIXEL_SIZE))
			* dither_pattern_pixel_size * screen_size;

		float dither_value = texture(sp_dither_pattern, noise_uv).r;
		float dither_mask = step(dither_value, LIGHT_COLOR.a);

		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, dither_mask);
	}
}
