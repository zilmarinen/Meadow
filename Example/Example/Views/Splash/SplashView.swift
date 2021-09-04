//
//  SplashView.swift
//
//  Created by Zack Brown on 23/08/2021.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject var controller: SplashController
    
    var body: some View {
        
        switch controller.state {
            
        case .application: Text("Application").foregroundColor(.black)
        case .developer: Text("Developer").foregroundColor(.black)
        }
    }
}
