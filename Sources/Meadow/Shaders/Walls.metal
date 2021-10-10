//
//  Walls.metal
//
//  Created by Zack Brown on 10/08/2021.
//

#include "Meadow.metal"

vertex Fragment walls_vertex(Vertex v [[ stage_in ]],
                               constant SceneTransforms& scn_frame [[ buffer(0) ]],
                               constant NodeTransforms& scn_node [[ buffer(1) ]]) {
    
    return {    .fragmentPosition = scn_node.modelViewProjectionTransform * float4(v.position, 1.f),
                .position = v.position,
                .normal = v.normal,
                .uv = v.uv };
}

fragment float4 walls_fragment(Fragment f [[stage_in]],
                               texture2d<float, access::sample> material [[ texture(0) ]],
                               constant Light* scn_lights [[ buffer(2) ]]) {
    Surface surface;
  
    surface.normal = f.normal;
    surface.ambient = sample(material, f.uv);
  
    return illuminate(surface, scn_lights[0]);
}
