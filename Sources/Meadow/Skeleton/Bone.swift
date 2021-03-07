//
//  Bone.swift
//
//  Created by Zack Brown on 15/01/2021.
//

import SceneKit

class Bone: SCNNode, Responder, SceneGraphNode, Soilable {
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    var bones: [Bone] = []
    
    public var children: [SceneGraphNode] { bones }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.blueprint.rawValue }
    
    init(named: Bone.Name) {
        
        super.init()
        
        self.name = name
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Bone {
    
    func add(bone: Bone) {
        
        guard !bones.contains(bone) else { return }
        
        bones.append(bone)
        
        bone.removeFromParentNode()
        bone.ancestor = self
        
        addChildNode(bone)
        
        becomeDirty()
    }
    
    func add(bones: [Bone]) {
        
        for bone in bones {
            
            add(bone: bone)
        }
    }
    
    func find(bone named: Bone.Name) -> Bone? {
        
        return bones.first { $0.name == named.rawValue }
    }
}

extension Bone {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Bone {
    
    enum Name: String {
        
        case hips = "Hips"
        case spine = "Spine"
        case chest = "Chest"
        case neck = "Neck"
        case head = "Head"
        
        case leftArm = "Left Arm"
        case leftForearm = "Left Forearm"
        case leftWrist = "Left Wrist"
        case leftHand = "Left Hand"
        
        case rightArm = "Right Arm"
        case rightForearm = "Right Forearm"
        case rightWrist = "Right Wrist"
        case rightHand = "Right Hand"
        
        case leftThigh = "Left Thigh"
        case leftLeg = "Left Leg"
        case leftAnkle = "Left Ankle"
        case leftFoot = "Left Foot"
        
        case rightThigh = "Right Thigh"
        case rightLeg = "Right Leg"
        case rightAnkle = "Right Ankle"
        case rightFoot = "Right Foot"
    }
    
    enum Structure {
        
        case biped
        case tetrapod
        
        var bones: [Bone] {
            
            switch self {
            
            case .biped:
                
                let hips = Bone(named: .hips)
                let spine = Bone(named: .spine)
                let chest = Bone(named: .chest)
                let neck = Bone(named: .neck)
                let head = Bone(named: .head)
                
                let leftArm = Bone(named: .leftArm)
                let leftForearm = Bone(named: .leftForearm)
                let leftWrist = Bone(named: .leftWrist)
                let leftHand = Bone(named: .leftHand)
                
                let rightArm = Bone(named: .rightArm)
                let rightForearm = Bone(named: .rightForearm)
                let rightWrist = Bone(named: .rightWrist)
                let rightHand = Bone(named: .rightHand)
                
                let leftThigh = Bone(named: .leftThigh)
                let leftLeg = Bone(named: .leftLeg)
                let leftAnkle = Bone(named: .leftAnkle)
                let leftFoot = Bone(named: .leftFoot)
                
                let rightThigh = Bone(named: .rightThigh)
                let rightLeg = Bone(named: .rightLeg)
                let rightAnkle = Bone(named: .rightAnkle)
                let rightFoot = Bone(named: .rightFoot)
                
                hips.add(bones: [spine, leftThigh, rightThigh])
                spine.add(bone: chest)
                chest.add(bones: [neck, leftArm, rightArm])
                neck.add(bone: head)
                leftArm.add(bone: leftForearm)
                leftForearm.add(bone: leftWrist)
                leftWrist.add(bone: leftHand)
                rightArm.add(bone: rightForearm)
                rightForearm.add(bone: rightWrist)
                rightWrist.add(bone: rightHand)
                leftThigh.add(bone: leftLeg)
                leftLeg.add(bone: leftAnkle)
                leftAnkle.add(bone: leftFoot)
                rightThigh.add(bone: rightLeg)
                rightLeg.add(bone: rightAnkle)
                rightAnkle.add(bone: rightFoot)
                
                return [hips, spine, chest, neck, head, leftArm, leftForearm, leftWrist, leftHand, rightArm, rightForearm, rightWrist, rightHand, leftThigh, leftLeg, leftAnkle, leftFoot, rightThigh, rightLeg, rightAnkle, rightFoot]
                
            case .tetrapod:
                
                return []
            }
        }
    }
}
