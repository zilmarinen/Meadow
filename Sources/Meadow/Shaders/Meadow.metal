//
//  Meadow.metal
//
//  Created by Zack Brown on 27/05/2021.
//

using namespace metal;

#include <metal_stdlib>
#include <SceneKit/scn_metal>

constant float epsilon = 0.0001;

constant float3 up = float3(0, 1, 0);
constant float3 luma = float3(0.299f, 0.587f, 0.114f);

struct SceneTransforms {
    
    float4x4 projectionTransform;
    
    float time;
    float sinTime;
    float cosTime;
};

struct NodeTransforms {
    
    float4x4 modelTransform;
    float4x4 modelViewTransform;
    float4x4 modelViewProjectionTransform;
    float4x4 normalTransform;
};

struct Vertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
    float4 color [[ attribute(SCNVertexSemanticColor) ]];
    float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct Fragment {
  
    float4 fragmentPosition [[position]];
    
    float3 position;
    float3 normal;
    
    float4 color;
    float2 uv;
};

struct Buffer {
    
    float4 color  [[ color(0) ]];
    float4 position  [[ color(1) ]];
    float4 normal  [[ color(2) ]];
};

struct Surface {
  
    float3 view;
    float3 position;
    float3 normal;
    float2 uv;
    
    float4 ambient;
    
    float ambientOcclusion;
};

struct Light {
    
    float4 color;
    float3 position;
    float3 direction;
};

inline float4 debug(Surface surface, int mode = 0) {
    
    switch (mode) {
    case 0: return float4(surface.view, 1.f);
    case 1: return float4(surface.position, 1.f);
    case 2: return float4(surface.normal * 0.5f + 0.5f, 1.f);
    case 3: return float4(float3(surface.ambientOcclusion), 1.f);
    default: return surface.ambient;
    }
}

inline float4 illuminate(Surface surface, Light light) {
    return surface.ambient;
    float strength = 0.1;

    float4 ambient = strength * light.color;

    float4 diffuse = max(dot(surface.normal, light.direction), 0.0) * light.color;

    return float4(((ambient + diffuse) * surface.ambient).rgb, 1.0);
}

inline float4 grayscale(float4 color, float alpha) {
    
    return float4(float3(dot(color.rgb, luma)), alpha);
}

inline float4 sample(texture2d<float, access::sample> texture, float2 uv) {
    
    return float4(texture.sample((coord::normalized, filter::linear, address::repeat), uv));
}

inline float4 blend(float4 lhs, float a0, float4 rhs, float a1, float depth) {
    
    float limit = max(lhs.a + a0, rhs.a + a1) - depth;
    
    float c0 = max(lhs.a + a0 - limit, 0.f);
    float c1 = max(rhs.a + a1 - limit, 0.f);
    
    return (lhs * c0 + rhs * c1) / (c0 + c1);
}
