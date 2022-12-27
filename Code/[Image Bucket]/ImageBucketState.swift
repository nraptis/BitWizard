//
//  ImageBucketState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/11/22.
//

import Foundation

class ImageBucketState {
    let randomBucketState: RandomBucketState
    let ignoreBagState: ImageBucketIgnoreBagState
    let evictBagState: ImageBucketEvictBagState
    
    let selectionState: ImageBucketSelectionState
    
    let wordsFileNames: [String]
    let ideasFileNames: [String]
    
    init(randomBucket: RandomBucket,
         ignoreBag: ImageBucketIgnoreBag,
         evictBag: ImageBucketEvictBag,
         selectionState: ImageBucketSelectionState,
         words: [ImageCollectionNode],
         ideas: [ImageCollectionNode]
    ) {
        self.randomBucketState = randomBucket.saveToState()
        self.ignoreBagState = ignoreBag.saveToState()
        self.evictBagState = evictBag.saveToState()
        
        self.selectionState = selectionState
        
        self.wordsFileNames = words.map { $0.fileName }
        self.ideasFileNames = ideas.map { $0.fileName }
    }
}
