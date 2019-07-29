//
//  AlertController.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit

public class AlertController: SKNode {
    
    public enum Style: Int {
        
        case action
        case alert
    }
    
    let title: String
    
    let message: String
    
    let style: Style
    
    var actions: [AlertAction] = []
    
    var rect: CGRect {
        
        let width = 350
        let height = (style == .alert ? 350 : 420)
        
        return CGRect(x: -(width / 2), y: -(height / 2), width: width, height: height)
    }
    
    lazy var overlay: SKSpriteNode = {
        
        return SKSpriteNode(color: MDWColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5), size: self.scene?.frame.size ?? CGSize.zero)
    }()
    
    lazy var background: SKShapeNode = {
        
        let node = SKShapeNode(rect: rect, cornerRadius: 8)
        
        node.fillColor = .white
        
        return node
    }()
    
    public init(title: String, message: String, style: Style) {
        
        self.title = title
        
        self.message = message
        
        self.style = style
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlertController {
    
    public func add(action: AlertAction) {
        
        guard !actions.contains(action) else { return }
        
        actions.append(action)
        
        actions.sort { (lhs, rhs) -> Bool in
            
            return lhs.style.hashValue > rhs.style.hashValue
        }
    }
    
    func layout() {
        
        addChild(overlay)
        addChild(background)
        
        let buttonHeight = CGFloat(49)
        let halfHeight = (rect.size.height / 2)
        
        switch style {
            
        case .action:
            
            for index in 0..<actions.count {
                
                let action = actions[index]
                
                guard let color = action.style.color else { continue }
                
                let button = SpriteButton(color: color, size: CGSize(width: rect.width, height: buttonHeight)) { (button, eventType) in
                    
                    print("button: \(action.style)")
                    
                    action.callback?(action)
                    
                    guard let scene = self.scene as? SpriteKitScene else { return }
                    
                    scene.model.dismiss()
                }
                
                let offset = (buttonHeight * CGFloat(index))
                
                button.position = CGPoint(x: 0, y: -halfHeight + offset)
                
                let label = SKLabelNode(text: action.title)
                
                label.position.y = -(buttonHeight / 4)
                label.isUserInteractionEnabled = false
                
                button.addChild(label)
                
                background.addChild(button)
            }
            
        case .alert:
            
            print("")
        }
    }
}
