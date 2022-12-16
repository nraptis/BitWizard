//
//  CGSize+Extras.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/17/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

extension CGSize {
    func getAspectFit(_ size: CGSize) -> CGSize {
        var result = CGSize(width: width, height: height)
        if width > 1.0 && height > 1.0 && size.width > 1.0 && size.height > 1.0 {
            if (size.width / size.height) > (width / height) {
                result.width = width
                result.height = (width / size.width) * size.height
            } else {
                result.width = (height / size.height) * size.width
                result.height = height
            }
        }
        return result
    }
    
    func getAspectFill(_ size: CGSize) -> CGSize {
        var result = CGSize(width: width, height: height)
        if width > 1.0 && height > 1.0 && size.width > 1.0 && size.height > 1.0 {
            if (size.width / size.height) < (width / height) {
                result.width = width
                result.height = (width / size.width) * size.height
            } else {
                result.width = (height / size.height) * size.width
                result.height = height
            }
        }
        return result
    }
}


