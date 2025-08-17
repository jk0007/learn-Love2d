-- https://glslsandbox.com/e#109660.1

return love.graphics.newShader([[
    extern float time;
    extern vec2 resolution;

    vec3 a(float b,vec3 c){
        vec3 d=vec3(3,2,1),e=vec3(0,1,0),f=normalize(vec3(sin(b),1,cos(b)));
        float g=max(.0,dot(c,f));
        return (pow(g,26.)+.2*g*g)*d*2.+max(.0,-dot(c,e))*2.*d+max(.0,dot(c,e))*d.zyx;
    }

    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
        vec2 h = resolution;
        vec3 i=vec3(0,0,-1.5),c=normalize(vec3((-1. + 2.* gl_FragCoord.xy /h.xy)*vec2(h.x/h.y,1),1));
        float j=dot(c,i),k=j*j+1.-dot(i,i),l=-j-sqrt(abs(k)),b=mix(-1.,l,step(.0,min(l,k))),m=time;
        vec3 n=normalize(i+c*b),o=a(m,c),p=a(m,reflect(c,n));
        return vec4(mix(o,p*.5,step(.0,b))*.1,1);
    }
]])