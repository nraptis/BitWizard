//
//  RectModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/16/22.
//

import UIKit

struct RectModel {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let rect: CGRect
    let color: UIColor
    
    init(id: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        self.id = id
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rect = CGRect(x: x, y: y, width: width, height: height)
        self.color = color
    }
}

extension RectModel: Hashable {
    static func == (lhs: RectModel, rhs: RectModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RectModel: Identifiable {
    
}
