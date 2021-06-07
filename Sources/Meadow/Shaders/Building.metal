//
//  Building.metal
//
//  Created by Zack Brown on 26/03/2021.
//

#include "Meadow.metal"

vertex Fragment building_vertex(Vertex v [[ stage_in ]],
                                constant SceneTransforms& scn_frame [[ buffer(0) ]],
                                constant NodeTransforms& scn_node [[ buffer(1) ]]) {
     
    return {    .fragmentPosition = scn_node.modelViewProjectionTransform * float4(v.position, 1.f),
                .position = v.position,
                .normal = v.normal,
                .color = v.color,
                .uv = v.uv };
}

fragment float4 building_fragment(Fragment f [[stage_in]]) {
    
    return f.color;
}
