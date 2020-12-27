//
//  Terrain.metal
//
//  Created by Zack Brown on 17/12/2020.
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
    float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct Fragment {
    
    float4 position [[position]];
    float3 normal;
    float2 uv;
    float2 frag;
};

vertex Fragment terrain_vertex(Vertex v [[ stage_in ]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    return {    .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0),
                .normal = v.normal,
                .uv = v.uv,
                .frag = v.position.xz };
}

fragment float4 terrain_fragment(Fragment f [[stage_in]], texture2d<float, access::sample> tileset [[ texture(0) ]], texture2d<float, access::sample> edgeset [[ texture(1) ]]) {

    constexpr sampler textureSampler(coord::normalized, filter::linear, address::repeat);
    
    float denominator = dot(float3(0.0, 1.0, 0.0), f.normal);

    if (fabs(denominator) < epsilon) {

        return float4(edgeset.sample(textureSampler, f.uv));
    }
    
    return float4(tileset.sample(textureSampler, f.uv));
}
