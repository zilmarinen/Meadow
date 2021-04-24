//
//  Surface.metal
//
//  Created by Zack Brown on 17/12/2020.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

constant float epsilon = 0.0001;

struct NodeBuffer {
    
    float4x4 modelViewProjectionTransform;
};

struct Vertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
    float4 color [[ attribute(SCNVertexSemanticColor) ]];
    float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct Fragment {
    
    float4 position [[position]];
    float3 normal;
    float4 color;
    float2 uv;
    float2 frag;
};

static float4 tileColorLookup(int value) {
    
    if (value == 0) {
        
        return float4(0.81, 0.68, 0.51, 1);
    }
    else if (value == 1) {
        
        return float4(0.85, 0.85, 0.69, 1);
    }
    else if (value == 2) {
        
        return float4(0.96, 0.84, 0.52, 1);
    }
    else if (value == 3) {
        
        return float4(0.30, 0.55, 0.48, 1);
    }
    else if (value == 4) {
        
        return float4(0.81, 0.90, 0.94, 1);
    }
    
    return float4(1, 1, 1, 1);
}

static float4 edgeColorLookup(int value) {
    
    if (value == 0 || value == 1 || value == 3) {
        
        return float4(0.75, 0.62, 0.45, 1);
    }
    else if (value == 2) {
        
        return float4(0.90, 0.78, 0.46, 1);
    }
    else if (value == 4) {
        
        return float4(0.75, 0.84, 0.88, 1);
    }
    
    return float4(1, 1, 1, 1);
}

static float4 illumimate(Fragment f, float4 color) {
    
    float4 ambientColor = float4(1, 1, 1, 1) * color;
     
    float3 normal = normalize(f.normal);
    float diffuseIntensity = saturate(dot(normal, float3(0, -1, 0)));
    float4 diffuseColor = float4(1, 1, 1, 1) * color * diffuseIntensity;
    
    return float4(ambientColor.xyz + diffuseColor.xyz, 1);
}

vertex Fragment surface_vertex(Vertex v [[ stage_in ]], constant NodeBuffer& scn_node [[buffer(1)]]) {
    
    return {    .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.0),
                .normal = v.normal,
                .color = v.color,
                .uv = v.uv,
                .frag = v.position.xz };
}

fragment float4 surface_fragment(Fragment f [[stage_in]], texture2d<float, access::sample> tileset [[ texture(0) ]], texture2d<float, access::sample> edgeset [[ texture(1) ]]) {

    constexpr sampler image(coord::normalized, filter::linear, address::repeat);
    
    float denominator = dot(float3(0.0, 1.0, 0.0), f.normal);
    
    if (fabs(denominator) < epsilon) {

        float4 color = float4(edgeset.sample(image, f.uv));
        
        float value = (color.r + color.g + color.b) / 3;
        
        if (value >= 0.1 && value <= 0.5) {
            
            color = edgeColorLookup(f.color.r);
        }
        else if (value > 0.5 && value <= 0.9) {
            
            color = edgeColorLookup(f.color.g);
        }
        
        return illumimate(f, color);
    }
    
    float4 color = float4(tileset.sample(image, f.uv));
    
    float value = (color.r + color.g + color.b) / 3;
    
    if (value >= 0.1 && value <= 0.5) {
        
        color = tileColorLookup(f.color.r);
    }
    else if (value > 0.5 && value <= 0.9) {
        
        color = tileColorLookup(f.color.g);
    }
    
    return illumimate(f, color);
}
