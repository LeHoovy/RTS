shader_type spatial;
render_mode wireframe;

uniform sampler2D texture_x: source_color, repeat_enable;
uniform sampler2D texture_y: source_color, repeat_enable;
uniform sampler2D texture_z: source_color, repeat_enable;

varying vec3 world_vertex;
varying vec3 world_normal;
varying vec3 blend;
varying float tex_size_adjust;


void fragment() {
	vec4 vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 normal = normalize((INV_VIEW_MATRIX * vec4(NORMAL, 1.0)).xyz);
	vec3 adjusted_normal = pow(abs(world_normal), blend);
	vec3 weights = adjusted_normal / (adjusted_normal.x + adjusted_normal.y + adjusted_normal.z) * 3.0;

	vec2 uv_x = world_vertex.zy * tex_size_adjust;
	vec2 uv_y = world_vertex.xz * tex_size_adjust;
	vec2 uv_z = world_vertex.xy * tex_size_adjust;

	vec3 color_x = texture(texture_x, uv_x).rgb * weights.x;
	vec3 color_y = texture(texture_y, uv_y).rgb * weights.y;
	vec3 color_z = texture(texture_z, uv_z).rgb * weights.z;

	ALBEDO = (color_x + color_y + color_z) / 3.0;
	//ALBEDO = vec3(adjusted_normal.y);
	//ALBEDO = vec3(abs(test.y));
}

void vertex() {
	world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_vertex.y *= -1.0;

	world_normal = normalize(MODEL_NORMAL_MATRIX * NORMAL);
	//world_normal = NORMAL;

	blend = vec3(4.0);
	tex_size_adjust = 0.125;
}