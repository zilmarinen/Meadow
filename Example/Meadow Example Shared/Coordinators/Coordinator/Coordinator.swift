//
//  Coordinator.swift
//
//  Created by Zack Brown on 14/04/2020.
//

import Foundation

typealias CoordinatorCompletionBlock = () -> Void

public protocol StartOption {}

protocol Coordinatable: AnyObject {
    
    var identifier: String { get }
    
    var parent: Coordinatable? { get set }
    
    var responder: Responder? { get }
    
    var children: [String: Coordinatable] { get }
    
    func start(with option: StartOption?)
    func stop(then completion: CoordinatorCompletionBlock?)
    func coordinator(didFinish coordinator: Coordinatable)
    
    func start(child coordinator: Coordinatable)
    func start(child coordinator: Coordinatable, with option: StartOption?)
    
    func stop(child coordinator: Coordinatable)
    func stop(child coordinator: Coordinatable, then completion: CoordinatorCompletionBlock?)
    
    func stopChildren()
}

open class Coordinator<T>: Responder, Coordinatable {
    
    var controller: T
    
    lazy var identifier: String = {
        
        return String(describing: type(of: self))
    }()
    
    weak var parent: Coordinatable?
    
    private(set) var children: [String : Coordinatable] = [:]
    
    init(controller: T) {
        
        self.controller = controller
        
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(with option: StartOption?) {}
    
    func stop(then completion: CoordinatorCompletionBlock?) {
        
        stopChildren()

        completion?()
    }
    
    func coordinator(didFinish coordinator: Coordinatable) {
        
        stop(child: coordinator)
    }
    
    func start(child coordinator: Coordinatable) {
        
        start(child: coordinator, with: nil)
    }
    
    func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        children[coordinator.identifier] = coordinator
        
        coordinator.parent = self
        
        coordinator.start(with: option)
    }
    
    func stop(child coordinator: Coordinatable) {
        
        stop(child: coordinator, then: nil)
    }
    
    func stop(child coordinator: Coordinatable, then completion: CoordinatorCompletionBlock?) {
        
        coordinator.stop { [unowned self] in
            
            self.children.removeValue(forKey: coordinator.identifier)
            
            coordinator.parent = nil
            
            completion?()
        }
    }
    
    func stopChildren() {
        
        children.values.forEach {
            
            $0.stopChildren()
            
            stop(child: $0)
        }
    }
    
    public override var responder: Responder? { parent as? Responder }
}
