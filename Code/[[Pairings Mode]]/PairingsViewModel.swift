//
//  PairingsViewModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import Foundation

class PairingsViewModel: ObservableObject {
    
    static func preview() -> PairingsViewModel {
        let mcvm = MainContainerViewModel.preview()
        return PairingsViewModel(app: ApplicationController.preview(), imageBucket: mcvm.imageBucket, mainContainerViewModel: mcvm)
    }
    
    deinit {
        
    }
    
    
    
    var usedWords = [ImageCollectionNode]()
    var usedIdeas = [ImageCollectionNode]()
    
    let app: ApplicationController
    let imageBucket: ImageBucket
    let mainContainerViewModel: MainContainerViewModel
    lazy var layout: PairingsLayout = {
        PairingsLayout(imageBucket: mainContainerViewModel.imageBucket)
    }()
    
    required init(app: ApplicationController, imageBucket: ImageBucket, mainContainerViewModel: MainContainerViewModel) {
        self.app = app
        self.imageBucket = imageBucket
        self.mainContainerViewModel = mainContainerViewModel
    }
    
    func register(layoutWidth: CGFloat, layoutHeight: CGFloat, gridWidth: Int, showHideMode: ShowHideMode) {
        
        let diff1 = abs(layoutWidth - layout.layoutWidth)
        let diff2 = abs(layoutHeight - layout.layoutHeight)
        let diff3 = gridWidth - layout.gridWidth
        
        guard (diff1 > 0.5) || (diff2 > 0.5) || (diff3 != 0) else {
            return
        }
        
        layout.register(layoutWidth: layoutWidth,
                        layoutHeight: layoutHeight,
                        gridWidth: gridWidth)
        
        let buildResponse = layout.build(gridWidth: gridWidth, showHideMode: showHideMode)
        
        usedWords = buildResponse.usedWords
        usedIdeas = buildResponse.usedIdeas
        
        DispatchQueue.main.async {
            self.mainContainerViewModel.objectWillChange.send()
            self.objectWillChange.send()
        }
    }
    
    func beginFreshPull() {
        layout.randomBucketStored.shuffle()
    }
    
    func build(gridWidth: Int, showHideMode: ShowHideMode) {
        
        let buildResponse = layout.build(gridWidth: gridWidth, showHideMode: showHideMode)
        
        usedWords = buildResponse.usedWords
        usedIdeas = buildResponse.usedIdeas
        
        DispatchQueue.main.async {
            self.mainContainerViewModel.objectWillChange.send()
            self.objectWillChange.send()
        }
    }
    
    func saveToState() -> PairingsState {
        return PairingsState(randomBucket: layout.randomBucketStored)
    }
    
    func loadFrom(state: PairingsState) {
        layout.randomBucketStored.loadFrom(state: state.randomBucketState)
    }
    
}
