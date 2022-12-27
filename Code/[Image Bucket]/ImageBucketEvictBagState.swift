//
//  ImageBucketEvictBagState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/27/22.
//

import Foundation

class ImageBucketEvictBagState {
    
    let fileNames: [String]
    let evictNodeStates: [ImageBucketEvictNodeState]
    
    init(dict: [ImageCollectionNode: ImageBucketEvictNode]) {
        
        var _fileNames = [String]()
        var _evictNodeStates = [ImageBucketEvictNodeState]()
        for (key, value) in dict {
            _fileNames.append(key.fileName)
            _evictNodeStates.append(value.saveToState())
        }
        self.fileNames = _fileNames
        self.evictNodeStates = _evictNodeStates
    }
}
