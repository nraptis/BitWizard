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
    private lazy var evictBag = {
        ImageBucketEvictBag(imageBucket: self,
                            collectionWords: collectionWords,
                            collectionIdeas: collectionIdeas)
    }()
    
    
    
    
    var selectedBag = Set<ImageCollectionNode>()
    var recentlySelectedBag = Set<ImageCollectionNode>()
    var recentlyDeselectedBag = Set<ImageCollectionNode>()
    
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
    
    func beginFreshPull(maximumGridCountWords: Int,
                        maximumGridCountIdeas: Int,
                        previouslyUsedWords: [ImageCollectionNode],
                        previouslyUsedIdeas: [ImageCollectionNode]) {
        
        /*
        let wordCount = collectionWords.nodes.count
        let ideaCount = collectionIdeas.nodes.count
        let totalCount = wordCount + ideaCount
        var ideaRatio: CGFloat = 1.0
        if totalCount > 0 {
            ideaRatio = CGFloat(ideaCount) / CGFloat(totalCount)
        }
        
        let maximumGridCountWords = maximumGridCount
        let maximumGridCountIdeas = 12 // TODO:
        */
        
        randomBucket.shuffle()
        //print("begin fresh pull: maximumGridCount:\(maximumGridCount) puw: \(previouslyUsedWords) pui: \(previouslyUsedIdeas)")
        
        mergeRecentlySelectedAndDeselected()
        
        for node in selectedBag {
            ignoreBag.remove(node: node)
        }
        
        ignoreBag.notifyFreshPull()
        evictBag.notifyFreshPull()
        
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
        
        _ignoreBagWords.removeAll(keepingCapacity: true)
        _ignoreBagIdeas.removeAll(keepingCapacity: true)
        
        let previouslyUsedWordsSet = Set<ImageCollectionNode>(previouslyUsedWords)
        var new_pulledWords = [ImageCollectionNode]()
        for node in _pulledWords {
            if !previouslyUsedWordsSet.contains(node) && !selectedBag.contains(node) {
                
                if !evictBag.evictSet.contains(node) {
                    new_pulledWords.append(node)
                    _ignoreBagWords.insert(node)
                }
            }
        }
        
        let previouslyUsedIdeasSet = Set<ImageCollectionNode>(previouslyUsedIdeas)
        var new_pulledIdeas = [ImageCollectionNode]()
        for node in _pulledIdeas {
            if !previouslyUsedIdeasSet.contains(node) && !selectedBag.contains(node) {
                if !evictBag.evictSet.contains(node) {
                    new_pulledIdeas.append(node)
                    _ignoreBagIdeas.insert(node)
                }
            }
        }
        
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
        
        let numberOfWordsToPull = maximumGridCountWords - (new_pulledWords.count + _selectedWords.count)
        let fetchedWords = collectionWords.fetch(count: numberOfWordsToPull, ignoreBag: _ignoreBagWords)
        new_pulledWords.append(contentsOf: fetchedWords)
        
        let numberOfIdeasToPull = maximumGridCountIdeas - (new_pulledIdeas.count + _selectedIdeas.count)
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
        
        //print("words count: \(words.count), sel: \(_selectedWords.count), pul: \(_pulledWords.count)")
        //print("ideas count: \(ideas.count), sel: \(_selectedIdeas.count), pul: \(_pulledIdeas.count)")
        
        for node in words {
            evictBag.add(node: node)
        }
        
        for node in ideas {
            evictBag.add(node: node)
        }
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
    
    func mergeRecentlySelectedAndDeselected() {
        for node in recentlySelectedBag {
            selectedBag.insert(node)
        }
        for node in recentlyDeselectedBag {
            selectedBag.remove(node)
        }
        recentlySelectedBag.removeAll(keepingCapacity: true)
        recentlyDeselectedBag.removeAll(keepingCapacity: true)
    }
    
    func forceSelected(node: ImageCollectionNode) {
        recentlyDeselectedBag.remove(node)
        if !selectedBag.contains(node) {
            recentlySelectedBag.insert(node)
        }
    }
    
    func forceDeselected(node: ImageCollectionNode) {
        recentlySelectedBag.remove(node)
        if selectedBag.contains(node) {
            recentlyDeselectedBag.insert(node)
        }
    }
    
    func toggleSelected(node: ImageCollectionNode) {
        if selectedBag.contains(node) {
            if recentlySelectedBag.contains(node) {
                recentlySelectedBag.remove(node)
                recentlyDeselectedBag.insert(node)
            } else if recentlyDeselectedBag.contains(node) {
                recentlySelectedBag.insert(node)
                recentlyDeselectedBag.remove(node)
            } else {
                recentlyDeselectedBag.insert(node)
            }
        } else {
            
            if recentlyDeselectedBag.contains(node) {
                recentlyDeselectedBag.remove(node)
                recentlySelectedBag.insert(node)
            } else if recentlySelectedBag.contains(node) {
                recentlyDeselectedBag.insert(node)
                recentlySelectedBag.remove(node)
            } else {
                recentlySelectedBag.insert(node)
            }
        }
    }
    
    func isSelected(node: ImageCollectionNode) -> Bool {
        if recentlyDeselectedBag.contains(node) { return false }
        if selectedBag.contains(node) { return true }
        if recentlySelectedBag.contains(node) { return true }
        return false
    }
    
    func isSelectedNotRecently(node: ImageCollectionNode) -> Bool {
        if selectedBag.contains(node) { return true }
        return false
    }
    
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
                                                       recentlySelectedBag: recentlySelectedBag,
                                                       recentlyDeselectedBag: recentlyDeselectedBag)
        return ImageBucketState(randomBucket: randomBucket,
                                ignoreBag: ignoreBag,
                                evictBag: evictBag,
                                selectionState: selectionState,
                                words: words,
                                ideas: ideas)
    }
    
    func loadFrom(state: ImageBucketState) {
        
        randomBucket.loadFrom(state: state.randomBucketState)
        ignoreBag.loadFrom(state: state.ignoreBagState)
        evictBag.loadFrom(state: state.evictBagState)
        
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
                                  recentlySelectedBag: recentlySelectedBag,
                                  recentlyDeselectedBag: recentlyDeselectedBag)
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
        
        recentlyDeselectedBag.removeAll(keepingCapacity: true)
        for fileName in state.recentlyDeselectedBagContents {
            let node = nodeFrom(fileName: fileName)
            recentlyDeselectedBag.insert(node)
        }
        
    }
}
