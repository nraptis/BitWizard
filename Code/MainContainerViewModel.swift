//
//  MainContainerViewModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 11/27/22.
//

import Foundation

class MainContainerViewModel: ObservableObject {
    
    @Published var appMode: AppMode = .centralIdea
    @Published var showHideMode: ShowHideMode = .showAll
    
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
        switch appMode {
        case .collage:
            break
        case .centralIdea:
            centralConceptViewModelSpawn()
        case .pairings:
            break
        }
        self.collectionWords.wake()
        self.collectionIdeas.wake()
        
        shuffle()
    }
    
    private var _firstShuffle: Bool = true
    func shuffle() {
        
        var previouslyUsedWords = [ImageCollectionNode]()
        var previouslyUsedIdeas = [ImageCollectionNode]()
        
        switch appMode {
        case .collage:
            break
        case .centralIdea:
            if let viewModel = centralConceptViewModel {
                previouslyUsedWords = viewModel.usedWords
                previouslyUsedIdeas = viewModel.usedIdeas
            }
        case .pairings:
            break
        }
        
        if _firstShuffle {
            if (previouslyUsedWords.count > 0) || (previouslyUsedIdeas.count > 0) {
                _firstShuffle = false
                saveHistoryStateShuffle()
            }
        }
        
        imageBucket.beginFreshPull(maximumGridCount: 24,
                                   previouslyUsedWords: previouslyUsedWords,
                                   previouslyUsedIdeas: previouslyUsedIdeas)
        
        
        build()
        
        print("previouslyUsedWords = \(previouslyUsedWords)")
        print("previouslyUsedIdeas = \(previouslyUsedIdeas)")
        
        if (previouslyUsedWords.count > 0) || (previouslyUsedIdeas.count > 0) {
            saveHistoryStateShuffle()
        }
    }
    
    func build() {
        switch appMode {
        case .collage:
            break
        case .centralIdea:
            centralConceptViewModel?.build()
        case .pairings:
            break
        }
    }
    
    var centralConceptViewModel: CentralConceptViewModel?
    func centralConceptViewModelSpawn() {
        centralConceptViewModel = CentralConceptViewModel(app: app, imageBucket: imageBucket, mainContainerViewModel: self)
    }
    
    func centralConceptViewModelDispose() {
        centralConceptViewModel = nil
    }
    
    func selectLeftModeSegment() {
        DispatchQueue.main.async {
            self.centralConceptViewModelDispose()
            
            self.appMode = .collage
        }
    }
    
    func selectMiddleModeSegment() {
        DispatchQueue.main.async {
            self.centralConceptViewModelSpawn()
            
            self.appMode = .centralIdea
        }
    }
    
    func selectRightModeSegment() {
        DispatchQueue.main.async {
            self.centralConceptViewModelDispose()
            
            self.appMode = .pairings
        }
    }
    
    func isLeftModeSegmentSelected() -> Bool {
        switch appMode {
        case .collage:
            return true
        default:
            return false
        }
    }
    
    func isMiddleModeSegmentSelected() -> Bool {
        switch appMode {
        case .centralIdea:
            return true
        default:
            return false
        }
    }
    
    func isRightModeSegmentSelected() -> Bool {
        switch appMode {
        case .pairings:
            return true
        default:
            return false
        }
    }
    
    func isUndoEnabled() -> Bool {
        
        print("can undo: \(historyController.canUndo()) count: \(historyController.historyStack.count) index: \(historyController.historyIndex)")
        return historyController.canUndo()
    }
    
    func isRedoEnabled() -> Bool {
        print("can redo: \(historyController.canRedo()) count: \(historyController.historyStack.count) index: \(historyController.historyIndex)")
        return historyController.canRedo()
    }
    
    func selectLeftShowHideSegment() {
        DispatchQueue.main.async {
            self.showHideMode = .showAll
        }
    }
    
    func selectMiddleShowHideSegment() {
        DispatchQueue.main.async {
            self.showHideMode = .hideSelectedUponShuffle
        }
    }
    
    func selectRightShowHideSegment() {
        DispatchQueue.main.async {
            self.showHideMode = .hideSelectedUponSelect
        }
    }
    
    func isLeftShowHideSegmentSelected() -> Bool {
        switch showHideMode {
        case .showAll:
            return true
        default:
            return false
        }
    }
    
    func isMiddleShowHideSegmentSelected() -> Bool {
        switch showHideMode {
        case .hideSelectedUponShuffle:
            return true
        default:
            return false
        }
    }
    
    func isRightShowHideSegmentSelected() -> Bool {
        switch showHideMode {
        case .hideSelectedUponSelect:
            return true
        default:
            return false
        }
    }
    
    private(set) var gridWidth = 3
    
    private var minGridWidth = 1
    private var maxGridWidth = ApplicationController.isIpad() ? 16 : 8
    
    func isLeftGridSizeStepperEnabled() -> Bool {
        gridWidth > minGridWidth
    }
    
    func isRightGridSizeStepperEnabled() -> Bool {
        gridWidth < maxGridWidth
    }
    
    func clickLeftGridSizeStepper() {
        if gridWidth > minGridWidth {
            gridWidth -= 1
            DispatchQueue.main.async { self.objectWillChange.send() }
        }
    }
    
    func clickRightGridSizeStepper() {
        if gridWidth < maxGridWidth {
            gridWidth += 1
            DispatchQueue.main.async { self.objectWillChange.send() }
        }
    }
    
    func toggleSelected(concept: ConceptModel) {
        imageBucket.toggleSelected(node: concept.node)
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func isSelected(concept: ConceptModel) -> Bool {
        imageBucket.isSelected(node: concept.node)
    }
    
    func applyHistoryState(_ state: HistoryState) {
        
        
        
        if let shuffleState = state as? HistoryStateShuffle {
            let imageBucketState = shuffleState.imageBucketState
            
            print("applyHistoryState => \(imageBucketState.wordsFileNames)")
            
            imageBucket.loadFrom(state: imageBucketState)
            build()
        }
        
    }
    
    func saveHistoryStateShuffle() {
        
        let imageBucketState = imageBucket.saveToState()
        let historyState = HistoryStateShuffle(imageBucketState: imageBucketState)
        
        print("saveHistoryState => \(imageBucketState.wordsFileNames)")
        
        historyController.historyAdd(state: historyState)
        
    }
    
    func undoIntent() {
        historyController.undo()
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func redoIntent() {
        historyController.redo()
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
}
