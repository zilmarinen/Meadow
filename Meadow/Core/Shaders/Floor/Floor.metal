//
//  Floor.metal
//  Meadow
//
//  Created by Zack Brown on 06/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>
#include "../Meadow.h"
using namespace Meadow;

struct Uniform {
    
    float worldFloor;
    
    float4 backgroundColor;
    float4 gridColor;
    
    bool rendersGridLines;
};

struct Fragment {
    
    float4 position [[position]];
    float4 vector;
    
    float worldFloor;
    
    half4 backgroundColor;
    half4 gridColor;
    
    bool rendersGridLines;
};

RayHitTest intersect(Plane plane, Ray ray) {
    
    float denominator = dot(plane.normal, ray.direction);
    
    if (fabs(denominator) < epsilon) {
        
        return RayHitTest { .hit = false };
    }
        
    float3 v0 = (plane.position - ray.origin);
    
    float distance = dot(v0, plane.normal) / denominator;
    
    return RayHitTest { .hit = distance > epsilon, .distance = distance, .vector = ray.origin + (ray.direction * distance) };
}

vertex Fragment floor_vertex(SimpleVertex v [[ stage_in ]], constant Uniform& uniform [[buffer(2)]]) {
    
    Fragment f;
    
    f.position = float4(v.position, 1.0);
    f.vector = float4(v.position, 1.0);
    f.worldFloor = uniform.worldFloor;
    f.backgroundColor = half4(uniform.backgroundColor);
    f.gridColor = half4(uniform.gridColor);
    f.rendersGridLines = uniform.rendersGridLines;
    
    return f;
}

fragment half4 floor_fragment(Fragment f [[stage_in]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    if (!f.rendersGridLines) {
        
        return f.backgroundColor;
    }
    
    float4 position = (scn_frame.inverseViewProjectionTransform * f.vector);
    
    float3 direction = normalize(position.xyz);

    Ray ray = Ray { .origin = float3(0.0), .direction = direction };
    
    float3 worldFloor = (scn_frame.viewTransform * float4(float3(0.0, f.worldFloor, 0.0), 1.0)).xyz;
    
    Plane plane = Plane { .position = worldFloor, .normal = float3(0.0, 1.0, 0.0) };

    RayHitTest hitTest = intersect(plane, ray);

    if(!hitTest.hit) {
        
        return f.backgroundColor;
    }
    
    float2 uv = hitTest.vector.xz;
    
    float2 fractional  = abs(fract(uv + 0.5));
    float2 partial = fwidth(uv);
    
    float2 point = smoothstep(-partial, partial, fractional);
    
    float saturation = 1.0 - saturate(point.x * point.y);
    
    return half4(mix(f.backgroundColor.rgb, f.gridColor.rgb, saturation), 1.0);
}
