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
                .position = (scn_node.modelViewTransform * float4(v.position, 1.f)).xyz,
                .normal = normalize(v.normal),
                .uv = v.uv };
}

fragment Buffer surface_fragment(Fragment f [[stage_in]],
                                 constant SceneTransforms& scn_frame [[ buffer(0) ]],
                                 constant NodeTransforms& scn_node [[ buffer(1) ]],
                                 texture2d<float, access::sample> tileset [[ texture(0) ]],
                                 texture2d<float, access::sample> edgeset [[ texture(1) ]],
                                 constant Light* scn_lights [[ buffer(2) ]]) {
    
    Surface surface;
    
    surface.normal = f.normal;
    
    if (fabs(dot(up, f.normal)) < epsilon) {

        surface.ambient = sample(edgeset, f.uv);

        surface.ambient = edgeColorLookup(twizzle(surface.ambient, f.color));
    }
    else {

        surface.ambient = sample(tileset, f.uv);

        surface.ambient = tileColorLookup(twizzle(surface.ambient, f.color));
    }
    
    Buffer buffer;
    
    buffer.position = f.fragmentPosition;
    buffer.color = illuminate(surface, scn_lights[0]);
    buffer.normal = float4(f.normal, 0.f);
    
    return buffer;
}
