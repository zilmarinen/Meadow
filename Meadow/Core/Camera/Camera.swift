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
        
        return CameraObserver(initialState: .focus(node: SCNNode()))
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
    
    func dolly(to: SCNVector3, focus: SCNVector3, ordinal: Ordinal, zoom: Float, delta: TimeInterval) {
        
    }

    func focus(focus: SCNVector3, ordinal: Ordinal, zoom: Float, delta: TimeInterval) {
        
        guard let camera = jig.camera else { return }
        
        let scale = Double(min(max(zoom, Camera.minimumZoomLevel), Camera.maximumZoomLevel))
        
        camera.orthographicScale = scale
        
        let ordinalAngle = (ordinal.rawValue * 90)
        
        let radius = camera.zFar / 2.0
        let yAngle = Math.radians(degrees: 35.0)
        let xzAngle = Math.radians(degrees: Float(ordinalAngle + 42))
        
        let x = focus.x + SKFloat(cos(xzAngle) * radius)
        let y = focus.y + SKFloat(cos(yAngle) * radius)
        let z = focus.z + SKFloat(sin(xzAngle) * radius)
        
        let fv = Vector(vector: focus)
        let pv0 = Vector(vector: jig.position)
        let pv1 = Vector(vector: SCNVector3(x: x, y: y, z: z))
        
        let targetOrientation = Rotation.focus(eye: pv0, focus: fv, up: .up)
        
        position = focus
        
        jig.position = SCNVector3(vector: pv0.lerp(vector: pv1, interpolater: delta))
        
        jig.orientation = SCNQuaternion(quaternion: targetOrientation)
    }
}

extension Camera: Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch observer.state {
            
        case .dolly(let node):
            
            dolly(to: node.position, focus: node.position, ordinal: .northWest, zoom: 70, delta: delta)
            
        case .focus(let node):
            
            focus(focus: node.position, ordinal: .northWest, zoom: 70, delta: delta)
        }
    }
}
