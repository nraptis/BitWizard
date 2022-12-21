//
//  ImageBucket.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/11/22.
//

import Foundation

enum ImageBucketFetchMode {
    case words
    case ideas
    case mixed
}

class ImageBucket {
    
    lazy var dummyNodeWord = {
        ImageCollectionNode(app: app, fileName: "friday", fileExtension: "png", id: 3_000_000_000, cache: cache, type: .word)
    }()
    
    lazy var dummyNodeIdea = {
        ImageCollectionNode(app: app, fileName: "IDEA_whopper_fries", fileExtension: "png", id: 3_000_000_001, cache: cache, type: .idea)
    }()
    
    let app: ApplicationController
    let cache: ImageCache
    
    
    let collectionWords: ImageCollectionWords
    let collectionIdeas: ImageCollectionIdeas
    let randomBucket = RandomBucket()
    private lazy var ignoreBag = {
        ImageBucketIgnoreBag(imageBucket: self,
                             collectionWords: collectionWords,
                             collectionIdeas: collectionIdeas)
    }()
    
    var selectedBag = Set<ImageCollectionNode>()
    var recentlySelectedBag = Set<ImageCollectionNode>()
    var words = [ImageCollectionNode]()
    var ideas = [ImageCollectionNode]()
    
    required init(app: ApplicationController, cache: ImageCache, collectionWords: ImageCollectionWords, collectionIdeas: ImageCollectionIdeas) {
        self.app = app
        self.cache = cache
        self.collectionWords = collectionWords
        self.collectionIdeas = collectionIdeas
    }
    
    private var _pulledWords = [ImageCollectionNode]()
    private var _pulledIdeas = [ImageCollectionNode]()
    private var _selectedWords = [ImageCollectionNode]()
    private var _selectedIdeas = [ImageCollectionNode]()
    
    var _ignoreBagWords = Set<ImageCollectionNode>()
    var _ignoreBagIdeas = Set<ImageCollectionNode>()
    
    func beginFreshPull(maximumGridCount: Int,
                        previouslyUsedWords: [ImageCollectionNode],
                        previouslyUsedIdeas: [ImageCollectionNode]) {
        randomBucket.shuffle()
        //print("begin fresh pull: maximumGridCount:\(maximumGridCount) puw: \(previouslyUsedWords) pui: \(previouslyUsedIdeas)")
        
        for node in recentlySelectedBag {
            selectedBag.insert(node)
        }
        recentlySelectedBag.removeAll(keepingCapacity: true)
        
        for node in selectedBag {
            ignoreBag.remove(node: node)
        }
        
        ignoreBag.notifyFreshPull()
        
        for node in previouslyUsedWords {
            if !recentlySelectedBag.contains(node) && !selectedBag.contains(node) {
                ignoreBag.add(node: node)
            }
        }
        for node in previouslyUsedIdeas {
            if !recentlySelectedBag.contains(node) && !selectedBag.contains(node) {
                ignoreBag.add(node: node)
            }
        }
        
        _selectedWords.removeAll(keepingCapacity: true)
        _selectedIdeas.removeAll(keepingCapacity: true)
        
        for node in selectedBag {
            switch node.type {
            case .idea:
                _selectedIdeas.append(node)
            case .word:
                _selectedWords.append(node)
            }
        }
        
        let previouslyUsedWordsSet = Set<ImageCollectionNode>(previouslyUsedWords)
        var new_pulledWords = [ImageCollectionNode]()
        for node in _pulledWords {
            if !previouslyUsedWordsSet.contains(node) && !selectedBag.contains(node) {
                new_pulledWords.append(node)
            }
        }
        
        let previouslyUsedIdeasSet = Set<ImageCollectionNode>(previouslyUsedIdeas)
        var new_pulledIdeas = [ImageCollectionNode]()
        for node in _pulledIdeas {
            if !previouslyUsedIdeasSet.contains(node) && !selectedBag.contains(node) {
                new_pulledIdeas.append(node)
            }
        }
        
        _ignoreBagWords.removeAll(keepingCapacity: true)
        _ignoreBagIdeas.removeAll(keepingCapacity: true)
        for node in ignoreBag.bag {
            switch node.type {
            case .idea:
                _ignoreBagIdeas.insert(node)
            case .word:
                _ignoreBagWords.insert(node)
            }
        }
        for node in _selectedWords {
            _ignoreBagWords.insert(node)
        }
        for node in _selectedIdeas {
            _ignoreBagIdeas.insert(node)
        }
        
        let numberOfWordsToPull = maximumGridCount - (new_pulledWords.count + _selectedWords.count)
        let fetchedWords = collectionWords.fetch(count: numberOfWordsToPull, ignoreBag: _ignoreBagWords)
        new_pulledWords.append(contentsOf: fetchedWords)
        
        let numberOfIdeasToPull = maximumGridCount - (new_pulledIdeas.count + _selectedIdeas.count)
        let fetchedIdeas = collectionIdeas.fetch(count: numberOfIdeasToPull, ignoreBag: _ignoreBagIdeas)
        new_pulledIdeas.append(contentsOf: fetchedIdeas)
        
        for index in 0..<new_pulledWords.count {
            let randomIndex = randomBucket.nextInt(new_pulledWords.count)
            new_pulledWords.swapAt(index, randomIndex)
        }
        self._pulledWords = new_pulledWords
        
        for index in 0..<new_pulledIdeas.count {
            let randomIndex = randomBucket.nextInt(new_pulledIdeas.count)
            new_pulledIdeas.swapAt(index, randomIndex)
        }
        self._pulledIdeas = new_pulledIdeas
        
        for index in 0..<_selectedWords.count {
            let randomIndex = randomBucket.nextInt(_selectedWords.count)
            _selectedWords.swapAt(index, randomIndex)
        }
        for index in 0..<_selectedIdeas.count {
            let randomIndex = randomBucket.nextInt(_selectedIdeas.count)
            _selectedIdeas.swapAt(index, randomIndex)
        }
        
        words.removeAll(keepingCapacity: true)
        for node in _selectedWords { words.append(node) }
        for node in _pulledWords { words.append(node) }
        
        ideas.removeAll(keepingCapacity: true)
        for node in _selectedIdeas { ideas.append(node) }
        for node in _pulledIdeas { ideas.append(node) }
        
        //printArray(name: "words", arr: words)
        //printArray(name: "ideas", arr: ideas)
    }
    
