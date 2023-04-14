//
//  MainContainerViewModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 11/27/22.
//

import Foundation

class MainContainerViewModel: ObservableObject {
    
    static let maximumGridCountWords = 200
    static let maximumGridCountIdeas = 140
    
    private(set) var gridWidth = 3
    private(set) var gridWidthPairings = 1
    
    private(set) var flippedV: Bool = false
    
    
    private var minGridWidth = 1
    private var maxGridWidth = ApplicationController.isIpad() ? 7 : 5
    
    private let cache = ImageCache()
    
    static func preview() -> MainContainerViewModel {
        MainContainerViewModel(app: ApplicationController.preview())
    }
    
    lazy var collectionWords = {
        ImageCollectionWords(app: app, cache: cache)
    }()
    
    lazy var collectionIdeas = {
        ImageCollectionIdeas(app: app, cache: cache)
    }()
    
    lazy var imageBucket = {
        ImageBucket(app: app,
                    cache: cache,
                    collectionWords: collectionWords,
                    collectionIdeas: collectionIdeas)
    }()
    
    lazy var historyController = {
        HistoryController(mainContainerViewModel: self)
    }()
    
    let app: ApplicationController
    required init(app: ApplicationController) {
        self.app = app
        
        self.collectionWords.wake()
        self.collectionIdeas.wake()
        
        imageBucket.beginFreshPull(maximumGridCountWords: Self.maximumGridCountWords,
                                   maximumGridCountIdeas: Self.maximumGridCountIdeas,
                                   previouslyUsedWords: [],
                                   previouslyUsedIdeas: [])
        
        //findAverageSizes()
    }
    
    open func findAverageSizes() {
        
        var widthWords: Double = 0.0
        var heightWords: Double = 0.0
        var countWords: Int = 0
        for node in collectionWords.nodes {
            widthWords += node.width
            heightWords += node.height
            countWords += 1
        }
        
        var widthIdeas: Double = 0.0
        var heightIdeas: Double = 0.0
        var countIdeas: Int = 0
        for node in collectionIdeas.nodes {
            widthIdeas += node.width
            heightIdeas += node.height
            countIdeas += 1
        }
        
        let countTotal = countWords + countIdeas
        var widthTotal = widthWords + widthIdeas
        var heightTotal = heightWords + heightIdeas
        
        if countWords > 0 {
            widthWords /= Double(countWords)
            heightWords /= Double(countWords)
            let ratioWords = widthWords / heightWords
            print("width words: \(widthWords)")
            print("height words: \(heightWords)")
            print("ratio words: \(ratioWords)")
        }
        
        if countIdeas > 0 {
            widthIdeas /= Double(countIdeas)
            heightIdeas /= Double(countIdeas)
            let ratioIdeas = widthIdeas / heightIdeas
            print("width ideas: \(widthIdeas)")
            print("height ideas: \(heightIdeas)")
            print("ratio ideas: \(ratioIdeas)")
        }
        
        if countTotal > 0 {
            widthTotal /= Double(countTotal)
            heightTotal /= Double(countTotal)
            let ratioTotal = widthTotal / heightTotal
            print("width total: \(widthTotal)")
            print("height total: \(heightTotal)")
            print("ratio total: \(ratioTotal)")
        }
    }
    
    private var _firstShuffle: Bool = true
    func shuffle() {
        
        let previouslyUsedWords = gridViewModel.usedWords
        let previouslyUsedIdeas = gridViewModel.usedIdeas
                
        if _firstShuffle {
            if (previouslyUsedWords.count > 0) || (previouslyUsedIdeas.count > 0) {
                _firstShuffle = false
                saveHistoryState()
            }
        }
        
        gridViewModel.beginFreshPull()
        
        //TODO: maximumGridCount
        imageBucket.beginFreshPull(maximumGridCountWords: Self.maximumGridCountWords,
                                   maximumGridCountIdeas: Self.maximumGridCountIdeas,
                                   previouslyUsedWords: previouslyUsedWords,
                                   previouslyUsedIdeas: previouslyUsedIdeas)
        
        build()
        
        if (previouslyUsedWords.count > 0) || (previouslyUsedIdeas.count > 0) {
            saveHistoryState()
        }
    }
    
