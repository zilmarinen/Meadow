//
//  Footpath.metal
//
//  Created by Zack Brown on 02/02/2021.
//

#include "Meadow.metal"

vertex Fragment footpath_vertex(Vertex v [[ stage_in ]],
                                constant SceneTransforms& scn_frame [[ buffer(0) ]],
                                constant NodeTransforms& scn_node [[ buffer(1) ]]) {

    return {    .fragmentPosition = scn_node.modelViewProjectionTransform * float4(v.position, 1.f),
                .position = v.position,
                .normal = v.normal,
                .color = v.color,
                .uv = v.uv };
}

fragment float4 footpath_fragment(Fragment f [[stage_in]],
                                  texture2d<float, access::sample> image [[ texture(0) ]],
                                  constant Light* scn_lights [[ buffer(2) ]]) {
    Surface surface;
     
    surface.normal = f.normal;
    surface.ambient = sample(image, f.uv);
    
    if (surface.ambient.a <= epsilon) {
        
        discard_fragment();
    }
    
    return illuminate(surface, scn_lights[0]);
}
