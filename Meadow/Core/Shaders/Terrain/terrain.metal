//
//  terrain.metal
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
    float4 worldPosition [[user(worldPosition)]];
    float4 normal [[user(normal)]];
    float4 color [[user(color)]];
};

vertex FragmentIn terrain_vertex(VertexIn v [[ stage_in ]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    FragmentIn f;
    
    f.position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0);
    f.worldPosition = scn_node.modelTransform * float4(v.position, 1.0);
    f.normal = scn_node.modelTransform * float4(v.normal, 1.0);
    f.color = v.color;
    
    return f;
}

fragment half4 terrain_fragment(FragmentIn f [[stage_in]]) {
    
    if (f.normal.y == 0.0) {
        
        return half4(f.color);
    }
    
    float2 pos = f.worldPosition.xz;
    float2 frac  = abs(fract(pos) - 0.5);
    float2 df = fwidth(pos);
    float2 g = smoothstep(-df , df, frac);
    float grid = 1.0 - saturate(g.x * g.y);
    
    if (grid > 0.1) {
        
        return half4(half3(0.0), 1.0);
    }
    else {
    
        return half4(f.color);
    }
}
