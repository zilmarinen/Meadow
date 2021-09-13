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
                .color = v.color,
                .uv = v.uv };
}

fragment Buffer surface_fragment(Fragment f [[stage_in]],
                                 constant SceneTransforms& scn_frame [[ buffer(0) ]],
                                 constant NodeTransforms& scn_node [[ buffer(1) ]],
                                 texture2d<float, access::sample> tileset [[ texture(0) ]],
                                 texture2d<float, access::sample> edgeset [[ texture(1) ]],
                                 texture2d<float, access::sample> dirt [[ texture(2) ]],
                                 texture2d<float, access::sample> sand [[ texture(3) ]],
                                 texture2d<float, access::sample> stone [[ texture(4) ]],
                                 texture2d<float, access::sample> wood [[ texture(5) ]],
                                 constant Light* scn_lights [[ buffer(2) ]]) {
    
    Surface surface;
    
    surface.normal = f.normal;
    
    float2 uv = float2(f.position.x, f.position.z);
    
//    if (f.color.r > 0.f) {
//        
//        surface.ambient += sample(dirt, uv) * f.color.r;
//    }
//    
//    if (f.color.g > 0.f) {
//        
//        surface.ambient += sample(sand, uv) * f.color.g;
//    }
//    
//    if (f.color.b > 0.f) {
//        
//        surface.ambient += sample(stone, uv) * f.color.b;
//    }
    
//    if (f.color.a > 0.f) {
//
//        surface.ambient = sample(dirt, uv) * f.color.a;
//    }
    
    float4 dirtSample = sample(dirt, uv);
    float4 sandSample = sample(sand, uv);
    float4 stoneSample = sample(stone, uv);
    float4 woodSample = sample(wood, uv);
    
    surface.ambient =   ((dirtSample * f.color.r) +
                        (sandSample * f.color.g) +
                        (stoneSample * f.color.b) +
                        (woodSample * f.color.a)) / 4.f;
    
//    if (fabs(dot(up, f.normal)) < epsilon) {
//
//        surface.ambient = sample(edgeset, f.uv);
//
//        surface.ambient = edgeColorLookup(twizzle(surface.ambient, f.color));
//    }
//    else {
//
//        surface.ambient = sample(tileset, f.uv);
//
//        surface.ambient = edgeColorLookup(twizzle(surface.ambient, f.color));
//    }
    
    Buffer buffer;
    
    buffer.position = f.fragmentPosition;
    buffer.color = illuminate(surface, scn_lights[0]);
    buffer.normal = float4(f.normal, 0.f);
    
    return buffer;
}