    func build() {
        if gridViewModel.layout.layoutWidth > gridViewModel.layout.layoutHeight {
            gridViewModel.build(gridWidth: gridWidth + 2)
        } else {
            gridViewModel.build(gridWidth: gridWidth)
        }
    }
    
    func handleMemoryWarning() {
        imageBucket.handleMemoryWarning()
        cache.handleMemoryWarning()
    }
    
    func getAllVisibleImageCollectionNodes() -> [ImageCollectionNode] {
        gridViewModel.layout.getAllVisibleImageCollectionNodes()
    }
    
    lazy var gridViewModel: GridViewModel = {
        GridViewModel(app: app, imageBucket: imageBucket, mainContainerViewModel: self)
    }()
    
    
    func isLeftGridSizeStepperEnabled() -> Bool {
        gridWidth > minGridWidth
    }
    
    func isRightGridSizeStepperEnabled() -> Bool {
        gridWidth < maxGridWidth
    }
    
    func clickLeftGridSizeStepper() {
        
            if gridWidth > minGridWidth {
                if _firstShuffle {
                    _firstShuffle = false
                    saveHistoryState()
                }
                gridWidth -= 1
                build()
                saveHistoryState()
            }
        
    }
    
    func clickRightGridSizeStepper() {

        
            if gridWidth < maxGridWidth {
                if _firstShuffle {
                    _firstShuffle = false
                    saveHistoryState()
                }
                gridWidth += 1
                build()
                saveHistoryState()
            }
        
    }
    
    func toggleSelected(concept: ConceptModel) {
        
        if _firstShuffle {
            _firstShuffle = false
            saveHistoryState()
        }
        
        imageBucket.toggleSelected(node: concept.node)
        
        saveHistoryState()
        
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func isSelected(concept: ConceptModel) -> Bool {
        imageBucket.isSelected(node: concept.node)
    }
    
    func isSelectAllEnabled() -> Bool {
        let nodes = getAllVisibleImageCollectionNodes()
        var result = false
        for node in nodes {
            if !imageBucket.isSelected(node: node) {
                result = true
            }
        }
        return result
    }
    
    func isDeselectAllEnabled() -> Bool {
        if imageBucket.selectedBag.count > 0 { return true }
        if imageBucket.recentlySelectedBag.count > 0 { return true }
        return false
    }
    
    func selectAllIntent() {
        if _firstShuffle {
            _firstShuffle = false
            saveHistoryState()
        }
        
        let nodes = getAllVisibleImageCollectionNodes()
        for node in nodes {
            imageBucket.forceSelected(node: node)
        }
        
        saveHistoryState()
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func deselectAllIntent() {
        if _firstShuffle {
            _firstShuffle = false
            saveHistoryState()
        }
        
        let nodes = getAllVisibleImageCollectionNodes()
        for node in nodes {
            imageBucket.forceDeselected(node: node)
        }
        for node in imageBucket.selectedBag {
            imageBucket.forceDeselected(node: node)
        }
        
        saveHistoryState()
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func flipVIntent() {
        flippedV = !flippedV
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func isUndoEnabled() -> Bool {
        return historyController.canUndo()
    }
    
    func isRedoEnabled() -> Bool {
        return historyController.canRedo()
    }
    
    func undoIntent() {
        historyController.undo()
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func redoIntent() {
        historyController.redo()
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func applyHistoryState(_ state: HistoryState) {
        
        gridWidth = state.gridWidth
        gridWidthPairings = state.gridWidthPairings
        
        gridViewModel.loadFrom(state: state.gridState)
        
        let imageBucketState = state.imageBucketState
        imageBucket.loadFrom(state: imageBucketState)
        build()
    }
    
    func saveHistoryState() {
        let imageBucketState = imageBucket.saveToState()
        
        let gridState = gridViewModel.saveToState()
        
        let historyState = HistoryState(imageBucketState: imageBucketState,
                                        gridWidth: gridWidth,
                                        gridWidthPairings: gridWidthPairings,
                                        gridState: gridState)
        
        historyController.historyAdd(state: historyState)
    }
}
