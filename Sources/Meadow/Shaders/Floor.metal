//
//  Floor.metal
//
//  Created by Zack Brown on 17/12/2020.
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
    
    float3 vector;
    float distance;
    bool hit;
};

struct Vertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
};

struct Fragment {
    
    float4 position [[position]];
    float4 frag;
};

struct Uniforms {
  
    float4 backgroundColor;
    float4 gridColor;
    bool drawGrid;
};

RayHitTest intersect(Plane plane, Ray ray) {
    
    float denominator = dot(plane.normal, ray.direction);
    
    if (fabs(denominator) <= epsilon) {
        
        return { .hit = false };
    }
    
    float distance = dot((plane.position - ray.origin), plane.normal) / denominator;
    
    return { .hit = distance >= epsilon, .distance = distance, .vector = ray.origin + (ray.direction * distance) };
}

vertex Fragment floor_vertex(Vertex v [[ stage_in ]], constant SCNSceneBuffer& scn_frame [[buffer(0)]]) {
    
    float4 position = float4(-v.position.x, v.position.z, 0.0, 1.0);
    
    return {
            .position = position,
            .frag = scn_frame.inverseViewProjectionTransform * position };
}

fragment float4 floor_fragment(Fragment f [[stage_in]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant Uniforms& uniforms [[buffer(2)]]) {
    
    if (!uniforms.drawGrid) {
        
        return uniforms.backgroundColor;
    }
    
    float4 origin = scn_frame.viewTransform * float4(0.0, 0.0, 0.0, 1.0);
    float4 normal = scn_frame.viewTransform * float4(0.0, 1.0, 0.0, 0.0);
    float4 direction = normalize(scn_frame.viewTransform * f.frag);

    Ray ray = { .origin = float3(0.0), .direction = direction.xyz };
    
    Plane plane = { .position = origin.xyz, .normal = normal.xyz };

    RayHitTest hitTest = intersect(plane, ray);

    if (!hitTest.hit) {
        
        return uniforms.backgroundColor;
    }
    
    float4 vector = scn_frame.inverseViewTransform * float4(hitTest.vector, 1.0);
    
    float2 uv = vector.xz;
    
    float2 fractional  = abs(fract(uv + 0.5));
    float2 partial = fwidth(uv);
    
    float2 point = smoothstep(-partial, partial, fractional);
    
    float saturation = 1.0 - saturate(point.x * point.y);
    
    return float4(mix(uniforms.backgroundColor.rgb, uniforms.gridColor.rgb, saturation), 1.0);
}
