shader_type canvas_item;
render_mode blend_add;

uniform vec4 glow_color : source_color = vec4(1.0, 0.9, 0.5, 1.0);
uniform float intensity : hint_range(0.0, 5.0) = 1.5;
uniform float spread    : hint_range(0.1, 2.0) = 1.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 1.0;
uniform bool  pulse_enabled = true; // NEW

void fragment() {
    vec2 centered_uv = UV - vec2(0.5);
    float dist = length(centered_uv) * spread;
    float base = max(0.0, 1.0 - dist);

    float pulse = pulse_enabled && (pulse_speed > 0.0)
        ? sin(TIME * pulse_speed)
        : 0.0; // baseline when stopped

    float alpha = base * (1.0 + 0.2 * pulse);
    alpha = clamp(alpha * intensity, 0.0, 1.0);
    COLOR = glow_color * alpha;
}
