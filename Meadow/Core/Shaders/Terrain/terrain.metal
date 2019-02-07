//
//  terrain.metal
//  Meadow-iOS
//
//  Created by Zack Brown on 06/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <SceneKit/scn_metal>

struct VertexIn {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
    float4 color [[ attribute(SCNVertexSemanticColor) ]];
};

struct VertexOut {
    
    float4 position [[position]];
    float4 eyeNormal;
    float4 eyePosition;
    float4 color;
};

struct Uniforms {
    
    float4x4 modelViewMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut terrain_vertex(VertexIn vertexIn [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {
    
    VertexOut vertexOut;
    
    vertexOut.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * float4(vertexIn.position, 1);
    vertexOut.eyeNormal = uniforms.modelViewMatrix * float4(vertexIn.normal, 0);
    vertexOut.eyePosition = uniforms.modelViewMatrix * float4(vertexIn.position, 1);
    vertexOut.color = vertexIn.color;
    
    return vertexOut;
}

fragment float4 terrain_fragment(VertexOut fragmentIn [[stage_in]]) {
    
    return fragmentIn.color;
}

