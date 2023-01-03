//
//  PlusSignModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/30/22.
//

import Foundation

struct PlusSignModel {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let rect: CGRect
    init(id: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.id = id
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rect = CGRect(x: x, y: y, width: width, height: height)
    }
}

extension PlusSignModel: Hashable {
    static func == (lhs: PlusSignModel, rhs: PlusSignModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PlusSignModel: Identifiable {
    
}
