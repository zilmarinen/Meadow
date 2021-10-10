//
//  MenuView.swift
//
//  Created by Zack Brown on 10/10/2021.
//

import SwiftUI

struct MenuView: View {
    
    @ObservedObject var model: AppViewModel
    
    var body: some View {
        
        VStack {
         
            Text("Main Menu")
            
            Button(action: model.startNewGame) {
                
                Label("New Game", systemImage: "gamecontroller")
            }
        }
    }
}
