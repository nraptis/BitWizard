//
//  ImageBucketEvictBag.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/27/22.
//

import Foundation

class ImageBucketEvictBag {
    
    //TODO: maxAge
    static let maxAge = 4
    
    let imageBucket: ImageBucket
    let collectionWords: ImageCollectionWords
    let collectionIdeas: ImageCollectionIdeas
    private(set) var evictSet = Set<ImageCollectionNode>()
    private var dict = [ImageCollectionNode: ImageBucketEvictNode]()
    
    init(imageBucket: ImageBucket,
         collectionWords: ImageCollectionWords,
         collectionIdeas: ImageCollectionIdeas) {
        self.imageBucket = imageBucket
        self.collectionWords = collectionWords
        self.collectionIdeas = collectionIdeas
    }
    
    func add(node: ImageCollectionNode) {
        if dict[node] == nil {
            let ignoreNode = ImageBucketEvictNode()
            dict[node] = ignoreNode
        }
    }
    
    func remove(node: ImageCollectionNode) {
        dict.removeValue(forKey: node)
    }
    
    func notifyFreshPull() {
        evictSet.removeAll(keepingCapacity: true)
        for (node, evictNode) in dict {
            evictNode.increment()
            if evictNode.ticks >= Self.maxAge {
                evictSet.insert(node)
            }
        }
        for node in evictSet {
            dict.removeValue(forKey: node)
        }
    }
    
    func saveToState() -> ImageBucketEvictBagState {
        ImageBucketEvictBagState(dict: dict)
    }
    
    func loadFrom(state: ImageBucketEvictBagState) {
        
        dict.removeAll(keepingCapacity: true)
        evictSet.removeAll(keepingCapacity: true)
        
        let count = min(state.fileNames.count, state.evictNodeStates.count)
        for index in 0..<count {
            let fileName = state.fileNames[index]
            let evictNodeState = state.evictNodeStates[index]
            let node = imageBucket.nodeFrom(fileName: fileName)
            let evictNode = ImageBucketEvictNode()
            evictNode.loadFrom(state: evictNodeState)
            dict[node] = evictNode
        }
    }
}
