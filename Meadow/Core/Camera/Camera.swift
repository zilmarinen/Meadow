//
//  Camera.swift
//  Meadow
//
//  Created by Zack Brown on 19/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

public class Camera: SCNNode {
    
    public lazy var observer: CameraObserver = {
        
        let node = SCNNode()
        
        node.position = .zero
       
        return CameraObserver(initialState: .focus(node: node))
    }()
    
    lazy var jig: SCNNode = {
    
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = false
        camera.fieldOfView = 20
        
        node.camera = camera
        
        addChildNode(node)

        return node
    }()
}

extension Camera {
    
    public static var minimumZoomLevel: Float = 1.0
    public static var maximumZoomLevel: Float = 100.0
}

extension Camera {

    func focus(focus: SCNVector3, ordinal: Ordinal, zoomLevel: Float, delta: TimeInterval) {
        
        guard let camera = jig.camera else { return }
        
        let scale = Double(min(max(zoomLevel, Camera.minimumZoomLevel), Camera.maximumZoomLevel))
        
        camera.orthographicScale = scale
        
        let radius = Float(camera.zFar / 2.0)
        let yAngle = Float(35.0)
        let xzAngle = Float((ordinal.rawValue * 90) + 42)
        let i = GLKMathDegreesToRadians(xzAngle)
        let j = GLKMathDegreesToRadians(yAngle)
        let k = GLKMathDegreesToRadians(xzAngle)
        
        let x = focus.x + MDWFloat(cos(i) * radius)
        let y = focus.y + MDWFloat(cos(j) * radius)
        let z = focus.z + MDWFloat(sin(k) * radius)
        
        let fv = Vector(vector: focus)
        let pv0 = Vector(vector: jig.position)
        let pv1 = Vector(vector: SCNVector3(x: x, y: y, z: z))
        
        let targetOrientation = Rotation.focus(vector: pv0, focus: fv, up: .up)
        
        position = focus
        
        jig.position = SCNVector3(vector: pv0.lerp(vector: pv1, interpolater: delta))
        
        jig.orientation = SCNQuaternion(quaternion: targetOrientation)
    }
}

extension Camera: Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch observer.state {
            
        case .focus(let node):
            
            focus(focus: node.position, ordinal: .northWest, zoomLevel: 50, delta: delta)
        }
    }
}
