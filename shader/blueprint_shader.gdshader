shader_type canvas_item;

uniform vec4 top_color : source_color = vec4(0.05, 0.15, 0.35, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.00, 0.08, 0.20, 1.0);

uniform float grid_size = 32.0;
uniform float line_width = 1.0;
uniform vec4 grid_color : source_color = vec4(1.0, 1.0, 1.0, 0.15);

void fragment() {
    // Gradient
    vec4 bg = mix(top_color, bottom_color, UV.y);

    // Convert UV into pixel coordinates
    vec2 pixel = UV * vec2(TEXTURE_PIXEL_SIZE.x == 0.0 ? 1.0 : 1.0/TEXTURE_PIXEL_SIZE.x,
                           TEXTURE_PIXEL_SIZE.y == 0.0 ? 1.0 : 1.0/TEXTURE_PIXEL_SIZE.y);

    // Grid lines
    float gx = step(mod(pixel.x, grid_size), line_width);
    float gy = step(mod(pixel.y, grid_size), line_width);

    float grid = max(gx, gy);

    COLOR = bg + vec4(grid_color.rgb, grid_color.a * grid);
}
