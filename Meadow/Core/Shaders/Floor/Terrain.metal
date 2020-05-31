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

struct NodeBuffer {
    
    float4x4 modelTransform;
    float4x4 inverseModelTransform;
    float4x4 modelViewTransform;
    float4x4 inverseModelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
    float4x4 inverseModelViewProjectionTransform;
};

typedef struct {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    
} Vertex;

struct Fragment {
    
    float4 position [[position]];
};

vertex Fragment terrain_vertex(Vertex v [[ stage_in ]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    Fragment f;
    
    f.position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0);
    
    return f;
}

fragment half4 terrain_fragment(Fragment f [[stage_in]]) {
    
    return half4(half3(0.0), 1.0);
}
