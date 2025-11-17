shader_type canvas_item;

uniform float blur_radius : hint_range(0.0, 10.0) = 3.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 pixel = TEXTURE_PIXEL_SIZE;
    vec4 accum = vec4(0.0);
    int samples = 0;

    int r = int(clamp(blur_radius, 0.0, 10.0));

    for (int xi = -r; xi <= r; xi++) {
        for (int yi = -r; yi <= r; yi++) {
            vec2 offset = vec2(float(xi), float(yi)) * pixel * 0.5;
            accum += texture(TEXTURE, UV + offset);
            samples++;
        }
    }

    vec4 color = accum / float(samples);

    // Apply opacity
    color.a *= opacity;
    COLOR = color;
}
