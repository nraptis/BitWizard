//
//  ImageBucketIgnoreBagState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

class ImageBucketIgnoreBagState {
    
    let fileNames: [String]
    let ignoreNodeStates: [ImageBucketIgnoreNodeState]
    
    init(bag: Set<ImageCollectionNode>,
         dict: [ImageCollectionNode: ImageBucketIgnoreNode]) {
        
        var _fileNames = [String]()
        var _ignoreNodeStates = [ImageBucketIgnoreNodeState]()
        for (key, value) in dict {
            _fileNames.append(key.fileName)
            _ignoreNodeStates.append(value.saveToState())
        }
        self.fileNames = _fileNames
        self.ignoreNodeStates = _ignoreNodeStates
    }
}
