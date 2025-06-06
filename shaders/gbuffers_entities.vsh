#include "/lib/settings.glsl"
#include "/lib/stddef.glsl"

#include "/core/math.glsl"
#include "/core/kernels.glsl"
#include "/lib/vertex_lighting.glsl"

#ifdef WORLD_CURVE
    #include "/core/vertex_transform.glsl"
#else
    #include "/core/vertex_transform_simple.glsl"
    uniform mat4 gbufferModelView;
#endif

attribute vec4 at_tangent;

#ifdef TAA
    uniform vec2 taaOffset;
#endif

OPT_FLAT out vec4 glcolor;

// Switch on or off Fragment based normal mapping
#ifdef FRAG_NORMALS
	OPT_FLAT out vec3 N;
#else
	OPT_FLAT out mat3 tbn;
#endif

#ifdef PBR
    out vec3 viewpos;
#endif

out vec2 lmcoord;
out vec2 coord;


void main() {
	gl_Position = ftransform();

	#ifdef WORLD_CURVE
		#include "/lib/world_curve.glsl"
	#endif
	
	#ifdef TAA
		gl_Position.xy += taaOffset * TAA_JITTER_AMOUNT * gl_Position.w * 2;
	#endif
	
	#ifdef PBR
	viewpos = getView();
	#endif
	lmcoord = getLmCoord();
	coord   = getCoord();
	#ifdef FRAG_NORMALS
	N  		= getNormal();
	#else
	tbn     = getTBN(at_tangent);
	#endif

	glcolor = gl_Color;
	#ifdef FRAG_NORMALS
	glcolor.rgb *= oldLighting(N, gbufferModelView);
	#else
	glcolor.rgb *= oldLighting(tbn[2], gbufferModelView);
	#endif
}