//
//  GridState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import Foundation

class GridState {
    let randomBucketState: RandomBucketState
    init(randomBucket: RandomBucket) {
        self.randomBucketState = randomBucket.saveToState()
    }
}
