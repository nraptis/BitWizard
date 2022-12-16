//
//  RandomBucket.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/5/22.
//

import Foundation

class RandomBucket {
    
    var valuesInt: [Int]
    var valuesFloat: [CGFloat]
    let capacity: Int
    
    var indexInt = 0
    var indexFloat = 0
    
    init(capacity: Int = 512) {
        self.capacity = capacity
        valuesInt = [Int](repeating: 0, count: capacity)
        valuesFloat = [CGFloat](repeating: 0.0, count: capacity)
    }
    
    func shuffle() {
        for index in 0..<capacity {
            valuesInt[index] = Int.random(in: 0...2147483647)
        }
        for index in 0..<capacity {
            valuesFloat[index] = CGFloat.random(in: 0.0...1.0)
        }
    }
    
    func reset() {
        indexInt = 0
        indexFloat = 0
    }
    
    func nextInt(_ ceiling: Int) -> Int {
        var result = valuesInt[indexInt]
        if ceiling > 0 {
            result = (result % ceiling)
        }
        indexInt += 1
        if indexInt == capacity {
            indexInt = 0
        }
        return result
    }
    
    func nextFloat(_ factor: CGFloat) -> CGFloat {
        let result = valuesFloat[indexFloat] * factor
        indexFloat += 1
        if indexFloat == capacity {
            indexFloat = 0
        }
        return result
    }
    
    func saveToState() -> RandomBucketState {
        RandomBucketState(randomBucket: self)
    }
    
    func loadFrom(state: RandomBucketState) {
        for index in 0..<state.valuesInt.count {
            valuesInt[index] = state.valuesInt[index]
        }
        for index in 0..<state.valuesFloat.count {
            valuesFloat[index] = state.valuesFloat[index]
        }
        indexInt = state.indexInt
        indexFloat = state.indexFloat
    }
    
}
