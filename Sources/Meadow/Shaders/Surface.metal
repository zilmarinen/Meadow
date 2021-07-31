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
    
    Buffer buffer;
    
    buffer.position = f.fragmentPosition;
    buffer.color = color;
    buffer.normal = float4(f.normal, 0.f);
    
    return buffer;
}
