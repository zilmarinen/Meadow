//
//  Foliage.metal
//
//  Created by Zack Brown on 09/04/2021.
//

#include "Meadow.metal"

vertex Fragment foliage_vertex(Vertex v [[ stage_in ]], constant NodeTransforms& scn_node [[buffer(1)]]) {
    
    return {    .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0),
                .normal = normalize(matrix3(scn_node.normalTransform) * v.normal),
                .color = v.color,
                .uv = v.uv };
}

fragment float4 foliage_fragment(Fragment f [[stage_in]], texture2d<float, access::sample> foliage [[ texture(0) ]]) {
    
    constexpr sampler image(coord::normalized, filter::linear, address::repeat);
    
    return float4(foliage.sample(image, f.uv));
}
