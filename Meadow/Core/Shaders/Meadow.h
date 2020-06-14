//
//  Meadow.h
//  Meadow
//
//  Created by Zack Brown on 09/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

#ifndef Meadow_h
#define Meadow_h

#import <simd/simd.h>

#ifdef __cplusplus

using namespace metal;
#include <SceneKit/scn_metal>

namespace Meadow {

    constant float epsilon = 0.0001;

    struct NodeBuffer {
        
        float4x4 modelTransform;
        float4x4 modelViewTransform;
        float4x4 normalTransform;
        float4x4 modelViewProjectionTransform;
    };

    struct SimpleVertex {
        
        float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    };

    struct Vertex {
        
        float3 position [[ attribute(SCNVertexSemanticPosition) ]];
        float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
        float4 color [[ attribute(SCNVertexSemanticColor) ]];
        float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
    };

    struct SimpleFragment {
    
        float4 position [[position]];
        float3 normal;
        half4 color;
        float2 uv;
    };

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
}

#endif

#endif /* Meadow_h */
