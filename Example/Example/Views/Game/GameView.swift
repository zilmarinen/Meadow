//
//  GameView.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var model: GameController.GameViewModel
    
    var body: some View {
        
        switch model.state {
            
        case .initialising(_): EmptyView()
        case .loading: Text("Loading").foregroundColor(.black)
        default: EmptyView()
        }
    }
}
