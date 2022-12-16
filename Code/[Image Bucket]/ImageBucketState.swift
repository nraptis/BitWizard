//
//  ImageBucketState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/11/22.
//

import Foundation

class ImageBucketState {
    
    let collectionWordsState: ImageCollectionState
    let collectionIdeasState: ImageCollectionState
    let randomBucketState: RandomBucketState
    let ignoreBagState: ImageBucketIgnoreBagState
    
    let selectedBagContents: [String]
    let recentlySelectedBagContents: [String]
    
    let wordsFileNames: [String]
    let ideasFileNames: [String]
    
    init(collectionWords: ImageCollectionWords,
         collectionIdeas: ImageCollectionIdeas,
         randomBucket: RandomBucket,
         ignoreBag: ImageBucketIgnoreBag,
         selectedBag: Set<ImageCollectionNode>,
         recentlySelectedBag: Set<ImageCollectionNode>,
         words: [ImageCollectionNode],
         ideas: [ImageCollectionNode]
    ) {
        self.collectionWordsState = collectionWords.saveToState()
        self.collectionIdeasState = collectionIdeas.saveToState()
        self.randomBucketState = randomBucket.saveToState()
        self.ignoreBagState = ignoreBag.saveToState()
        
        var _selectedBagContents = [String]()
        for node in selectedBag {
            _selectedBagContents.append(node.fileName)
        }
        self.selectedBagContents = _selectedBagContents
        
        var _recentlySelectedBagContents = [String]()
        for node in recentlySelectedBag {
            _recentlySelectedBagContents.append(node.fileName)
        }
        self.recentlySelectedBagContents = _recentlySelectedBagContents
        
        self.wordsFileNames = words.map { $0.fileName }
        self.ideasFileNames = ideas.map { $0.fileName }
    }
    
}
