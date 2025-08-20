-- https://glslsandbox.com/e#370392.0

-- TODO there is a bug when i should use tc(texture_coords) but not _(screen_coords) but i cannot fix it
-- or maybe it is related with the resolution or sth.

-- return love.graphics.newShader([[
--         extern float time;
--         extern vec2 resolution;

--         // Function to generate digital rainbow colors based on a value
--         vec3 digitalRainbow(float value) {
--             float r = clamp(sin(value + 0.0) * 0.5 + 0.5, 0.0, 1.0);
--             float g = clamp(sin(value + 2.0944) * 0.5 + 0.5, 0.0, 1.0);
--             float b = clamp(sin(value + 4.18879) * 0.5 + 0.5, 0.0, 1.0);
--             return vec3(r, g, b);
--         }

--         vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
--             //How to debug a GLSL shader? -- https://stackoverflow.com/questions/2508818/how-to-debug-a-glsl-shader
--             //if(_.x >=5 && _.x <=10)
--             //    return vec4(1.0, 1.0, 1.0, 1.0);
--             //if(tc.x == 0)
--             //   return vec4(1.0, 1.0, 1.0, 1.0);

--             //vec2 uv = _ / resolution;
--             vec2 uv = _ / resolution;
--             //vec2 uv = tc * resolution / resolution;

--             // Introduce random factors to add complexity
--             float randomFactor = fract(sin(dot(uv, vec2(5555555.9898, 9.233))) * 33758.5453);

--             // Calculate flow field direction based on uv coordinates and time
--             float scale = 9.0;
--             float angle = sin(uv.x * scale) + cos(uv.y * scale) + time;
--             vec2 flowDir = vec2(cos(angle), sin(angle));

--             // Apply flow field and random factors to uv coordinates
--             vec2 newUV = uv + flowDir * randomFactor * 0.05;

--             // Create brutalist-style pixel art pattern
--             vec2 scaledUV = newUV * 20.0; // Scale uv coordinates
--             float pixelValue = 1.0 - step(0.5, mod(scaledUV.x + scaledUV.y, 2.0)); // Inverted pattern

--             // Background color (black)
--             vec3 backgroundColor = vec3(0.0);

--             // Digital rainbow colors for the white sections
--             vec3 rainbowColor = digitalRainbow(mod(time + scaledUV.x + scaledUV.y, 6.2831)); // Modulate with time for animation

--             // Combine colors based on pixelValue
--             vec3 finalColor = mix(backgroundColor, rainbowColor, pixelValue);

--             return vec4(finalColor, 1.0);
--         }
-- ]])

--another parameter version------------------------------------------------------------------------------------------
return love.graphics.newShader([[
    extern float time;
    extern vec2 resolution;

    vec3 digitalRainbow(float value) {
        float r = clamp(sin(value + 0.0) * 0.5 + 0.5, 0.0, 1.0);
        float g = clamp(sin(value + 7.0944) * 0.5 + 0.5, 0.0, 1.0);
        float b = clamp(sin(value + 4.18879) * 0.5 + 0.5, 1.0, 1.0);
        return vec3(r, g, b);
    }

    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
        //How to debug a GLSL shader? -- https://stackoverflow.com/questions/2508818/how-to-debug-a-glsl-shader
        //if(_.x >=5 && _.x <=10)
        //    return vec4(1.0, 1.0, 1.0, 1.0);
        //if(tc.x == 0)
        //   return vec4(1.0, 1.0, 1.0, 1.0);
        //if(tc.x > 0.1 && tc.x < 0.2)
        //   return vec4(1.0, 1.0, 1.0, 1.0);

        //vec2 uv = gl_FragCoord.xy / resolution;//(ok)
        vec2 uv = love_PixelCoord.xy / resolution;//(ok)
        //vec2 uv = _ / resolution;//(ok)

        //vec2 uv = tc; //(with draw canvas its ok)
        //vec2 uv = tc * resolution / resolution;//(wrong)

        // 增加分辨率相关的随机性
        float randomFactor = fract(sin(dot(uv, vec2(9872.0, 1124.0))) * 2222502.0);
        
        // Calculate flow field direction based on uv coordinates and time
        float scale = 9.0;
        float angle = sin(uv.x * scale * 1.0) + cos(uv.y * scale * 1.0) + time;
        vec2 flowDir = vec2(cos(angle), sin(angle));
        
        // Apply flow field and random factors to uv coordinates
        vec2 newUV = uv + flowDir * randomFactor * 0.05;
        
        // Create brutalist-style pixel art pattern
        vec2 scaledUV = newUV * 30.0; // Scale uv coordinates
        float pixelValue = 1.0 - step(0.5, mod(scaledUV.x + scaledUV.y, 2.5)); // Inverted pattern
        
        // Background color (black)
        vec3 backgroundColor = vec3(0.0);
        
        // Digital rainbow colors for the white sections
        vec3 rainbowColor = digitalRainbow(mod(time + scaledUV.x + scaledUV.y, 6.2831)); // Modulate with time for animation
        
        // Combine colors based on pixelValue
        vec3 finalColor = mix(backgroundColor, rainbowColor, pixelValue);

        return vec4(finalColor, 1.0);
    }
]])

-- webGL version------------------------------------------------------------------------------------------------------

-- #ifdef GL_ES
-- precision mediump float;
-- #endif

-- uniform float time; // Time uniform to control animation
-- uniform vec2 resolution; // Screen resolution

-- // Function to generate digital rainbow colors based on a value
-- vec3 digitalRainbow(float value) {
--     float r = clamp(sin(value + 0.0) * 0.5 + 0.5, 0.0, 1.0);
--     float g = clamp(sin(value + 2.0944) * 0.5 + 0.5, 0.0, 1.0);
--     float b = clamp(sin(value + 4.18879) * 0.5 + 0.5, 0.0, 1.0);
--     return vec3(r, g, b);
-- }

-- void main() {
--     vec2 uv = gl_FragCoord.xy / resolution.xy; // Normalize coordinates
    
--     // Introduce random factors to add complexity
--     float randomFactor = fract(sin(dot(uv, vec2(5555555.9898, 9.233))) * 33758.5453);
    
--     // Calculate flow field direction based on uv coordinates and time
--     float scale = 9.0;
--     float angle = sin(uv.x * scale) + cos(uv.y * scale) + time;
--     vec2 flowDir = vec2(cos(angle), sin(angle));
    
--     // Apply flow field and random factors to uv coordinates
--     vec2 newUV = uv + flowDir * randomFactor * 0.05;
    
--     // Create brutalist-style pixel art pattern
--     vec2 scaledUV = newUV * 20.0; // Scale uv coordinates
--     float pixelValue = 1.0 - step(0.5, mod(scaledUV.x + scaledUV.y, 2.0)); // Inverted pattern
    
--     // Background color (black)
--     vec3 backgroundColor = vec3(0.0);
    
--     // Digital rainbow colors for the white sections
--     vec3 rainbowColor = digitalRainbow(mod(time + scaledUV.x + scaledUV.y, 6.2831)); // Modulate with time for animation
    
--     // Combine colors based on pixelValue
--     vec3 finalColor = mix(backgroundColor, rainbowColor, pixelValue);
    
--     gl_FragColor = vec4(finalColor, 1.0); // Set fragment color
-- }