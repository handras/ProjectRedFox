shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float amount: hint_range(0.0, 5.0);
uniform float exponent: hint_range(1.0, 7.0);
uniform vec3 vignette_color : source_color;

void fragment() {
    // float asp = (1.0/SCREEN_PIXEL_SIZE.x) / (1.0/SCREEN_PIXEL_SIZE.y);
    vec2 uv = abs(((UV) - 0.5) * 2.0);
    vec2 _exponent = 1.0/pow(uv, vec2(exponent));
    vec2 d = pow(uv/1.82, _exponent)/2.74;
    COLOR.r = amount*length(d);
    COLOR.b = amount*length(d);
    COLOR.g = 0.0;
    vec3 screen = textureLod(screen_texture, SCREEN_UV, amount*length(d)).rgb;
    vec3 result = mix(screen, vignette_color, clamp(length(d), 0.0, 1.0));
    COLOR.rgb = result.rgb;
}