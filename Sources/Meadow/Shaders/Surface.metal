//
//  Surface.metal
//
//  Created by Zack Brown on 17/12/2020.
//

#include "Meadow.metal"

struct SurfaceFragment {
    
    //clip
    float4 position [[position]];
    float3 normal;
    
    //view
    float3 camera;
    
    //model
    float3 modelNormal;
    float4 color;
    float2 uv;
};

vertex SurfaceFragment surface_vertex(Vertex v [[ stage_in ]],
                                      constant SceneTransforms& scn_frame [[buffer(0)]],
                                      constant NodeTransforms& scn_node [[buffer(1)]]) {
    
    return {    .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0),
                .normal = (scn_node.normalTransform * float4(v.normal, 0.0)).xyz,
                .camera = -(scn_node.modelViewTransform * float4(v.position, 1.0)).xyz,
                .modelNormal = v.normal,
                .color = v.color,
                .uv = v.uv };
}

fragment float4 surface_fragment(SurfaceFragment f [[stage_in]], texture2d<float,
                                 access::sample> tileset [[ texture(0) ]], texture2d<float,
                                 access::sample> edgeset [[ texture(1) ]]) {
    
    float denominator = dot(up, f.modelNormal);
    
    float4 color = float4(0);
    
    if (fabs(denominator) < epsilon) {

        color = sample(edgeset, f.uv);
        
        color = edgeColorLookup(twizzle(color, f.color));
    }
    else {
        
        color = sample(tileset, f.uv);
    
        color = tileColorLookup(twizzle(color, f.color));
    }
    
    return color;
}
