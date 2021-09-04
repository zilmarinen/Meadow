//
//  Camera.swift
//
//  Created by Zack Brown on 07/11/2020.
//

import Euclid
import SceneKit

public class Camera: SCNNode, Responder, Soilable, Updatable {
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var category: SceneGraphCategory { .camera }
    
    public lazy var jig: SCNNode = {
        
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = true
        camera.orthographicScale = Constants.maximumZoom
        camera.zNear = 1
        camera.zFar = 200
        camera.fieldOfView = 70
        
        node.camera = camera
        
        return node
    }()
    
    public lazy var controller: CameraController = {
       
        return CameraController(initialState: .focus(node: self, cardinal: .north, zoom: 1.0))
    }()
    
    override init() {
        
        super.init()
        
        name = "Camera"
        categoryBitMask = category.rawValue
        
        addChildNode(jig)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Camera {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Camera {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        switch controller.state {

        case .focus(let node, let cardinal, let zoom):
            
            let zoom = min(max(Constants.minimumZoom, zoom), Constants.maximumZoom)
            
            let angle = Angle(radians: (.pi / 2.0) * Double(cardinal.rawValue) + (.pi / 8.0))
            
            let radius = 10.0 * zoom
            
            var vector = Math.plot(radians: angle.radians, radius: radius)
            
            vector.y = radius
            
            self.position = node.position
            
            jig.position = SCNVector3(vector)
            jig.camera?.orthographicScale = zoom
            jig.look(at: node.position)
        }
    }
}
