//
//  FBBooleanButton.swift
//  FreeBody
//
//  Created by Jackson Kearl on 1/24/15.
//  Copyright (c) 2015 Applications of Computer Science Club. All rights reserved.
//

import UIKit

class FBBooleanButton: FBButtonNode {
    var enabled: Bool = false;
    
    func switchEnabled() {
        enabled = !enabled;
        if (enabled){
            setTouched(true)
        } else {
            setTouched(false)
        }
    }
}
