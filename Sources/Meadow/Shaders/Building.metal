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
                .uv = v.uv };
}

fragment float4 building_fragment(Fragment f [[stage_in]],
                                  texture2d<float, access::sample> building [[ texture(0) ]]) {

    constexpr sampler image(coord::normalized, filter::linear, address::repeat);

    return float4(building.sample(image, f.uv));
        
    Surface surface;
    
    surface.normal = f.normal;
    
    return debug(surface, 2);
}
