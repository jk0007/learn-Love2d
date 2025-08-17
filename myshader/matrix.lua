
return love.graphics.newShader([[

extern float time;
extern vec2 resolution;

float random(in float x){
    return fract(sin(x)*43758.5453);
}

float random(in vec2 st){
    return fract(sin(dot(st.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float randomChar(in vec2 outer,in vec2 inner){
    float grid = 5.;
    vec2 margin = vec2(.2,.05);
    float seed = 23.;
    vec2 borders = step(margin,inner)*step(margin,1.-inner);
    return step(.5,random(outer*seed+floor(inner*grid))) * borders.x * borders.y;
}

vec3 matrix(in vec2 st){
    float rows = 50.0;
    vec2 ipos = floor(st*rows)+vec2(1.,0.);

    ipos += vec2(.0,floor(time*3.*random(ipos.x)));

    vec2 fpos = fract(st*rows);
    vec2 center = (.5-fpos);

    float pct = random(ipos);
    float glow = (1.-dot(center,center)*3.)*2.0;

    return vec3(0, randomChar(ipos,fpos) * pct * glow, 0);
}

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
	vec2 st = gl_FragCoord.xy / resolution.xy;
    st.y *= resolution.y/resolution.x;

	return vec4(matrix(st),1.0);
}
]])

-- return love.graphics.newShader([[
-- #define R fract(43.*sin(dot(p,p)))
-- extern float time;
-- extern vec2 resolution;

-- //vec4 effect(vec4 o, vec2 i) {

-- vec4 effect(vec4 color, Image texture, vec2 tc, vec2 i) {
--     i = i / resolution;//(ok)
--     vec2 j = fract(i*=.1);
--     vec2 p = vec2(9,int(time*(9.+8.*sin(i-=j).x)))+i;
--     o-=o;
--     o.g=R;
--     p*=j;
--     o*=R>.5&&j.x<.6&&j.y<.8?1.:0.;
--     return o;
-- }
-- ]])