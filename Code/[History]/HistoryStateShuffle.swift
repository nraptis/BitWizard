//
//  HistoryStateShuffle.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

// May need an additional random collection
class HistoryStateShuffle: HistoryState {
    
    let imageBucketState: ImageBucketState
    
    init(imageBucketState: ImageBucketState) {
        self.imageBucketState = imageBucketState
    }
}
