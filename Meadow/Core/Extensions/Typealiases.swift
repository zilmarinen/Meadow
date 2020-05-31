//
//  Typealiases.swift
//  Meadow
//
//  Created by Zack Brown on 28/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

#if os(macOS)

    public typealias MDWColor = NSColor
    public typealias MDWFloat = CGFloat

#else

    public typealias MDWColor = UIColor
    public typealias MDWFloat = Float

#endif
