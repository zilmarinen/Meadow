//
//  SceneKitCamera.swift
//  Meadow
//
//  Created by Zack Brown on 16/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class SceneKitCamera: SCNNode {
    
    public lazy var model = {
        
        return SceneKitCameraStateObserver(initialState: .idle)
    }()

    public override init() {
        
        super.init()
        
        self.name = "Camera"
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = true
        
        self.camera = camera
        
        self.model.subscribe(stateDidChange(from:to:))
    }

    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension SceneKitCamera {

    func stateDidChange(from: CameraState?, to: CameraState) {
        
        switch to {
            
        default: break
        }
    }
}

extension SceneKitCamera: SceneGraphUpdatable {

    public func update(deltaTime: TimeInterval) {
        
        switch model.state {
            
        case .focus(let node, let edge, let zoomLevel):
            
            focus(focus: node.position, edge: edge, zoomLevel: zoomLevel, deltaTime: deltaTime)
            
        default: break
        }
    }
}

extension SceneKitCamera {
    
    public static var minimumZoomLevel: MDWFloat = 1.0
    public static var maximumZoomLevel: MDWFloat = 7.0
}

extension SceneKitCamera {

    func focus(focus: SCNVector3, edge: GridEdge, zoomLevel: MDWFloat, deltaTime: TimeInterval) {
        
        guard let camera = camera else { return }
        
        let scale = Double(min(max(zoomLevel, SceneKitCamera.minimumZoomLevel), SceneKitCamera.maximumZoomLevel))
        
        camera.orthographicScale = scale
        
        let radius = Float(camera.zFar / 2.0)
        let yAngle = Float(35.0)
        let xzAngle = Float((edge.rawValue * 90) + 42)
        let i = GLKMathDegreesToRadians(xzAngle)
        let j = GLKMathDegreesToRadians(yAngle)
        let k = GLKMathDegreesToRadians(xzAngle)
        
        let x = focus.x + MDWFloat(cos(i) * radius)
        let y = focus.y + MDWFloat(sin(j) * radius)
        let z = focus.z + MDWFloat(sin(k) * radius)
        
        let targetPosition = SCNVector3(x: x, y: y, z: z)
        
        let targetOrientation = SCNQuaternion.focus(vector: targetPosition, focus: focus, up: SCNVector3.Up)
        
        //let speed =  MDWFloat(deltaTime)
        
        //position = SCNVector3.lerp(from: position, to: targetPosition, factor: speed)
        
        //orientation = SCNQuaternion.slerp(from: orientation, to: targetOrientation, factor: speed)
        
        position = targetPosition
        orientation = targetOrientation
    }
}
