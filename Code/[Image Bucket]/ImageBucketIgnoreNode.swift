//
//  ImageBucketIgnoreNode.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/12/22.
//

import Foundation

class ImageBucketIgnoreNode {
    
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
    
    func saveToState() -> ImageBucketIgnoreNodeState {
        ImageBucketIgnoreNodeState(ticks: ticks)
    }
    
    func loadFrom(state: ImageBucketIgnoreNodeState) {
        ticks = state.ticks
    }
}
