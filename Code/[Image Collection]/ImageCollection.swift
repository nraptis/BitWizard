//
//  ImageCollection.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import UIKit

extension String {
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

class ImageCollection {
    var nodes = [ImageCollectionNode]()
    let app: ApplicationController
    let cache: ImageCache
    private let idOffset: Int
    private var fetchOffset: Int = 0
    
    private(set) var dict = [String: ImageCollectionNode]()
    
    init(app: ApplicationController, cache: ImageCache, idOffset: Int) {
        self.app = app
        self.cache = cache
        self.idOffset = idOffset
    }
    
    func wake() {
        
    }
    
    static func textToLines(imageListText: String) -> [String] {
        let linesNL = imageListText.split(separator: "\n")
            .map {
                $0
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }.filter {
                $0
                    .count > 0
            }
        
        var lines = [String]()
        for line in linesNL {
            let linesCR = line.split(separator: "\r")
                .map {
                    $0
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }.filter {
                    $0
                        .count > 0
                }
            for innerLine in linesCR {
                lines.append(innerLine)
            }
        }
        return lines
    }
    
    func setUp(imageNames: [String], type: ImageCollectionNodeType) {
        nodes.removeAll()
        var index = 0
        for imageName in imageNames {
            let fileName = imageName.fileName()
            let fileExtension = imageName.fileExtension()
            guard fileName.count > 0 else { continue }
            guard fileExtension.count > 0 else { continue }
            let node = ImageCollectionNode(app: app,
                                           fileName: fileName,
                                           fileExtension: fileExtension,
                                           id: index + idOffset,
                                           cache: cache,
                                           type: type)
            nodes.append(node)
            dict[fileName] = node
            index += 1
        }
    }
    
    func shuffle() {
        fetchOffset = 0
        nodes.shuffle()
    }
    
    func fetch(count: Int, ignoreBag: Set<ImageCollectionNode>) -> [ImageCollectionNode] {
        
        var result = [ImageCollectionNode]()
        
        if count <= 0 {
            return result
        }
        
        if fetchOffset >= nodes.count { fetchOffset = nodes.count - 1 }
        if fetchOffset < 0 { fetchOffset = 0 }
        
        result.reserveCapacity(count)
        
        var usedSet = Set<ImageCollectionNode>()
        var fudge = 0
        let fudgeMax = count + (count >> 1) + 12
        
        while (usedSet.count < count) && (usedSet.count < nodes.count) && (fudge < fudgeMax) {
            let node = nodes[fetchOffset]
            if !ignoreBag.contains(node) && !usedSet.contains(node) {
                usedSet.insert(node)
                result.append(node)
            }
            fetchOffset += 1
            if fetchOffset >= nodes.count {
                shuffle()
            }
            fudge += 1
        }
        return result
    }
    
    func saveToState() -> ImageCollectionState {
        ImageCollectionState(fetchOffset: fetchOffset, nodes: nodes)
    }
    
    func loadFrom(state: ImageCollectionState) {
        fetchOffset = state.fetchOffset
        var dict = [String: ImageCollectionNode]()
        for node in nodes {
            dict[node.fileName] = node
        }
        nodes.removeAll(keepingCapacity: true)
        for fileName in state.fileNames {
            if let node = dict[fileName] {
                nodes.append(node)
            } else {
                print("Shouldn't happen, illegal state for Image Collection...")
            }
        }
    }
}
