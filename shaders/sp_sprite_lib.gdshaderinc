// based on https://godotshaders.com/shader/dither-gradient-shader/
float screen_dither_mask(sampler2D dither_pattern, vec2 screen_uv, vec2 screen_pixel_size, vec2 camera_offset, float camera_zoom, float alpha) {
	vec2 screen_size = 1.0 / screen_pixel_size;

	vec2 dither_pattern_size = vec2(textureSize(dither_pattern, 0));
	vec2 dither_pattern_pixel_size = 1.0 / dither_pattern_size;

	vec2 noise_uv = (screen_uv + (camera_offset * camera_zoom * screen_pixel_size))
		* dither_pattern_pixel_size * screen_size / camera_zoom;

	float dither_value = texture(dither_pattern, noise_uv).r;
	float dither_mask = step(dither_value, alpha);

	return dither_mask;
}