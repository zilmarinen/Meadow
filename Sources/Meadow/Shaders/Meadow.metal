//
//  Meadow.metal
//
//  Created by Zack Brown on 27/05/2021.
//

using namespace metal;

#include <metal_stdlib>
#include <SceneKit/scn_metal>

constant float epsilon = 0.0001;
constant float3 up = float3(0, 1, 0);
constant float4 cold = float4(0.317, 0.768, 0.827, 1.0);
constant float4 warm = float4(0.988, 0.525, 0.129, 1.0);
constexpr sampler image(coord::normalized, filter::linear, address::repeat);

struct SceneTransforms {
    
    float4x4 projectionTransform;
};

struct NodeTransforms {
    
    float4x4 modelViewTransform;
    float4x4 modelViewProjectionTransform;
    float4x4 normalTransform;
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
};

struct Lights {
    
    float4 position0;
    float4 color0;
};

inline float4 sample(texture2d<float, access::sample> texture, float2 uv) {
    
    return float4(texture.sample(image, uv));
}





//
//  TODO:
//  DELETE ALL BELOW
//

inline float3x3 matrix3(float4x4 matrix) {
    
    return float3x3(matrix[0].xyz, matrix[1].xyz, matrix[2].xyz);
}

inline float twizzle(float4 color, float4 source) {
    
    float value = (color.r + color.g + color.b) / 3;
    
    if (value >= 0.1 && value <= 0.5) {
        
        return source.r;
    }
    else if (value > 0.5 && value <= 0.9) {
        
        return source.g;
    }
    
    return -1;
}

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
    else if (value == 5) {
        
        return float4(0.91, 0.91, 0.91, 1);
    }
    
    return float4(0, 0, 0, 1);
}

static float4 edgeColorLookup(int value) {
    
    if (value == 0 || value == 3) {
        
        return float4(0.75, 0.62, 0.45, 1);
    }
    else if (value == 1) {
        
        return float4(0.70, 0.57, 0.40, 1);
    }
    else if (value == 2) {
        
        return float4(0.90, 0.78, 0.46, 1);
    }
    else if (value == 4) {
        
        return float4(0.75, 0.84, 0.88, 1);
    }
    else if (value == 5) {
        
        return float4(0.91, 0.91, 0.91, 1);
    }
    
    return float4(0, 0, 0, 1);
}
