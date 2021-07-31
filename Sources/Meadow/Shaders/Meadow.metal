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
constant float3 luma = float3(0.299f, 0.587f, 0.114f);

constexpr sampler image(coord::normalized, filter::linear, address::repeat);

struct SceneTransforms {
    
    float4x4 projectionTransform;
    
    float time;
    float sinTime;
    float cosTime;
};

struct NodeTransforms {
    
    float4x4 modelTransform;
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
  
    float4 fragmentPosition [[position]];
    
    float3 position;
    float3 normal;
    
    float4 color;
    float2 uv;
};

struct Buffer {
    
    float4 color  [[ color(0) ]];
    float4 position  [[ color(1) ]];
    float4 normal  [[ color(2) ]];
};

struct Surface {
  
    float3 view;
    float3 position;
    float3 normal;
    float2 uv;
    
    float4 ambient;
    
    float ambientOcclusion;
};

struct Light {
    
    float4 color;
    float3 position;
    float3 direction;
};

inline float4 debug(Surface surface, int mode = 0) {
    
    switch (mode) {
    case 0: return float4(surface.view, 1.f);
    case 1: return float4(surface.position, 1.f);
    case 2: return float4(surface.normal * 0.5f + 0.5f, 1.f);
    case 3: return float4(float3(surface.ambientOcclusion), 1.f);
    default: return surface.ambient;
    }
}

inline float4 illuminate(Surface surface, Light light) {
    
    float strength = 0.1;

    float4 ambient = strength * light.color;

    float4 diffuse = max(dot(surface.normal, light.direction), 0.0) * light.color;

    return (ambient + diffuse) * surface.ambient;
}

inline float4 grayscale(float4 color, float alpha) {
    
    return float4(float3(dot(color.rgb, luma)), alpha);
}

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
        
        return float4(0.796, 0.737, 0.694, 1);
    }
    else if (value == 4) {
        
        return float4(0.30, 0.55, 0.48, 1);
    }
    else if (value == 5) {
        
        return float4(0.91, 0.91, 0.91, 1);
    }
    
    return float4(0, 0, 0, 1);
}

static float4 edgeColorLookup(int value) {
    
    if (value == 0 || value == 4) {
        
        return float4(0.75, 0.62, 0.45, 1);
    }
    else if (value == 1) {
        
        return float4(0.70, 0.57, 0.40, 1);
    }
    else if (value == 2) {
        
        return float4(0.90, 0.78, 0.46, 1);
    }
    else if (value == 3) {
        
        return float4(0.76, 0.70, 0.64, 1);
    }
    else if (value == 5) {
        
        return float4(0.91, 0.91, 0.91, 1);
    }
    
    return float4(0, 0, 0, 1);
}

inline float3x3 mat3(float4x4 mat4) {
    
    return float3x3(mat4[0].xyz, mat4[1].xyz, mat4[2].xyz);
}

