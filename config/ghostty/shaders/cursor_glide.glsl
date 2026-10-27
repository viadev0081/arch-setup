const float DURATION   = 0.14;  // seconds for one glide
const float BG_OPACITY = 0.85;  // your background-opacity (text-under-cursor mask threshold)
const float AA         = 1.0;   // edge antialiasing in pixels

vec3 sRGBToLinear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), c));
}

float ease(float x) {
    return 1.0 - pow(1.0 - x, 3.0);
}

float sdfRect(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 rectCenter(vec4 r) {
    return vec2(r.x + r.z * 0.5, r.y - r.w * 0.5);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 tex = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = tex;

    if (iCursorVisible == 0 || iFocus == 0) return;
    if (iCurrentCursorStyle == CURSORSTYLE_BLOCK_HOLLOW ||
        iCurrentCursorStyle == CURSORSTYLE_LOCK) return;

    vec4 cur  = iCurrentCursor;
    vec4 prev = iPreviousCursor;
    if (dot(prev.zw, prev.zw) == 0.0) prev = cur;

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float e = ease(t);

    vec2 center   = mix(rectCenter(prev), rectCenter(cur), e);
    vec2 halfSize = mix(prev.zw, cur.zw, e) * 0.5;
    vec3 rgb      = sRGBToLinear(mix(iPreviousCursorColor.rgb, iCurrentCursorColor.rgb, e));
    vec4 cursor   = vec4(rgb, 1.0);

    float coverage = 1.0 - smoothstep(0.0, AA, sdfRect(fragCoord, center, halfSize));
    if (coverage <= 0.0) return;

    float inTarget = 1.0 - step(0.0, sdfRect(fragCoord, rectCenter(cur), cur.zw * 0.5));
    float text     = smoothstep(min(BG_OPACITY, 0.999), 1.0, tex.a) * inTarget;
    vec4 cursorPixel = mix(cursor, tex, text);

    fragColor = mix(tex, cursorPixel, coverage);
}
