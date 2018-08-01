//
//  CameraJib.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 16/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class CameraJib: SCNNode, SceneGraphChild {
    
    public lazy var stateMachine = {
        
        return CameraJibStateMachine(.focus(SCNVector3Zero, .north, CameraJib.maximumZoomLevel), transition: { (from, to) in
            
            self.stateDidChange(from: from, to: to)
        })
    }()

    public override init() {
        
        super.init()
        
        self.name = "Camera"
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = true
        
        self.camera = camera
    }

    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraJib {

    func stateDidChange(from: CameraState?, to: CameraState) {
        
        switch to {
            
        default: break
        }
    }
}

extension CameraJib {

    public func update(deltaTime: TimeInterval) {
        
        switch stateMachine.state {
            
        case .focus(let vector, let edge, let zoomLevel):
            
            focus(focus: vector, edge: edge, zoomLevel: zoomLevel, deltaTime: deltaTime)
        }
    }
}

extension CameraJib {
    
    static var minimumZoomLevel: MDWFloat = 1.0
    static var maximumZoomLevel: MDWFloat = 20.0
}

extension CameraJib {

    func focus(focus: SCNVector3, edge: GridEdge, zoomLevel: MDWFloat, deltaTime: TimeInterval) {
        
        guard let camera = camera else { return }
        
        let scale = Double(min(max(zoomLevel, CameraJib.minimumZoomLevel), CameraJib.maximumZoomLevel))
        
        camera.orthographicScale = scale
        
        let radius = Float(camera.zFar / 2.0)
        let yAngle = Float(45.0)
        let xzAngle = Float((edge.rawValue * 90) + 15)
        let i = GLKMathDegreesToRadians(xzAngle)
        let j = GLKMathDegreesToRadians(yAngle)
        let k = GLKMathDegreesToRadians(xzAngle)
        
        let x = focus.x + MDWFloat(cos(i) * radius)
        let y = focus.y + MDWFloat(sin(j) * radius)
        let z = focus.z + MDWFloat(sin(k) * radius)
        
        let targetPosition = SCNVector3(x: x, y: y, z: z)
        
        let targetOrientation = SCNQuaternion.focus(vector: targetPosition, focus: focus, up: SCNVector3.Up)
        
        let speed =  MDWFloat(deltaTime)
        
        position = SCNVector3.lerp(from: position, to: targetPosition, factor: speed)
        
        orientation = SCNQuaternion.slerp(from: orientation, to: targetOrientation, factor: speed)
    }
}
