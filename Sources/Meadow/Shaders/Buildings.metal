//
//  Buildings.metal
//
//  Created by Zack Brown on 02/02/2021.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct NodeBuffer {
    
    float4x4 modelViewProjectionTransform;
};

struct Vertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
    float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct Fragment {
    
    float4 position [[position]];
    float3 normal;
    float2 uv;
    float2 frag;
};

vertex Fragment buildings_vertex(Vertex v [[ stage_in ]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    return {    .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0),
                .normal = v.normal,
                .uv = v.uv,
                .frag = v.position.xz };
}

fragment float4 buildings_fragment(Fragment f [[stage_in]], texture2d<float, access::sample> edgemap [[ texture(0) ]]) {

    constexpr sampler textureSampler(coord::normalized, filter::linear, address::repeat);
    
    return float4(edgemap.sample(textureSampler, f.uv));
}
