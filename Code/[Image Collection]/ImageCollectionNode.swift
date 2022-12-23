//
//  ImageCollectionNode.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import UIKit

enum ImageCollectionNodeType {
    case idea
    case word
}

class ImageCollectionNode {
    
    private static let defaultSize: CGFloat = 32.0
    let app: ApplicationController
    let fileName: String
    let fileExtension: String
    let id: Int
    let cache: ImageCache
    let type: ImageCollectionNodeType
    var didFailToLoad = false
    
    var tempWidth: Int = 0
    var tempHeight: Int = 0
    var tempSelected: Bool = false
    var tempUsed: Bool = false
    
    init(app: ApplicationController, fileName: String, fileExtension: String, id: Int, cache: ImageCache, type: ImageCollectionNodeType) {
        self.app = app
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.id = id
        self.cache = cache
        self.type = type
    }
    
    lazy var path: String = {
        app.bundleDir + fileName + "." + fileExtension
    }()
}

extension ImageCollectionNode {
    var width: CGFloat {
        cache.width(node: self)
    }
    
    var height: CGFloat {
        cache.height(node: self)
    }
    
    var ratioWH: CGFloat {
        cache.ratioWH(node: self)
    }
    
    var ratioHW: CGFloat {
        cache.ratioHW(node: self)
    }
    
    var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    var image: UIImage {
        cache.image(node: self)
    }
}

extension ImageCollectionNode: CustomStringConvertible {
    var description: String {
        fileName
    }
}

extension ImageCollectionNode: Hashable {
    static func == (lhs: ImageCollectionNode, rhs: ImageCollectionNode) -> Bool {
        lhs.fileName == rhs.fileName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(fileName)
    }
}

extension ImageCollectionNode: Identifiable {
    
}

extension ImageCollectionNode {
    
    static func previewWord() -> ImageCollectionNode {
        let app = ApplicationController.preview()
        return previewWord(app: app)
    }
     
    static func previewWord(app: ApplicationController) -> ImageCollectionNode {
        let cache = ImageCache()
        let node = ImageCollectionNode(app: app, fileName: "friday", fileExtension: "png", id: 3_000_000_004, cache: cache, type: .word)
        return node
    }
    
    static func previewIdea() -> ImageCollectionNode {
        let app = ApplicationController.preview()
        return previewIdea(app: app)
    }
     
    static func previewIdea(app: ApplicationController) -> ImageCollectionNode {
        let cache = ImageCache()
        let node = ImageCollectionNode(app: app, fileName: "IDEA_whopper_fries", fileExtension: "png", id: 3_000_000_008, cache: cache, type: .word)
        return node
    }
}
