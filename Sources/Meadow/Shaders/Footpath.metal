//
//  Footpath.metal
//
//  Created by Zack Brown on 02/02/2021.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

constant float epsilon = 0.0001;

struct NodeBuffer {
    
    float4x4 modelViewProjectionTransform;
};

struct Vertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
    float4 color [[ attribute(SCNVertexSemanticColor) ]];
    float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct Fragment {
    
    float4 position [[position]];
    float3 normal;
    float4 color;
    float2 uv;
    float2 frag;
};

vertex Fragment footpath_vertex(Vertex v [[ stage_in ]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    return {    .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0),
                .normal = v.normal,
                .color = v.color,
                .uv = v.uv,
                .frag = v.position.xz };
}

fragment float4 footpath_fragment(Fragment f [[stage_in]], texture2d<float, access::sample> tileset [[ texture(0) ]]) {
    
    constexpr sampler textureSampler(coord::normalized, filter::linear, address::repeat);
    
    float4 sample = float4(tileset.sample(textureSampler, f.uv));
    
    if (sample.a <= epsilon) {
        
        discard_fragment();
    }
    
    return sample;
}
