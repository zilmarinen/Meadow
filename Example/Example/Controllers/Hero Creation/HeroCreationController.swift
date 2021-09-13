//
//  HeroCreationController.swift
//
//  Created by Zack Brown on 13/09/2021.
//

import Foundation
import Meadow
import SwiftUI

class HeroCreationController: ObservableObject {
    
    weak var parent: AppController?
    
    lazy var viewModel: HeroCreationViewModel = { return HeroCreationViewModel(controller: self) }()
    
    init(parent: AppController? = nil) {
        
        self.parent = parent
    }
}
