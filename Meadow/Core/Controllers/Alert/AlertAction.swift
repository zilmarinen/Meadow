//
//  AlertAction.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit

public class AlertAction {
    
    public typealias AlertActionCallback = ((AlertAction) -> ())
    
    public enum Style: Int {
        
        case `default`
        case cancel
        case destructive
        
        var color: Color? {
            
            guard let colorPalette = ArtDirector.shared?.palette(named: "AlertAction") else { return nil }
            
            switch self {
            
            case .default: return colorPalette.secondary
            case .cancel: return colorPalette.primary
            case .destructive: return colorPalette.tertiary
            }
        }
    }
    
    let title: String
    
    let style: Style
    
    let callback: AlertActionCallback?
    
    public init(title: String, style: Style, callback: AlertActionCallback? = nil) {
        
        self.title = title
        
        self.style = style
        
        self.callback = callback
    }
}

extension AlertAction: Equatable {
    
    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        
        return lhs.title == rhs.title && lhs.style == rhs.style
    }
}
