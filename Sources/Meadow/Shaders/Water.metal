//
//  Water.metal
//
//  Created by Zack Brown on 26/03/2021.
//

#include "Meadow.metal"

vertex Fragment water_vertex(Vertex v [[ stage_in ]],
                             constant SceneTransforms& scn_frame [[ buffer(0) ]],
                             constant NodeTransforms& scn_node [[ buffer(1) ]]) {
    
    float3 position = v.position;
    
    position.y += sin(scn_frame.sinTime);
    
    return {    .fragmentPosition = scn_node.modelViewProjectionTransform * float4(position, 1.f),
                .position = v.position,
                .normal = v.normal,
                //.color = v.color,
                .uv = v.uv };
}

fragment float4 water_fragment(Fragment f [[stage_in]],
                               constant SceneTransforms& scn_frame [[ buffer(0) ]],
                               constant NodeTransforms& scn_node [[ buffer(1) ]],
                               constant Light* scn_lights [[ buffer(2) ]]) {
    
    float alpha = 1.0;
    
    Surface surface;
     
    surface.normal = f.normal;
    surface.ambient = float4(0.84 * alpha, 0.92 * alpha, 0.89 * alpha, alpha);
    
    return illuminate(surface, scn_lights[0]);
}
