//
//  MainContainerViewModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 11/27/22.
//

import Foundation

class MainContainerViewModel: ObservableObject {
    
    @Published var appMode: AppMode = .grid
    @Published var showHideMode: ShowHideMode = .showAll
    
    static let maximumGridCountWords = 24
    static let maximumGridCountIdeas = 12
    
    private(set) var gridWidth = 3
    
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
        switch appMode {
        case .grid:
            gridViewModelSpawn()
        case .centralIdea:
            centralConceptViewModelSpawn()
        case .pairings:
            break
        }
        self.collectionWords.wake()
        self.collectionIdeas.wake()
        
        imageBucket.beginFreshPull(maximumGridCountWords: Self.maximumGridCountWords,
                                   maximumGridCountIdeas: Self.maximumGridCountIdeas,
                                   previouslyUsedWords: [],
                                   previouslyUsedIdeas: [])
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
        
        var previouslyUsedWords = [ImageCollectionNode]()
        var previouslyUsedIdeas = [ImageCollectionNode]()
        
        switch appMode {
        case .grid:
            if let viewModel = gridViewModel {
                previouslyUsedWords = viewModel.usedWords
                previouslyUsedIdeas = viewModel.usedIdeas
            }
        case .centralIdea:
            if let viewModel = centralConceptViewModel {
                previouslyUsedWords = viewModel.usedWords
                previouslyUsedIdeas = viewModel.usedIdeas
            }
        case .pairings:
            if let viewModel = pairingsViewModel {
                previouslyUsedWords = viewModel.usedWords
                previouslyUsedIdeas = viewModel.usedIdeas
            }
        }
        
        if _firstShuffle {
            if (previouslyUsedWords.count > 0) || (previouslyUsedIdeas.count > 0) {
                _firstShuffle = false
                saveHistoryState()
            }
        }
        
        switch appMode {
        case .grid:
            if let viewModel = gridViewModel {
                viewModel.beginFreshPull()
            }
        case .centralIdea:
            if let viewModel = centralConceptViewModel {
                viewModel.beginFreshPull()
            }
        case .pairings:
            if let viewModel = pairingsViewModel {
                viewModel.beginFreshPull()
            }
        }
        
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
        
