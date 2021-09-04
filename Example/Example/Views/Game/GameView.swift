//
//  GameView.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var controller: GameController
    
    var body: some View {
        
        switch controller.state {
            
        case .initialising(_): EmptyView()
        case .loading(_, let progress, let category): Text("Loading \(category.rawValue): -> \(progress)").foregroundColor(.black)
        default: EmptyView()
        }
    }
}
