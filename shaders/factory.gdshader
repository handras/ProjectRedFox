shader_type spatial;

global uniform vec3 accept_color : source_color;
global uniform vec3 deny_color : source_color;
uniform bool can_accept;

void fragment() {
	if (can_accept){
		ALBEDO = accept_color;
	}
	else{
		ALBEDO = deny_color;
	}
	ALPHA = 0.2;
}