/*
 
 vertex commonprofile_io commonprofile_vert(

                                            scn_patch_t                        in                               [[ stage_in ]]

                                            , constant SCNSceneBuffer&         scn_frame                        [[ buffer(0) ]]

                                            , constant commonprofile_node&     scn_node                         [[ buffer(1) ]]

                                            , constant scn_light*              scn_lights                       [[ buffer(2) ]]){
     commonprofile_io out;
     
     
     //
     // MARK: Populating the `_geometry` struct
     //
     
     SCNShaderGeometry _geometry;
     
     _geometry.position = float4(in.position, 1.f);
     _geometry.normal = in.normal;
     _geometry.tangent = in.tangent;
     _geometry.texcoords[0] = in.texcoord0;
     _geometry.color = in.color;
     
     //
     // MARK: Populating the `_surface` struct
     //
     
     // Transform the geometry elements in view space
     _surface.position = (scn_node.modelViewTransform * _geometry.position).xyz;


     float3x3 nrmTransform = scn::mat3(scn_node.modelViewTransform);
     float3 invScaleSquared = 1.f / float3(length_squared(nrmTransform[0]), length_squared(nrmTransform[1]), length_squared(nrmTransform[2]));
     _surface.normal = normalize(nrmTransform * (_geometry.normal * invScaleSquared));


     _surface.tangent = normalize(scn::mat3(scn_node.modelViewTransform) * _geometry.tangent.xyz);

     _surface.view = normalize(-_surface.position);
 
 out.fragmentPosition = scn_node.modelViewProjectionTransform * _geometry.position;

     //
     // MARK: Per-vertex lighting
     //
     
     SCNShaderLightingContribution _lightingContribution(_surface, out);

     _lightingContribution.diffuse = 0.;
     _lightingContribution.specular = 0.;

     _surface.shininess = scn_commonprofile.materialShininess;
     
     out.diffuse = _lightingContribution.diffuse;
     out.specular = _lightingContribution.specular;

     out.position = _surface.position;
     out.normal = _surface.normal;
     out.tangent = _surface.tangent;
     out.vertexColor = _geometry.color;
     out.uv0 = in.texcoord0;
     out.texcoord0 = _geometry.texcoords[0].xy;
     
     out.fragmentPosition = scn_node.modelViewProjectionTransform * _geometry.position;

     out.nodeOpacity = scn_node.nodeOpacity;
     
     return out;
 }
 
 //
 //
 //
 
 fragment SCNOutput commonprofile_frag(commonprofile_io                 in                               [[ stage_in  ]]
                                       , constant commonprofile_uniforms& scn_commonprofile              [[ buffer(0) ]]
                                       , constant SCNSceneBuffer&         scn_frame                      [[ buffer(1) ]]
                                       , constant commonprofile_node&  scn_node                          [[ buffer(2) ]]
                                       , constant scn_light*            scn_lights                       [[ buffer(3) ]]) {

     SCNOutput _output;

     //
     // MARK: Populating the `_surface` struct
     //
     
     SCNShaderSurface _surface;


         _surface.diffuseTexcoord = in.texcoord0;

     _surface.ambientOcclusion = 1.f; // default to no AO

 #ifdef USE_AMBIENT_MAP
     #ifdef USE_AMBIENT_AS_AMBIENTOCCLUSION

     _surface.ambientOcclusion = u_ambientTexture.sample(u_ambientTextureSampler, _surface.ambientTexcoord).r;
     _surface.ambientOcclusion = saturate(mix(1.f, _surface.ambientOcclusion, scn_commonprofile.ambientIntensity));

     _surface.ambient *= in.vertexColor;
     _surface.ambientOcclusion *= u_ssaoTexture.sample( sampler(filter::linear), in.fragmentPosition.xy * scn_frame.inverseResolution.xy ).x;
     

     _surface.diffuse.rgb    *= in.vertexColor.rgb;
     _surface.diffuse        *= in.vertexColor.a; // vertex color are not premultiplied to allow interpolation


     _surface.position = in.position;
     _surface.geometryNormal = normalize(in.normal.xyz);
     _surface.normal = _surface.geometryNormal;
     _surface.tangent = in.tangent;
     _surface.view = normalize(-in.position);
     
     //
     // MARK: Lighting
     //
     
     SCNShaderLightingContribution _lightingContribution(_surface, in);

     _lightingContribution.ambient = scn_frame.ambientLightingColor.rgb;
     _lightingContribution.diffuse = in.diffuse; //saturate?
     _lightingContribution.specular = in.specular;
     

     //
     // MARK: Populating the `_output` struct
     //
     
     _output.color.rgb = illuminate(_surface, _lightingContribution);
     
     //
     // MARK: Fragment shader modifier
     //
     
     _output.color = min(_output.color, float4(160.));

     return _output;
 }
 
 */



/*
 
 extension Pathfinder {
     
     public func path(between origin: PathNode.PathLocus, destination: PathNode.PathLocus) -> Path? {
         
         guard let startNode = pathNode(at: origin), let endNode = pathNode(at: destination) else { return nil }
         
         let queue = PriorityQueue<PathNode>()
         
         var closed: [PathNode: PathNode?] = [startNode : nil]
         
         var cost: [PathNode: Int] = [startNode : 0]
         
         queue.push(node: startNode)
         
         while !queue.isEmpty {
             
             let pathNode = queue.pop()
             
             //
             
             guard let pathNodeCost = cost[pathNode], let neighbours = neighbours(at: pathNode.locus) else { continue }
             
             neighbours.forEach { neighbour in
                 
                 let neighbourNodeCost = pathNodeCost + neighbour.movementCost
                 
                 if !closed.keys.contains(neighbour) && (cost[neighbour] == nil || (neighbourNodeCost < (cost[neighbour] ?? 0))) {
                     
                     cost[neighbour] = neighbourNodeCost
                     
                     neighbour.priority = neighbourNodeCost + heuristic(between: neighbour.locus.coordinate, destination: destination.coordinate)
                     
                     queue.push(node: neighbour)
                     
                     closed[neighbour] = pathNode
                 }
             }
         }
      
         return nil
     }
 }
 
 */
