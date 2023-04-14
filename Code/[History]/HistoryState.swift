//
//  HistoryState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

class HistoryState {
    
    let gridWidth: Int
    let gridWidthPairings: Int
    let gridState: GridState
    
    let imageBucketState: ImageBucketState
    init(imageBucketState: ImageBucketState,
         gridWidth: Int,
         gridWidthPairings: Int,
         gridState: GridState) {
        self.imageBucketState = imageBucketState
        self.gridWidth = gridWidth
        self.gridWidthPairings = gridWidthPairings
        self.gridState = gridState
    }
}
