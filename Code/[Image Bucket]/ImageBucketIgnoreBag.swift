//
//  ImageBucketIgnoreBag.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/12/22.
//

import Foundation

class ImageBucketIgnoreBag {
    
    static let maxAge = 3
    
    let imageBucket: ImageBucket
    let collectionWords: ImageCollectionWords
    let collectionIdeas: ImageCollectionIdeas
    init(imageBucket: ImageBucket,
         collectionWords: ImageCollectionWords,
         collectionIdeas: ImageCollectionIdeas) {
        self.imageBucket = imageBucket
        self.collectionWords = collectionWords
        self.collectionIdeas = collectionIdeas
    }
    
    var bag = Set<ImageCollectionNode>()
    private var dict = [ImageCollectionNode: ImageBucketIgnoreNode]()
    
    func add(node: ImageCollectionNode) {
        if let existing = dict[node] {
            print("resetting ignore node: \(node)")
            existing.reset()
        } else {
            print("adding fresh ignore node: \(node)")
            let ignoreNode = ImageBucketIgnoreNode()
            dict[node] = ignoreNode
            bag.insert(node)
        }
    }
    
    func remove(node: ImageCollectionNode) {
        if bag.contains(node) {
            print("removing ignore node: \(node)")
            bag.remove(node)
            dict.removeValue(forKey: node)
        }
    }
    
    func contains(node: ImageCollectionNode) -> Bool {
        bag.contains(node)
    }
    
    private var _killList = [ImageCollectionNode]()
    func notifyFreshPull() {
        _killList.removeAll(keepingCapacity: true)
        for (node, ignoreNode) in dict {
            ignoreNode.increment()
            if ignoreNode.ticks >= Self.maxAge {
                _killList.append(node)
            }
        }
        for node in _killList {
            print("ignore purging \(node) to max age...")
            bag.remove(node)
            dict.removeValue(forKey: node)
        }
        _killList.removeAll(keepingCapacity: true)
    }
    
    func saveToState() -> ImageBucketIgnoreBagState {
        ImageBucketIgnoreBagState(bag: bag,
                                  dict: dict)
    }
    
    func loadFrom(state: ImageBucketIgnoreBagState) {
        
        bag.removeAll(keepingCapacity: true)
        dict.removeAll(keepingCapacity: true)
        
        let count = min(state.fileNames.count, state.ignoreNodeStates.count)
        for index in 0..<count {
            let fileName = state.fileNames[index]
            let ignoreNodeState = state.ignoreNodeStates[index]
            let node = imageBucket.nodeFrom(fileName: fileName)
            let ignoreNode = ImageBucketIgnoreNode()
            ignoreNode.loadFrom(state: ignoreNodeState)
            bag.insert(node)
            dict[node] = ignoreNode
        }
    }
}
