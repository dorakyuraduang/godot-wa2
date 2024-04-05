shader_type canvas_item;
uniform vec4 modulate:source_color;

void fragment() {
	vec4 color=texture(TEXTURE,UV);
	color*=modulate;
	COLOR=color;
}

