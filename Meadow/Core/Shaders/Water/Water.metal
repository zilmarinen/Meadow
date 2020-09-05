//
//  Water.metal
//  Meadow
//
//  Created by Zack Brown on 01/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>
#include "../Meadow.h"
using namespace Meadow;

vertex SimpleFragment water_vertex(Vertex v [[ stage_in ]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    SimpleFragment f;
    
    f.position = scn_frame.projectionTransform * scn_frame.viewTransform * scn_node.modelTransform * float4(v.position, 1.0);
    f.normal = v.normal;
    f.color = half4(v.color);
    f.uv = v.uv;
    
    return f;
}

fragment half4 water_fragment(SimpleFragment f [[stage_in]]) {
    
    return half4(f.color);
}
