void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 screen = texture(iChannel0, uv);

    float wave = 0.5 + 0.5 * sin(iTime * 1.7 + uv.y * 8.0);
    float darkBackground = 0.2 - smoothstep(0.05, 0.3, length(screen.rgb));
    vec3 glow = vec3(0.02, 0.04, 0.08) * wave * darkBackground;

    fragColor = vec4(screen.rgb + glow, screen.a);
}
