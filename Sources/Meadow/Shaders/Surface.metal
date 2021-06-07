//
//  Surface.metal
//
//  Created by Zack Brown on 17/12/2020.
//

#include "Meadow.metal"

vertex Fragment surface_vertex(Vertex v [[ stage_in ]],
                               constant SceneTransforms& scn_frame [[ buffer(0) ]],
                               constant NodeTransforms& scn_node [[ buffer(1) ]]) {
    
    return {    .fragmentPosition = scn_node.modelViewProjectionTransform * float4(v.position, 1.f),
                .position = v.position,
                .normal = v.normal,
                .color = v.color,
                .uv = v.uv };
}

fragment float4 surface_fragment(Fragment f [[stage_in]],
                                 constant SceneTransforms& scn_frame [[ buffer(0) ]],
                                 constant NodeTransforms& scn_node [[ buffer(1) ]],
                                 constant Light* scn_lights [[ buffer(2) ]],
                                 texture2d<float, access::sample> tileset [[ texture(0) ]],
                                 texture2d<float, access::sample> edgeset [[ texture(1) ]]) {
    
    float denominator = dot(up, f.normal);
    
    float4 color = float4(0);

    if (fabs(denominator) < epsilon) {

        color = sample(edgeset, f.uv);

        color = edgeColorLookup(twizzle(color, f.color));
    }
    else {

        color = sample(tileset, f.uv);

        color = tileColorLookup(twizzle(color, f.color));
    }
    
    Surface surface;
    
    surface.view = normalize(-f.position);
    surface.position = f.position;
    surface.normal = normalize(f.normal),
    surface.uv = f.uv;
    surface.ambient = color;
    
    return illuminate(surface, scn_lights[0]);
}
