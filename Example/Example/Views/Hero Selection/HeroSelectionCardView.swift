//
//  HeroSelectionCardView.swift
//
//  Created by Zack Brown on 13/09/2021.
//

import SwiftUI

struct HeroSelectionCardView: View {
    
    let hero: Hero?
    
    let create: (() -> Void)
    let select: ((Hero) -> Void)
    let delete: ((Hero) -> Void)
    
    @State private var showingAlert = false
    
    var body: some View {
        
        VStack {
            
            if let hero = hero {
                
                Button(hero.name ?? "") {
                    
                    select(hero)
                }
                Spacer()
                Button("Delete") {
                    
                    showingAlert = true
                }
                .alert(isPresented: $showingAlert) {
                    
                    Alert(title: Text("Are you sure you want to delete this?"),
                          message: Text("This can not be undone."),
                          primaryButton: .destructive(Text("Delete")) {
                        
                            delete(hero)
                        },
                          secondaryButton: .cancel()
                    )
                }
            }
            else {
                
                Button("New Game") {
                    
                    create()
                }
            }
        }
        .padding()
        .frame(width: 250, height: 350, alignment: .center)
        .background(Color.red)
        .border(Color.black, width: 3.5)
        .cornerRadius(3.5)
    }
}