        switch appMode {
        case .grid:
            if let gridViewModel = gridViewModel {
                if gridViewModel.layout.layoutWidth > gridViewModel.layout.layoutHeight {
                    gridViewModel.build(gridWidth: gridWidth + 2, showHideMode: showHideMode)
                } else {
                    gridViewModel.build(gridWidth: gridWidth, showHideMode: showHideMode)
                }
            }
        case .centralIdea:
            if let centralConceptViewModel = centralConceptViewModel {
                if centralConceptViewModel.layout.layoutWidth > centralConceptViewModel.layout.layoutHeight {
                    centralConceptViewModel.build(gridWidth: gridWidth + 2, showHideMode: showHideMode)
                } else {
                    centralConceptViewModel.build(gridWidth: gridWidth, showHideMode: showHideMode)
                }
            }
        case .pairings:
            if let pairingsViewModel = pairingsViewModel {
                if pairingsViewModel.layout.layoutWidth > pairingsViewModel.layout.layoutHeight {
                    pairingsViewModel.build(gridWidth: gridWidth + 2, showHideMode: showHideMode)
                } else {
                    pairingsViewModel.build(gridWidth: gridWidth, showHideMode: showHideMode)
                }
            }
        }
    }
    
    func handleMemoryWarning() {
        imageBucket.handleMemoryWarning()
        cache.handleMemoryWarning()
    }
    
    func getAllVisibleImageCollectionNodes() -> [ImageCollectionNode] {
        var result = [ImageCollectionNode]()
        switch appMode {
        case .grid:
            if let viewModel = gridViewModel {
                let nodes = viewModel.layout.getAllVisibleImageCollectionNodes()
                result.append(contentsOf: nodes)
            }
        case .centralIdea:
            if let viewModel = centralConceptViewModel {
                let nodes = viewModel.layout.getAllVisibleImageCollectionNodes()
                result.append(contentsOf: nodes)
            }
        case .pairings:
            if let viewModel = pairingsViewModel {
                let nodes = viewModel.layout.getAllVisibleImageCollectionNodes()
                result.append(contentsOf: nodes)
            }
        }
        return result
    }
    
    var centralConceptViewModel: CentralConceptViewModel?
    func centralConceptViewModelSpawn() {
        centralConceptViewModel = CentralConceptViewModel(app: app, imageBucket: imageBucket, mainContainerViewModel: self)
    }
    
    func centralConceptViewModelDispose() {
        centralConceptViewModel = nil
    }
    
    var gridViewModel: GridViewModel?
    func gridViewModelSpawn() {
        gridViewModel = GridViewModel(app: app, imageBucket: imageBucket, mainContainerViewModel: self)
    }
    
    func gridViewModelDispose() {
        gridViewModel = nil
    }
    
    var pairingsViewModel: PairingsViewModel?
    func pairingsViewModelSpawn() {
        pairingsViewModel = PairingsViewModel(app: app, imageBucket: imageBucket, mainContainerViewModel: self)
    }
    
    func pairingsViewModelDispose() {
        pairingsViewModel = nil
    }
    
    func change(showHideMode: ShowHideMode, fromHistory: Bool) {
        if !fromHistory {
            if _firstShuffle {
                _firstShuffle = false
                saveHistoryState()
            }
            
            let previousShowHideMode = self.showHideMode
            self.showHideMode = showHideMode
            
            if (previousShowHideMode == .hideSelectedUponSelect) ||
                (showHideMode == .hideSelectedUponSelect) ||
                (showHideMode == .showAll) {
                imageBucket.mergeRecentlySelectedAndDeselected()
                build()
            }
            
            saveHistoryState()
        } else {
            self.showHideMode = showHideMode
        }
    }
    
    func change(appMode: AppMode, fromHistory: Bool) {
        
        if !fromHistory {
            if _firstShuffle {
                _firstShuffle = false
                saveHistoryState()
            }
        }
        
        switch appMode {
            
        case .grid:
            gridViewModelSpawn()
            centralConceptViewModelDispose()
            pairingsViewModelDispose()
        case .centralIdea:
            gridViewModelDispose()
            centralConceptViewModelSpawn()
            pairingsViewModelDispose()
        case .pairings:
            gridViewModelDispose()
            centralConceptViewModelDispose()
            pairingsViewModelSpawn()
        }
        self.appMode = appMode
        
        if !fromHistory {
            saveHistoryState()
        }
    }
    
    func selectLeftModeSegment() {
        if appMode == .grid { return }
        DispatchQueue.main.async {
            self.change(appMode: .grid, fromHistory: false)
        }
    }
    
    func selectMiddleModeSegment() {
        if appMode == .centralIdea { return }
        DispatchQueue.main.async {
            self.change(appMode: .centralIdea, fromHistory: false)
        }
    }
    
    func selectRightModeSegment() {
        if appMode == .pairings { return }
        DispatchQueue.main.async {
            self.change(appMode: .pairings, fromHistory: false)
        }
    }
    
    func isLeftModeSegmentSelected() -> Bool {
        switch appMode {
        case .grid:
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
    
    func selectLeftShowHideSegment() {
        if showHideMode == .showAll { return }
        DispatchQueue.main.async {
            self.change(showHideMode: .showAll, fromHistory: false)
        }
    }
    
    func selectMiddleShowHideSegment() {
        if showHideMode == .hideSelectedUponShuffle { return }
        DispatchQueue.main.async {
            self.change(showHideMode: .hideSelectedUponShuffle, fromHistory: false)
        }
    }
    
    func selectRightShowHideSegment() {
        if showHideMode == .hideSelectedUponSelect { return }
        DispatchQueue.main.async {
            self.change(showHideMode: .hideSelectedUponSelect, fromHistory: false)
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
        
        if showHideMode == .hideSelectedUponSelect {
            imageBucket.mergeRecentlySelectedAndDeselected()
            build()
        }
        
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
        let nodes = getAllVisibleImageCollectionNodes()
        var result = false
        for node in nodes {
            if imageBucket.isSelected(node: node) {
                result = true
            }
        }
        return result
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
        
        if showHideMode == .hideSelectedUponSelect {
            imageBucket.mergeRecentlySelectedAndDeselected()
            build()
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
        
        if showHideMode == .hideSelectedUponSelect {
            imageBucket.mergeRecentlySelectedAndDeselected()
            build()
        }
        
        saveHistoryState()
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
        
        if state.appMode != appMode {
            change(appMode: state.appMode, fromHistory: true)
        }
        
        if state.showHideMode != showHideMode {
            change(showHideMode: state.showHideMode, fromHistory: true)
        }
        
        gridWidth = state.gridWidth
        
        if let gridState = state.gridState, let gridViewModel = gridViewModel {
            gridViewModel.loadFrom(state: gridState)
        }
        
        if let centralConceptState = state.centralConceptState, let centralConceptViewModel = centralConceptViewModel {
            centralConceptViewModel.loadFrom(state: centralConceptState)
        }
        
        if let pairingsState = state.pairingsState, let pairingsViewModel = pairingsViewModel {
            pairingsViewModel.loadFrom(state: pairingsState)
        }
        
        let imageBucketState = state.imageBucketState
        imageBucket.loadFrom(state: imageBucketState)
        build()
    }
    
    func saveHistoryState() {
        let imageBucketState = imageBucket.saveToState()
        
        var gridState: GridState?
        var centralConceptState: CentralConceptState?
        var pairingsState: PairingsState?
        
        switch appMode {
            
        case .grid:
            gridState = gridViewModel?.saveToState()
        case .centralIdea:
            centralConceptState = centralConceptViewModel?.saveToState()
        case .pairings:
            pairingsState = pairingsViewModel?.saveToState()
        }
        
        let historyState = HistoryState(imageBucketState: imageBucketState,
                                        appMode: appMode,
                                        showHideMode: showHideMode,
                                        gridWidth: gridWidth,
                                        gridState: gridState,
                                        centralConceptState: centralConceptState,
                                        pairingsState: pairingsState)
        
        historyController.historyAdd(state: historyState)
    }
}
