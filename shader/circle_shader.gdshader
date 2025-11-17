shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float softness : hint_range(0.0, 0.5) = 0.02; // smooth edge

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);
    float edge = smoothstep(radius, radius - softness, dist);
    if (dist > radius) discard; // optional: hard clip instead of smooth edge
    COLOR = color * edge;
}
