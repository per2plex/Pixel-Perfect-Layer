// Based on https://godotshaders.com/shader/dither-gradient-shader/
shader_type canvas_item;

global uniform vec2 sp_pixel_camera_offset;
global uniform sampler2D sp_dither_pattern : filter_nearest, repeat_enable;

void light() {
	vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;

	vec2 screen_pixel_position = FRAGCOORD.xy;
	vec2 world_pixel_position = screen_pixel_position + sp_pixel_camera_offset;
	
	vec2 dither_pattern_size = vec2(textureSize(sp_dither_pattern, 0));
	vec2 dither_pattern_pixel_size = 1.0 / dither_pattern_size;
	
	vec2 inv_noise_size = vec2(1.0 / float(dither_pattern_size.x), 1.0 / float(dither_pattern_size.y));
	vec2 noise_uv = world_pixel_position / resolution * inv_noise_size * vec2(float(resolution.x), float(resolution.y));
	
	float dither_value = texture(sp_dither_pattern, noise_uv).r;
	float dither_mask = step(dither_value, LIGHT_COLOR.a);
	
	vec4 light_color = texture(TEXTURE, UV);
	
  LIGHT = vec4(LIGHT_COLOR.rgb * light_color.rgb * LIGHT_ENERGY, dither_mask);
}
