shader_type spatial;

global uniform vec3 accept_color : source_color;
global uniform vec3 deny_color : source_color;
uniform bool can_accept;

varying vec3 pos;

void vertex(){
	pos = VERTEX;
}

void fragment() {
	if (can_accept){
		ALBEDO = accept_color;
	}
	else{
		ALBEDO = deny_color;
	}
	float freq = 5.0 + 5.0*abs(fract(TIME * 2.14)-0.5);
	float a = abs(sin(pos.x*freq)) + sin(pos.z) + TIME * 2.14;
	float coloring = 1.0 - pow(abs(sin(a)), 6.1);
	ALBEDO *= 0.6 * coloring + 0.4;
	ALPHA = 0.7 * (0.8 * coloring + 0.2);
}
