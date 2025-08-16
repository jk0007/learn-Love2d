local shader = nil
local time = 0

return love.graphics.newShader([[
        extern float time;
        extern vec2 resolution;

        vec3 digitalRainbow(float value) {
            float r = clamp(sin(value + 0.0) * 0.5 + 0.5, 0.0, 1.0);
            float g = clamp(sin(value + 2.0944) * 0.5 + 0.5, 0.0, 1.0);
            float b = clamp(sin(value + 4.18879) * 0.5 + 0.5, 0.0, 1.0);
            return vec3(r, g, b);
        }

        vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
        
            vec2 uv = _ / resolution;
            //vec2 uv = _ / resolution + 4;
            //vec2 uv = tc * resolution / resolution;
            // 增加分辨率相关的随机性
            float randomFactor = fract(sin(dot(uv, vec2(5555555.9898, 9.233))) * 33758.5453);

            // 流场方向计算
            float scale = 9.0;
            float angle = sin(uv.x * scale) + cos(uv.y * scale) + time;
            vec2 flowDir = vec2(cos(angle), sin(angle));

            // 应用流场和随机因素
            vec2 newUV = uv + flowDir * randomFactor * 0.05;

            // 像素化效果（使用分辨率进行像素化）
            // Create brutalist-style pixel art pattern
            vec2 scaledUV = newUV * 20.0; // Scale uv coordinates
            float pixelValue = 1.0 - step(0.5, mod(scaledUV.x + scaledUV.y, 2.0)); // 交替黑白像素

            // 背景色
            vec3 backgroundColor = vec3(0.0);

            // 动态彩虹色
            vec3 rainbowColor = digitalRainbow(mod(time + scaledUV.x + scaledUV.y, 6.2831));

            // 混合颜色
            vec3 finalColor = mix(backgroundColor, rainbowColor, pixelValue);

            return vec4(finalColor, 1.0);
        }
    ]])

-- function love.update(dt)
--     time = time + dt
-- end

-- function love.draw()
--     love.graphics.setShader(shader)
--     shader:send("time", time)
--     shader:send("resolution", { love.graphics.getWidth(), love.graphics.getHeight() })

--     love.graphics.rectangle("fill", 50, 50, love.graphics.getWidth() - 100, love.graphics.getHeight() - 100)

--     love.graphics.setShader()
-- end

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