//
//  RandomBucket.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/5/22.
//

import Foundation

class RandomBucket {
    
    private(set) var valuesInt: [Int]
    private(set) var valuesFloat: [CGFloat]
    private(set) var capacity: Int
    
    private(set) var indexInt = 0
    private(set) var indexFloat = 0
    
    init(capacity: Int = 512) {
        self.capacity = capacity
        valuesInt = [Int](repeating: 0, count: capacity)
        valuesFloat = [CGFloat](repeating: 0.0, count: capacity)
    }
    
    func set(randomBucket: RandomBucket) {
        if self.capacity != randomBucket.capacity {
            self.capacity = randomBucket.capacity
            self.valuesInt = [Int](repeating: 0, count: randomBucket.capacity)
            self.valuesFloat = [CGFloat](repeating: 0.0, count: randomBucket.capacity)
        }
        for index in 0..<randomBucket.valuesInt.count {
            valuesInt[index] = randomBucket.valuesInt[index]
        }
        for index in 0..<randomBucket.valuesFloat.count {
            valuesFloat[index] = randomBucket.valuesFloat[index]
            valuesFloat[index] = randomBucket.valuesFloat[index]
        }
        self.indexInt = randomBucket.indexInt
        self.indexFloat = randomBucket.indexFloat
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
    
    func nextBool() -> Bool {
        nextInt(2) == 0
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
    
    func log(name: String) {
        
        let ist = valuesInt[0] % 255
        let ied = valuesInt[valuesInt.count - 1] % 255
        
        let fst = valuesFloat[0]
        let fed = valuesFloat[valuesInt.count - 1]
        
        let strfst = String(format: "%.2f", fst)
        let strfed = String(format: "%.2f", fed)
        
        print("Random Bucket (\(name)) Capacity: \(capacity), [i: \(indexInt), f: \(indexFloat)], {ist: \(ist) ied: \(ied)} {fst: \(strfst) fed: \(strfed)}")
        
    }
    
}
