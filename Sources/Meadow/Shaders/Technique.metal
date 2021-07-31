//
//  Technique.metal
//
//  Created by Zack Brown on 28/05/2021.
//

#include "Meadow.metal"

struct TechniqueVertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
};

vertex Fragment technique_vertex(TechniqueVertex v [[ stage_in ]]) {
    
    return {.position = v.position };
}

fragment float4 technique_fragment(Fragment f [[stage_in]],
                                   texture2d<float, access::sample> colorBuffer [[ texture(0) ]]) {
    return float4(1.f, 0.f, 0.f, 1.f);
    return sample(colorBuffer, f.fragmentPosition.xy);
}
