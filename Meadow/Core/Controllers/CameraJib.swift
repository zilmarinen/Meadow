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
        
        return CameraJibStateMachine(.focus(SCNVector3Zero), transition: { (from, to) in
            
            self.stateDidChange(from: from, to: to)
        })
    }()
    
    /*!
     @method init
     @abstract Creates and initialises a SCNNode with a SCNCamera attached.
     */
    override init() {
        
        super.init()
        
        self.camera = SCNCamera()
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
    
    func stateDidChange(from: CameraState?, to: CameraState) {
        
        switch to {
            
        case .focus(let vector):
            
            print("focus: \(vector)")
        }
    }
}
