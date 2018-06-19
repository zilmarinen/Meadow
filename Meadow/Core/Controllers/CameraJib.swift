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
        
        return CameraJibStateMachine(.focus(SCNVector3Zero, .north), transition: { (from, to) in
            
            self.stateDidChange(from: from, to: to)
        })
    }()
    
    /*!
     @method init
     @abstract Creates and initialises a SCNNode with a SCNCamera attached.
     */
    override init() {
        
        super.init()
        
        let camera = SCNCamera()
        
        //camera.usesOrthographicProjection = false
        
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
    func update(deltaTime: TimeInterval) {
        
        switch stateMachine.state {
            
        case .focus(let vector, let edge):
            
            focus(focus: vector, edge: edge, deltaTime: deltaTime)
        }
    }
}

extension CameraJib {
    
    /*!
     @method focus:focus:edge:deltaTime
     @abstract Update the camera, cleaning its position and rotation as necessary to focus on a specified vector aligned with the given edge.
     @param focus The vector to focus to camera toward.
     @param edge The edge along which the camera should be aligned.
     @param deltaTime The time elapsed since the last update.
     */
    func focus(focus: SCNVector3, edge: GridEdge, deltaTime: TimeInterval) {
        
        let offset = SCNVector3(x: 5.0, y: 5.0, z: 5.0)
        
        let vector = focus + offset
        
        look(at: focus)
        position = vector
        //rotation = quaternion
        /*
        
        let planarPosition = SCNVector3(x: position.x, y: focus.y, z: position.z)
        
        let forward = SCNVector3.Normalise(vector: planarPosition - focus)
        
        let cross = SCNVector3.Cross(lhs: SCNVector3.Forward, rhs: forward)
        
        let dot = SCNVector3.Dot(lhs: SCNVector3.Forward, rhs: forward)
        
        let quaternion = SCNQuaternion(x: cross.x, y: cross.y, z: cross.z, w: dot + 1)
        
        rotation = SCNQuaternion.Normalise(vector: quaternion)*/
    }
}
