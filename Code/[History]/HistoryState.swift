//
//  HistoryState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

class HistoryState {
    
    let appMode: AppMode
    let showHideMode: ShowHideMode
    let gridWidth: Int
    let gridWidthPairings: Int
    let gridState: GridState?
    let centralConceptState: CentralConceptState?
    let pairingsState: PairingsState?
    
    let imageBucketState: ImageBucketState
    init(imageBucketState: ImageBucketState,
         appMode: AppMode,
         showHideMode: ShowHideMode,
         gridWidth: Int,
         gridWidthPairings: Int,
         gridState: GridState?,
         centralConceptState: CentralConceptState?,
         pairingsState: PairingsState?) {
        self.imageBucketState = imageBucketState
        self.appMode = appMode
        self.showHideMode = showHideMode
        self.gridWidth = gridWidth
        self.gridWidthPairings = gridWidthPairings
        self.gridState = gridState
        self.centralConceptState = centralConceptState
        self.pairingsState = pairingsState
    }
}