    private func printArray(name: String, arr: [ImageCollectionNode]) {
        
        print("\"\(name)\": {")
        
        for node in arr {
            let selected = isSelected(node: node)
            print("\t\(node) SEL: \(selected)")
        }
        
        print("} // end \(name)")
        
    }
    
    func beginFetching() {
        randomBucket.reset()
    }
    
    func getOneWordIgnoringSelected() -> ImageCollectionNode {
        let words = collectionWords.fetch(count: 1, ignoreBag: ignoreBag.bag)
        if words.count > 0 {
            return words[0]
        }
        return dummyNodeWord
    }
    
    
    func toggleSelected(node: ImageCollectionNode) {
        if selectedBag.contains(node) {
            selectedBag.remove(node)
            recentlySelectedBag.remove(node)
        } else if recentlySelectedBag.contains(node) {
            selectedBag.remove(node)
            recentlySelectedBag.remove(node)
        } else {
            recentlySelectedBag.insert(node)
        }
    }
    
    func isSelected(node: ImageCollectionNode) -> Bool {
        if selectedBag.contains(node) { return true }
        if recentlySelectedBag.contains(node) { return true }
        return false
    }
    
    //selectedBag
    
    // Dequeue one "idea" => [IMG]
    // Dequeue one "word" => [IMG]
    
    // Dequeue batch "idea" (gridWidth, gridHeight) => [IMG] (4 times expected layout's number of images)
    // Dequeue batch "word" (gridWidth, gridHeight) => [IMG] (4 times expected layout's number of images)
    
    // Mark list as "was used" ([IMG])
    // Mark list as "was not used" ([IMG])
    
    
    // Pre-fetch bucket "idea" (These were
    
    func nodeFrom(fileName: String) -> ImageCollectionNode {
        if let node = collectionWords.dict[fileName] {
            return node
        }
        if let node = collectionIdeas.dict[fileName] {
            return node
        }
        print("*** FATAL, NO NODE FOR \(fileName)")
        return dummyNodeWord
    }
    
    func handleMemoryWarning() {
        
    }
    
    func saveToState() -> ImageBucketState {
        let selectionState = ImageBucketSelectionState(selectedBag: selectedBag,
                                                       recentlySelectedBag: recentlySelectedBag)
        return ImageBucketState(//collectionWords: collectionWords,
                                //collectionIdeas: collectionIdeas,
                                randomBucket: randomBucket,
                                ignoreBag: ignoreBag,
                                selectionState: selectionState,
                                words: words,
                                ideas: ideas)
    }
    
    func loadFrom(state: ImageBucketState) {
        //collectionWords.loadFrom(state: state.collectionWordsState)
        //collectionIdeas.loadFrom(state: state.collectionIdeasState)
        
        randomBucket.loadFrom(state: state.randomBucketState)
        ignoreBag.loadFrom(state: state.ignoreBagState)
        
        words.removeAll(keepingCapacity: true)
        for fileName in state.wordsFileNames {
            let node = nodeFrom(fileName: fileName)
            words.append(node)
        }
        
        ideas.removeAll(keepingCapacity: true)
        for fileName in state.ideasFileNames {
            let node = nodeFrom(fileName: fileName)
            ideas.append(node)
        }
        loadSelectionFrom(state: state.selectionState)
    }
    
    func saveSelectionToState() -> ImageBucketSelectionState {
        ImageBucketSelectionState(selectedBag: selectedBag,
                                  recentlySelectedBag: recentlySelectedBag)
    }
    
    func loadSelectionFrom(state: ImageBucketSelectionState) {
        selectedBag.removeAll(keepingCapacity: true)
        for fileName in state.selectedBagContents {
            let node = nodeFrom(fileName: fileName)
            selectedBag.insert(node)
        }
        
        recentlySelectedBag.removeAll(keepingCapacity: true)
        for fileName in state.recentlySelectedBagContents {
            let node = nodeFrom(fileName: fileName)
            recentlySelectedBag.insert(node)
        }
    }
    
}
