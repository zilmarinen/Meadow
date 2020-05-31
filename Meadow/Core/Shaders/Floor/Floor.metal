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

constant float epsilon = 0.0001;

struct Plane {
    
    float3 position;
    float3 normal;
};

struct Ray {
    
    float3 origin;
    float3 direction;
};

struct RayHitTest {
    
    bool hit;
    float3 vector;
    float distance;
};

struct Uniform {
    
    float worldFloor;
    
    float4 backgroundColor;
    float4 gridColor;
    
    bool rendersGridLines;
};

typedef struct {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    
} Vertex;

struct Fragment {
    
    float4 position [[position]];
    
    float worldFloor;
    
    half4 backgroundColor;
    half4 gridColor;
    
    bool rendersGridLines;
};

RayHitTest intersect(Plane plane, Ray ray) {
    
    float denominator = dot(plane.normal, ray.direction);
    
    if (fabs(denominator) > epsilon) {
        
        float3 difference = normalize(plane.position - ray.origin);
        
        float distance = dot(difference, plane.normal) / denominator;
        
        if (distance > epsilon) {
            
            return RayHitTest { .hit = true, .distance = distance, .vector = ray.origin + (ray.direction * distance) };
        }
    }
    
    return RayHitTest { .hit = false };
}

vertex Fragment floor_vertex(Vertex v [[ stage_in ]], constant Uniform& uniform [[buffer(2)]]) {
    
    Fragment f;
    
    f.position = float4(v.position, 1.0);
    f.worldFloor = uniform.worldFloor;
    f.backgroundColor = half4(uniform.backgroundColor);
    f.gridColor = half4(uniform.gridColor);
    f.rendersGridLines = uniform.rendersGridLines;
    
    return f;
}

fragment half4 floor_fragment(Fragment f [[stage_in]], constant SCNSceneBuffer& scn_frame [[buffer(0)]]) {
    
    if (!f.rendersGridLines) {
        
        return f.backgroundColor;
    }

    float3 position = (scn_frame.inverseProjectionTransform * f.position).xyz;

    float3 camera = (float4(float3(0.0), 1.0)).xyz;
    
    float3 direction = normalize(position - camera);

    Ray ray = Ray { .origin = camera, .direction = direction };
    
    float3 worldFloor = (scn_frame.viewTransform * float4(float3(0.0, f.worldFloor, 0.0), 1.0)).xyz;
    
    Plane plane = Plane { .position = worldFloor, .normal = float3(0.0, 1.0, 0.0) };

    RayHitTest hitTest = intersect(plane, ray);

    if(!hitTest.hit) {
        
        return half4(0.5, 0.5, 0.5, 1.0);
    }
    
    float2 fractional  = abs(fract(hitTest.vector.xz + 0.5));
    float2 partial = fwidth(hitTest.vector.xz);
    
    float2 point = smoothstep(-partial, partial, fractional);
    
    float saturation = 1.0 - saturate(point.x * point.y);
    
    return half4(mix(f.backgroundColor.rgb, f.gridColor.rgb, saturation), 1.0);
}
