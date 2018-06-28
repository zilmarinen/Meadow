//
//  CameraJib.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 16/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class CameraJib
 @abstract Parent SCNNode used to orient a SCNCamera within a scene.
 */
public class CameraJib: SCNNode {
    
    /*!
     @property stateMachine
     @abstract Creates and initialises a state machine.
     */
    public lazy var stateMachine = {
        
        return CameraJibStateMachine(.focus(SCNVector3Zero, .north, CameraJib.maximumZoomLevel), transition: { (from, to) in
            
            self.stateDidChange(from: from, to: to)
        })
    }()
    
    /*!
     @method init
     @abstract Creates and initialises a SCNNode with a SCNCamera attached.
     */
    public override init() {
        
        super.init()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = true
        
        self.camera = camera
    }
    
    /*!
     @method initWithCoder
     @abstract Support coding and decoding via NSKeyedArchiver.
     */
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraJib {
    
    /*!
     @method stateDidChange:from:to
     @abstract Callback function to handle state machine state transitions.
     */
    func stateDidChange(from: CameraState?, to: CameraState) {
        
        switch to {
            
        default: break
        }
    }
}

extension CameraJib {
    
    /*!
     @method update:deltaTime
     @abstract Update the camera, cleaning its position and rotation as necessary.
     @param deltaTime The time elapsed since the last update.
     */
    public func update(deltaTime: TimeInterval) {
        
        switch stateMachine.state {
            
        case .focus(let vector, let edge, let zoomLevel):
            
            focus(focus: vector, edge: edge, zoomLevel: zoomLevel, deltaTime: deltaTime)
        }
    }
}

extension CameraJib {
    
    /*!
     @property minimumZoomLevel
     @abstract Defines the minimum zoom level of the CameraJib
     */
    static var minimumZoomLevel: MDWFloat = 1.0
    
    /*!
     @property maximumZoomLevel
     @abstract Defines the minimum zoom level of the CameraJib
     */
    static var maximumZoomLevel: MDWFloat = 20.0
}

extension CameraJib {
    
    /*!
     @method focus:focus:edge:deltaTime
     @abstract Update the camera, cleaning its position and rotation as necessary to focus on a specified vector aligned with the given edge.
     @param focus The vector to focus to camera toward.
     @param edge The edge along which the camera should be aligned.
     @param zoomLevel The current zoom level, capped by CameraJib.minimumZoomLevel and CameraJib.maximumZoomLevel.
     @param deltaTime The time elapsed since the last update.
     */
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
        
        let targetOrientation = SCNQuaternion.Focus(vector: targetPosition, focus: focus, up: SCNVector3.Up)
        
        let speed =  MDWFloat(deltaTime)
        
        position = SCNVector3.Lerp(from: position, to: targetPosition, factor: speed)
        
        orientation = SCNQuaternion.Slerp(from: orientation, to: targetOrientation, factor: speed)
    }
}
