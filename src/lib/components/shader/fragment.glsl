precision highp float;

varying vec2 vUv;
uniform float uTime;
uniform float uHeight;
uniform float uWidth;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float posSin(float x) { return (sin(x) + 1.0) / 2.0; }

void main() {
    float bandFrequency = 60.0;
    float yFromCenter = abs(vUv.y - 0.5) * 2.0;
    vec2 avUv = vec2(((vUv.x - 0.5) * 0.9* uWidth / uHeight) + 0.5, vUv.y);
    float distFromCenter = length(avUv - vec2(0.5));
    float radialBand = posSin(distFromCenter * bandFrequency - uTime * 2.0);
 
    float baseOpacity = pow(radialBand * pow(yFromCenter, 0.03), mix(50., 1., yFromCenter ));
    float opacity = max(0.15, rand(vUv + uTime) * baseOpacity);
    gl_FragColor = vec4(vec3(.4), opacity);
}
