#include "/lib/settings.glsl"
#include "/lib/stddef.glsl"

#include "/core/math.glsl"
#include "/core/vertex_transform.glsl"
#include "/core/kernels.glsl"

#ifdef TAA
    uniform vec2 taaOffset;
#endif

out vec3 viewPos;
out vec3 playerPos;
out vec2 coord;
flat out vec3 normal;
flat out vec4 glcolor;

void main() {
	gl_Position = ftransform();

	#ifdef TAA
		gl_Position.xy += taaOffset * TAA_JITTER_AMOUNT * gl_Position.w * 2;
	#endif
	
	normal    = getNormal();
	viewPos   = getView();
	playerPos = toPlayer(viewPos);
	coord     = getCoord();
	glcolor   = gl_Color;
}