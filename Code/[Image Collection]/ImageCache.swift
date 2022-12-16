//
//  ImageCache.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/12/22.
//

import Foundation
import UIKit

class ImageCache {
    
    private static let defaultWidth: CGFloat = 32
    private static let defaultHeight: CGFloat = 32
    
    private static let placeholderImage = UIImage(systemName: "xmark") ?? UIImage()
    
    private let cache = NSCache<NSString, UIImage>()
    private var failSet = Set<String>()
    private var widthDict = [String: CGFloat]()
    private var heightDict = [String: CGFloat]()
    
    func image(node: ImageCollectionNode) -> UIImage {
        let key = NSString(string: node.fileName)
        if let result = cache.object(forKey: key) {
            return result
        } else {
            if !failSet.contains(node.fileName) {
                if let image = loadImageFromNode(node) {
                    cache.setObject(image, forKey: key)
                    widthDict[node.fileName] = image.size.width
                    heightDict[node.fileName] = image.size.height
                    return image
                } else {
                    failSet.insert(node.fileName)
                }
            }
        }
        return Self.placeholderImage
    }
    
    func width(node: ImageCollectionNode) -> CGFloat {
        if let result = widthDict[node.fileName] {
            return result
        } else {
            if !failSet.contains(node.fileName) {
                if let image = loadImageFromNode(node) {
                    let key = NSString(string: node.fileName)
                    cache.setObject(image, forKey: key)
                    widthDict[node.fileName] = image.size.width
                    heightDict[node.fileName] = image.size.height
                    return image.size.width
                } else {
                    failSet.insert(node.fileName)
                }
            }
        }
        return Self.defaultWidth
    }
    
    func height(node: ImageCollectionNode) -> CGFloat {
        if let result = heightDict[node.fileName] {
            return result
        } else {
            if !failSet.contains(node.fileName) {
                if let image = loadImageFromNode(node) {
                    let key = NSString(string: node.fileName)
                    cache.setObject(image, forKey: key)
                    widthDict[node.fileName] = image.size.width
                    heightDict[node.fileName] = image.size.height
                    return image.size.height
                } else {
                    failSet.insert(node.fileName)
                }
            }
        }
        return Self.defaultHeight
    }
    
    private func loadImageFromNode(_ node: ImageCollectionNode) -> UIImage? {
        let path = node.path
        if let image = UIImage(contentsOfFile: path) {
            if image.size.width > 32 && image.size.height > 32 {
                return image
            }
        }
        return nil
    }
}
