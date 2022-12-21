//
//  ConceptModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import UIKit

class ConceptModel {
    var id: Int
    var x: CGFloat
    var y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let image: UIImage
    let node: ImageCollectionNode
    let rect: CGRect
    init(id: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat,
         image: UIImage, node: ImageCollectionNode) {
        self.id = id
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.image = image
        self.node = node
        self.rect = CGRect(x: x, y: y, width: width, height: height)
    }
}

extension ConceptModel: Hashable {
    static func == (lhs: ConceptModel, rhs: ConceptModel) -> Bool {
        lhs.node.id == rhs.node.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(node.id)
    }
}

extension ConceptModel: Identifiable {
    
}

extension ConceptModel {
    static func previewWord() -> ConceptModel {
        let app = ApplicationController()
        let node = ImageCollectionNode.previewWord(app: app)
        
        let nodeSize = node.size
        let fitSize = CGSize(width: 120.0, height: 80.0)
        let frame = fitSize.getAspectFit(nodeSize)
        return ConceptModel(id: 3_000_000_005, x: 0, y: 0, width: frame.width, height: frame.height, image: node.image, node: node)
    }
    
    static func previewIdea() -> ConceptModel {
        let app = ApplicationController()
        let node = ImageCollectionNode.previewIdea(app: app)
        
        let nodeSize = node.size
        let fitSize = CGSize(width: 120.0, height: 80.0)
        let frame = fitSize.getAspectFit(nodeSize)
        return ConceptModel(id: 3_000_000_005, x: 0, y: 0, width: frame.width, height: frame.height, image: node.image, node: node)
    }
}
