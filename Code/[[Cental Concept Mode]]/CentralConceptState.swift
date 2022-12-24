//
//  CentralConceptState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import Foundation

class CentralConceptState {
    let randomBucketState: RandomBucketState
    init(randomBucket: RandomBucket) {
        self.randomBucketState = randomBucket.saveToState()
    }
}
