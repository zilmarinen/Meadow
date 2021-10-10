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
                .position = v.position.xyz,
                .normal = normalize(v.normal),
                .color = v.color,
                .uv = v.uv };
}

fragment Buffer surface_fragment(Fragment f [[stage_in]],
                                 constant SceneTransforms& scn_frame [[ buffer(0) ]],
                                 constant NodeTransforms& scn_node [[ buffer(1) ]],
                                 constant Light* scn_lights [[ buffer(2) ]],
                                 texture2d<float, access::sample> overlay [[ texture(0) ]],
                                 texture2d<float, access::sample> dirt [[ texture(2) ]],
                                 texture2d<float, access::sample> sand [[ texture(3) ]],
                                 texture2d<float, access::sample> stone [[ texture(4) ]],
                                 texture2d<float, access::sample> wood [[ texture(5) ]]) {
    
    Surface surface;
    
    surface.normal = f.normal;
    
    float2 uv = float2(f.position.x, f.position.z);
    
    float4 dirtSample = sample(dirt, uv);
    float4 sandSample = sample(sand, uv);
    float4 stoneSample = sample(stone, uv);
    float4 woodSample = sample(wood, uv);
    float4 tileSample = sample(overlay, f.uv);
    
    float depth = 0.1;
    
    surface.ambient = blend(dirtSample, f.color.r, sandSample, f.color.g, depth);
    surface.ambient = blend(surface.ambient, f.color.r + f.color.g, stoneSample, f.color.b, depth);
    surface.ambient = blend(surface.ambient, f.color.r + f.color.g + f.color.b, woodSample, f.color.a, depth);
    
    if (tileSample.a > 0.f && fabs(dot(up, f.normal)) > epsilon) {

        surface.ambient = tileSample;
    }
    
    Buffer buffer;
    
    buffer.position = f.fragmentPosition;
    buffer.color = illuminate(surface, scn_lights[0]);
    buffer.normal = float4(f.normal, 0.f);
    
    return buffer;
}
