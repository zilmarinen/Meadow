//
//  Camera.swift
//
//  Created by Zack Brown on 07/11/2020.
//

import SceneKit

public class Camera: SCNNode, Codable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
     
        case floor
    }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool {
        
        get {
            
            floor.isDirty
        }
        set {
            
            guard !isDirty, newValue else { return }
            
            floor.becomeDirty()
        }
    }
    
    public let floor: Floor
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.camera.rawValue }
    
    public lazy var jig: SCNNode = {
        
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = true
        camera.orthographicScale = Constants.maximumZoom
        
        node.camera = camera
        
        return node
    }()
    
    public lazy var controller: CameraController = {
       
        return CameraController(initialState: .focus(node: SCNNode(), ordinal: .northEast, zoom: 1.0))
    }()
    
    override init() {
        
        self.floor = Floor()
        
        super.init()
        
        name = "Camera"
        categoryBitMask = category
        
        addChildNode(floor)
        addChildNode(jig)
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        box.firstMaterial?.diffuse.contents = MDWColor.systemPink
        
        let node = SCNNode(geometry: box)
        
        addChildNode(node)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        floor = try container.decode(Floor.self, forKey: .floor)
        
        super.init()
        
        name = "Camera"
        categoryBitMask = category
        
        addChildNode(floor)
        addChildNode(jig)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
     
        try container.encode(floor, forKey: .floor)
    }
}

extension Camera {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        floor.clean()
        
        isDirty = false
        
        return true
    }
}

extension Camera {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        switch controller.state {

        case .focus(let node, let ordinal, let zoom):
            
            let zoomScale = (Constants.maximumZoom * zoom)
            
            let pitch = atan(4.0 / 3.0)
            let yaw = Math.radians(degrees: 37 + (90.0 * Double(ordinal.rawValue)))
            
            let adjacent = Double(World.Constants.ceiling - World.Constants.floor)
            let opposite = tan(pitch) * adjacent
            let hypotenuse = sqrt((adjacent * adjacent) + (opposite * opposite))
            
            let x = CGFloat(cos(yaw) * opposite)
            let y = CGFloat(cos(pitch) * hypotenuse)
            let z = CGFloat(sin(yaw) * opposite)
            
            let rotation = Rotation.yaw(radians: -yaw).quaternion
            
            self.position = node.position
            
            jig.position = SCNVector3(x: MDWFloat(x), y: MDWFloat(y), z: MDWFloat(z))
            jig.rotation = SCNQuaternion(quaternion: rotation)
            jig.camera?.orthographicScale = Double(min(max(zoomScale, Constants.minimumZoom), Constants.maximumZoom))
            jig.look(at: node.position)
        }
    }
}
