//
//  Floor.swift
//
//  Created by Zack Brown on 17/12/2020.
//

import SceneKit

public class Floor: SCNNode, Codable, Responder, SceneGraphNode, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case backgroundColor
        case gridColor
        case drawGrid
    }
    
    struct Uniforms: ShaderUniform {
        
        let backgroundColor: vector_float4
        let gridColor: vector_float4
        let drawGrid: Bool
        
        init(backgroundColor: Color, gridColor: Color, drawGrid: Bool) {
         
            self.backgroundColor = vector_float4(x: Float(backgroundColor.red), y: Float(backgroundColor.green), z: Float(backgroundColor.blue), w: Float(backgroundColor.alpha))
            self.gridColor = vector_float4(x: Float(gridColor.red), y: Float(gridColor.green), z: Float(gridColor.blue), w: Float(gridColor.alpha))
            self.drawGrid = drawGrid
        }
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = true
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.floor.rawValue }
    
    public var backgroundColor: Color = Color(red: 0.07, green: 0.07, blue: 0.07) {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var gridColor: Color = Color(red: 0.88, green: 0.11, blue: 0.45) {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var drawGrid: Bool = true {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    override init() {
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        backgroundColor = try container.decode(Color.self, forKey: .backgroundColor)
        gridColor = try container.decode(Color.self, forKey: .gridColor)
        drawGrid = try container.decode(Bool.self, forKey: .drawGrid)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(gridColor, forKey: .gridColor)
        try container.encode(drawGrid, forKey: .drawGrid)
    }
}

extension Floor {
    
    public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        var vertices: [Vertex] = []
        
        for ordinal in Ordinal.allCases {
            
            vertices.append(Vertex(position: ordinal.vector * 2, normal: .up))
        }
        
        let polygon = Polygon(vertices: vertices)
        
        let mesh = Mesh(polygons: [polygon])
        
        let program = SCNProgram()
                
        program.fragmentFunctionName = "floor_fragment"
        program.vertexFunctionName = "floor_vertex"
        program.delegate = self
        program.library = library
        
        let uniforms = Uniforms(backgroundColor: backgroundColor, gridColor: gridColor, drawGrid: drawGrid)
        
        self.geometry = SCNGeometry(mesh: mesh)
        self.geometry?.program = program
        self.geometry?.setValue(uniforms.value, forKey: uniforms.key)
        
        isDirty = false
        
        return true
    }
}

extension Floor: SCNProgramDelegate {
    
    public func program(_ program: SCNProgram, handleError error: Error) {
        
        print("SCNProgram error: \(error)")
    }
}
