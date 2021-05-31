//
//  Technique.metal
//
//  Created by Zack Brown on 28/05/2021.
//

#include "Meadow.metal"

vertex Fragment technique_vertex(Vertex v [[ stage_in ]], constant NodeTransforms& scn_node [[buffer(1)]]) {
    
    return {    .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0),
                .normal = normalize(matrix3(scn_node.normalTransform) * v.normal),
                .color = v.color,
                .uv = v.uv };
}

fragment float4 technique_fragment(Fragment f [[stage_in]]) {
    
    return f.color;
}
