//
//  TypeAliases.swift
//
//  Created by Zack Brown on 06/01/2021.
//

#if os(macOS)

    import AppKit

    public typealias Responder = NSResponder

#else

    import UIKit

    public typealias Responder = UIResponder

#endif
