//
//  Terrain.metal
//  Meadow
//
//  Created by Zack Brown on 22/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>
#include "../Meadow.h"
using namespace Meadow;

constant float3 gridColor = float3(0.0);

struct Fragment {
    
    float4 position [[position]];
    float3 normal;
    float4 color;
    
    float2 uv;
    float2 xz;
};

vertex Fragment terrain_vertex(Vertex v [[ stage_in ]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    Fragment f;
    
    f.position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0);
    f.normal = v.normal;
    f.color = v.color;
    f.uv = v.uv;
    f.xz = v.position.xz;
    
    return f;
}

fragment float4 terrain_fragment(Fragment f [[stage_in]], texture2d<float, access::sample> uniform [[ texture(0) ]]) {
    
    constexpr sampler textureSampler(coord::normalized, filter::linear, address::repeat);
    
    float4 noise = float4(uniform.sample(textureSampler, f.uv));
    
    float4 color = float4(mix(f.color.rgb, noise.rgb, 0.14), 1.0);
    
    float denominator = dot(float3(0.0, 1.0, 0.0), f.normal);
    
    if (fabs(denominator) < epsilon) {
        
        return color;
    }
    
    float2 fractional  = abs(fract(f.xz + 0.5));
    float2 partial = fwidth(f.xz);
    
    float2 point = smoothstep(-partial, partial, fractional);
    
    float saturation = 1.0 - saturate(point.x * point.y);
    
    return float4(mix(color.rgb, gridColor, saturation), 1.0);
}
