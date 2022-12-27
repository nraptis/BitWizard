//
//  ImageBucketEvictNode.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/27/22.
//

import Foundation

class ImageBucketEvictNode {
    
    var ticks: Int
    init() {
        self.ticks = 0
    }
    
    func reset() {
        ticks = 0
    }
    
    func increment() {
        ticks += 1
    }
    
    func saveToState() -> ImageBucketEvictNodeState {
        ImageBucketEvictNodeState(ticks: ticks)
    }
    
    func loadFrom(state: ImageBucketEvictNodeState) {
        ticks = state.ticks
    }
}
