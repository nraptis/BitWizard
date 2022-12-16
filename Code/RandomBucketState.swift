//
//  RandomBucketState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

class RandomBucketState {
    let valuesInt: [Int]
    let valuesFloat: [CGFloat]
    let indexInt: Int
    let indexFloat: Int
    init(randomBucket: RandomBucket) {
        self.valuesInt = randomBucket.valuesInt
        self.valuesFloat = randomBucket.valuesFloat
        self.indexInt = randomBucket.indexInt
        self.indexFloat = randomBucket.indexFloat
    }
}
