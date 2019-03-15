//
//  water.metal
//  Meadow
//
//  Created by Zack Brown on 06/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <SceneKit/scn_metal>

struct NodeBuffer {
    
    float4x4 modelTransform;
    float4x4 modelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
};

typedef struct {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
    float4 color [[ attribute(SCNVertexSemanticColor) ]];
    
} VertexIn;

struct FragmentIn {
    
    float4 position [[position]];
    float4 normal [[user(normal)]];
    float4 color [[user(color)]];
};

constant half opacity = 0.7;

vertex FragmentIn water_vertex(VertexIn v [[ stage_in ]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    FragmentIn f;
    
    f.position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0);
    f.normal = scn_node.normalTransform * float4(v.normal, 1.0);
    f.color = v.color;
    
    return f;
}

fragment half4 water_fragment(FragmentIn f [[stage_in]]) {
    
    return half4(half3(f.color.rgb), opacity);
}
