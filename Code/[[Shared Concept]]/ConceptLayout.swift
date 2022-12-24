//
//  ConceptLayout.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/4/22.
//

import Foundation
import UIKit

enum LayoutNodeType {
    case any
    case idea
    case word
}

enum CapOffType {
    case one
    case two
    case three
    case four
}

class ConceptLayoutBuildResponse {
    var usedWords = [ImageCollectionNode]()
    var usedIdeas = [ImageCollectionNode]()
    
    func add(node: ImageCollectionNode) {
        switch node.type {
        case .idea:
            usedIdeas.append(node)
        case .word:
            usedWords.append(node)
        }
    }
}

class StripPlacementResult {
    var strips = [ConceptStrip]()
    var rect = CGRect.zero
    func stripWidth() -> CGFloat {
        if strips.count <= 0 {
            return 0.0
        }
        let result = strips[strips.count - 1].width
        return result
    }
}

struct NodeWidthConceptWidth: Hashable {
    static func == (lhs: NodeWidthConceptWidth, rhs: NodeWidthConceptWidth) -> Bool {
        (lhs.nodeWidth == rhs.nodeWidth) && (lhs.stripWidth == rhs.stripWidth)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeWidth)
        hasher.combine(stripWidth)
    }
    
    let nodeWidth: CGFloat
    let stripWidth: CGFloat
    init(nodeWidth: CGFloat, stripWidth: CGFloat) {
        self.nodeWidth = nodeWidth
        self.stripWidth = stripWidth
    }
}

struct CapOffMatch1 {
    let bucket1: CapOffHeightBucket
    let bestSelectedCount: Int
}

struct CapOffMatch2 {
    let bucket1: CapOffHeightBucket
    let bucket2: CapOffHeightBucket
    let bestSelectedCount: Int
}

struct CapOffMatch3 {
    let bucket1: CapOffHeightBucket
    let bucket2: CapOffHeightBucket
    let bucket3: CapOffHeightBucket
    let bestSelectedCount: Int
}

struct CapOffMatch4 {
    let bucket1: CapOffHeightBucket
    let bucket2: CapOffHeightBucket
    let bucket3: CapOffHeightBucket
    let bucket4: CapOffHeightBucket
    let bestSelectedCount: Int
}

struct CapOffNode1 {
    let node1: ImageCollectionNode
}

struct CapOffNode2 {
    let node1: ImageCollectionNode
    let node2: ImageCollectionNode
}

struct CapOffNode3 {
    let node1: ImageCollectionNode
    let node2: ImageCollectionNode
    let node3: ImageCollectionNode
}

struct CapOffNode4 {
    let node1: ImageCollectionNode
    let node2: ImageCollectionNode
    let node3: ImageCollectionNode
    let node4: ImageCollectionNode
}

class CapOffHeightBucket {
    let height: Int
    var nodesSelected = [ImageCollectionNode]()
    var nodesUnselected = [ImageCollectionNode]()
    init(height: Int) {
        self.height = height
    }
}

struct CapOffTwoSumBucketPair {
    let heightBucket1: CapOffHeightBucket
    let heightBucket2: CapOffHeightBucket
    init(heightBucket1: CapOffHeightBucket, heightBucket2: CapOffHeightBucket) {
        self.heightBucket1 = heightBucket1
        self.heightBucket2 = heightBucket2
    }
}

class CapOffTwoSumBucket {
    let height: Int
    var pairs = [CapOffTwoSumBucketPair]()
    init(height: Int) {
        self.height = height
    }
}

struct CapOffThreeSumBucketPair {
    let twoSumBucket: CapOffTwoSumBucket
    let heightBucket: CapOffHeightBucket
    init(twoSumBucket: CapOffTwoSumBucket, heightBucket: CapOffHeightBucket) {
        self.twoSumBucket = twoSumBucket
        self.heightBucket = heightBucket
    }
}

class CapOffThreeSumBucket {
    let height: Int
    var pairs = [CapOffThreeSumBucketPair]()
    init(height: Int) {
        self.height = height
    }
}

class ConceptLayout {
    
    var layoutWidth: CGFloat = 256.0
    var layoutHeight: CGFloat = 256.0
    var gridWidth: Int = 0
    
    var centerX: CGFloat = 128.0
    var centerY: CGFloat = 128.0
    
    var concepts = [ConceptModel]()
    var rects = [RectModel]()
    var strips = [ConceptStrip]()
    fileprivate var capoffNodes = [ImageCollectionNode]()
    
    fileprivate var capoffMatches1 = [CapOffMatch1]()
    fileprivate var capoffMatches2 = [CapOffMatch2]()
    fileprivate var capoffMatches3 = [CapOffMatch3]()
    fileprivate var capoffMatches4 = [CapOffMatch4]()
    fileprivate var capoffHeightBucketList = [CapOffHeightBucket]()
    fileprivate var capoffHeightBucketDict = [Int: CapOffHeightBucket]()
    
    fileprivate var capoffTwoSumBucketList = [CapOffTwoSumBucket]()
    fileprivate var capoffTwoSumBucketDict = [Int: CapOffTwoSumBucket]()
    
    fileprivate var capoffThreeSumBucketList = [CapOffThreeSumBucket]()
    fileprivate var capoffThreeSumBucketDict = [Int: CapOffThreeSumBucket]()
    
    let imageBucket: ImageBucket
    let randomBucket = RandomBucket()
    
    var stripLayoutNodeType: LayoutNodeType = .any
    
    var baseID = 0
    func incrementBaseID() {
        if baseID != Int.max {
            baseID += 1
        } else {
            baseID = Int.min
        }
    }
    
    func findLargestAppropriateColumnWidthForSizeOne() -> Int {
        var maxWidth = 200
        if ApplicationController.isIpad() { maxWidth = 300 }
        return maxWidth
    }
    
    func findLargestAppropriateColumnWidthForSizeTwo() -> Int {
        var maxWidth = 180
        if ApplicationController.isIpad() { maxWidth = 270 }
        return maxWidth
    }
    
    func findLargestAppropriateColumnWidthFor(gridWidth: Int) -> Int {
        if gridWidth <= 1 {
            return findLargestAppropriateColumnWidthForSizeOne()
        } else if gridWidth <= 2 {
            return findLargestAppropriateColumnWidthForSizeTwo()
        } else {
            var maxWidth = 150
            if ApplicationController.isIpad() { maxWidth = 225 }
            return maxWidth
        }
    }
    
    required init(imageBucket: ImageBucket) {
        self.imageBucket = imageBucket
        randomBucket.shuffle()
    }
    
    func register(layoutWidth: CGFloat,
                  layoutHeight: CGFloat,
                  gridWidth: Int) {
        self.layoutWidth = layoutWidth
        self.layoutHeight = layoutHeight
        self.gridWidth = gridWidth
        self.centerX = CGFloat(Int(layoutWidth * 0.5 + 0.5))
        self.centerY = CGFloat(Int(layoutHeight * 0.5 + 0.5))
    }
    
    @discardableResult
    func addStrip(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> ConceptStrip {
        let result = ConceptStrip(x: x, y: y, width: width, height: height)
        rects.append(RectModel(id: baseID, x: x, y: y, width: width, height: height, color: UIColor.green.withAlphaComponent(0.5)))
        incrementBaseID()
        return result
    }
    
    @discardableResult
    func placeStripsIn(rect: CGRect, gridWidth: Int) -> StripPlacementResult {
        
        let result = StripPlacementResult()
        result.rect = rect
        
        if rect.size.width <= 0 { return result }
        if rect.size.height <= 0 { return result }
        if gridWidth <= 0 { return result }
        
        let largestAppropriateColumnWidth = findLargestAppropriateColumnWidthFor(gridWidth: gridWidth)
        var widthArray = widthArray(width: Int(rect.size.width + 0.5), gridWidth: gridWidth)
        for index in 0..<gridWidth {
            if widthArray[index] > largestAppropriateColumnWidth {
                widthArray[index] = largestAppropriateColumnWidth
            }
        }
        
        let totalWidth = widthArray.reduce(0, +)
        var x: Int = Int(rect.minX + 0.5)
        if totalWidth < Int(rect.size.width) {
            x = Int(rect.midX - CGFloat(totalWidth) * 0.5 + 0.5)
        }
        
        let startX = x
        for index in 0..<gridWidth {
            let strip = addStrip(x: CGFloat(x),
                                 y: rect.minY,
                                 width: CGFloat(widthArray[index]),
                                 height: rect.height)
            result.strips.append(strip)
            strips.append(strip)
            x += widthArray[index]
        }
        
        result.rect = CGRect(x: CGFloat(startX), y: rect.origin.y, width: CGFloat(x - startX), height: rect.height)
        return result
    }
    
    func widthArray(width: Int, gridWidth: Int) -> [Int] {
        var result = [Int]()
        if gridWidth <= 0 {
            return result
        }
        if width <= 0 {
            for _ in 0..<gridWidth {
                result.append(0)
            }
            return result
        }
        var width = width
        let baseWidth = width / gridWidth
        for _ in 0..<gridWidth {
            result.append(baseWidth)
            width -= baseWidth
        }
        while width > 0 {
            for colIndex in 0..<gridWidth {
                result[colIndex] += 1
                width -= 1
                if width <= 0 { break }
            }
        }
        return result
    }
    
    func xArray(x: Int, widthArray: [Int], gridWidth: Int) -> [Int] {
        var result = [Int]()
        if gridWidth <= 0 {
            return result
        }
        var x = x
        for index in 0..<gridWidth {
            result.append(x)
            x += widthArray[index] + gridWidth
        }
        return result
    }
    
    func collidesWithAnyOtherConcept(rect: CGRect, padding: CGFloat) -> Bool {
        
        let rectModified = CGRect(x: rect.minX - padding, y: rect.minY - padding, width: rect.width + (padding + padding), height: rect.height + (padding + padding))
        for concept in concepts {
            if concept.rect.intersects(rectModified) {
                return true
            }
        }
        return false
    }
    
    //fileprivate var _usedNodes = Set<ImageCollectionNode>()
    
    fileprivate var _unselectedWords = [ImageCollectionNode]()
    fileprivate var _unselectedIdeas = [ImageCollectionNode]()
    fileprivate var _selectedWords = [ImageCollectionNode]()
    fileprivate var _selectedIdeas = [ImageCollectionNode]()
    
    fileprivate var _unselectedWordsIndex = 0
    fileprivate var _unselectedWordsCount = 0
    fileprivate var _usedUnselectedWordsCount = 0
    fileprivate var _unselectedIdeasIndex = 0
    fileprivate var _unselectedIdeasCount = 0
    fileprivate var _usedUnselectedIdeasCount = 0
    fileprivate var _selectedWordsIndex = 0
    fileprivate var _selectedWordsCount = 0
    fileprivate var _usedSelectedWordsCount = 0
    fileprivate var _selectedIdeasIndex = 0
    fileprivate var _selectedIdeasCount = 0
    fileprivate var _usedSelectedIdeasCount = 0
    
    func beginFreshBuild() {
        
        concepts.removeAll(keepingCapacity: true)
        rects.removeAll(keepingCapacity: true)
        strips.removeAll(keepingCapacity: true)
        
        _selectedWords.removeAll(keepingCapacity: true)
        _unselectedWords.removeAll(keepingCapacity: true)
        for node in imageBucket.words {
            node.tempUsed = false
            if imageBucket.isSelected(node: node) {
                _selectedWords.append(node)
            } else {
                _unselectedWords.append(node)
            }
        }
        _selectedWordsCount = _selectedWords.count
        _selectedWordsIndex = 0
        _unselectedWordsCount = _unselectedWords.count
        _unselectedWordsIndex = 0
        _usedUnselectedWordsCount = 0
        _usedSelectedWordsCount = 0
        
        _selectedIdeas.removeAll(keepingCapacity: true)
        _unselectedIdeas.removeAll(keepingCapacity: true)
        for node in imageBucket.ideas {
            node.tempUsed = false
            if imageBucket.isSelected(node: node) {
                _selectedIdeas.append(node)
            } else {
                _unselectedIdeas.append(node)
            }
        }
        _selectedIdeasCount = _selectedIdeas.count
        _selectedIdeasIndex = 0
        _unselectedIdeasCount = _unselectedIdeas.count
        _unselectedIdeasIndex = 0
        _usedUnselectedIdeasCount = 0
        _usedSelectedIdeasCount = 0
    }
    
    func dequeueAny() -> ImageCollectionNode? {
        //Todo: Use bucket
        if Bool.random() {
            if let result = dequeueWord() {
                return result
            }
            return dequeueIdea()
        } else {
            if let result = dequeueIdea() {
                return result
            }
            return dequeueWord()
        }
    }
    
    func dequeueIdea() -> ImageCollectionNode? {
        if _usedSelectedIdeasCount < _selectedIdeasCount {
            return dequeueAnyRotating(array: &_selectedIdeas,
                                      index: &_selectedIdeasIndex,
                                      count: &_selectedIdeasCount,
                                      usedCount: &_usedSelectedIdeasCount)
        }
        if _usedUnselectedIdeasCount < _unselectedIdeasCount {
            return dequeueAnyRotating(array: &_unselectedIdeas,
                                      index: &_unselectedIdeasIndex,
                                      count: &_unselectedIdeasCount,
                                      usedCount: &_usedUnselectedIdeasCount)
        }
        return nil
    }
    
    func dequeueWord() -> ImageCollectionNode? {
        if _usedSelectedWordsCount < _selectedWordsCount {
            return dequeueAnyRotating(array: &_selectedWords,
                                      index: &_selectedWordsIndex,
                                      count: &_selectedWordsCount,
                                      usedCount: &_usedSelectedWordsCount)
        }
        if _usedUnselectedWordsCount < _unselectedWordsCount {
            return dequeueAnyRotating(array: &_unselectedWords,
                                      index: &_unselectedWordsIndex,
                                      count: &_unselectedWordsCount,
                                      usedCount: &_usedUnselectedWordsCount)
        }
        return nil
    }
    
    private func dequeueAnyRotating(array: inout [ImageCollectionNode],
                                   index: inout Int,
                                   count: inout Int,
                                   usedCount: inout Int) -> ImageCollectionNode? {
        
        guard array.count > 0 else {
            return nil
        }
        
        guard (index >= 0) && (index < array.count) else {
            print("selectAnyRotating, fatal: index \(index) count: \(count)")
            print("selectAnyRotating, fatal: \(array)")
            return nil
        }
        
        let startIndex = index
        var lastIndex = startIndex - 1
        if lastIndex < 0 { lastIndex = array.count - 1 }
        
        while true {
            
            let checkNode = array[index]
            index += 1
            if index == array.count {
                index = 0
            }
            if !checkNode.tempUsed {
                usedCount += 1
                checkNode.tempUsed = true
                return checkNode
            }
            if index == lastIndex {
                break
            }
        }
        return nil
    }
    
    var conceptWidthMapping = [NodeWidthConceptWidth: CGFloat]()
    func getWidthRatio(node: ImageCollectionNode, strip: ConceptStrip) -> CGFloat {
        let nodeWidthConceptWidth = NodeWidthConceptWidth(nodeWidth: node.width, stripWidth: strip.width)
        if let result = conceptWidthMapping[nodeWidthConceptWidth] {
            return result
        }
        var result = 0.0
        if node.width > 0.1 {
            result = (strip.width / node.width)
        }
        conceptWidthMapping[nodeWidthConceptWidth] = result
        return result
    }
    
    func addConceptsToEachStrip() {
        
        // First compute the "filled" height for each strip...
        // This will be 2 x average height...
        
        
        
        // First keep filling the strips until cannot.
        var reloop = true
        while reloop {
            reloop = false
            if !reloop {
                
                var indices = [Int]()
                for index in 0..<strips.count {
                    indices.append(index)
                }
                for index in 0..<strips.count {
                    let rand = randomBucket.nextInt(strips.count)
                    strips.swapAt(index, rand)
                }
                
                for index in indices {
                    if !strips[index].shouldBeCappedOff() {
                        if addBestPossibleConceptConsideringOnlySelectedNodes(strip: strips[index],
                                                                              stripLayoutNodeType: stripLayoutNodeType) {
                            reloop = true
                        }
                    }
                }
            }
            if !reloop {
                
                var indices = [Int]()
                for index in 0..<strips.count {
                    indices.append(index)
                }
                for index in 0..<strips.count {
                    let rand = randomBucket.nextInt(strips.count)
                    strips.swapAt(index, rand)
                }
                
                for index in indices {
                    if !strips[index].shouldBeCappedOff() {
                        if addBestPossibleConceptConsideringOnlyUnselectedNodes(strip: strips[index],
                                                                                stripLayoutNodeType: stripLayoutNodeType) {
                            reloop = true
                        }
                    }
                }
            }
        }
        
        
        for strip in strips {
            capOff(strip: strip, stripLayoutNodeType: stripLayoutNodeType)
        }
        
        for strip in strips {
            strip.layoutConceptsFromTopDown(bucket: randomBucket)
            for concept in strip.concepts {
                concepts.append(concept)
                concept.id = baseID
                incrementBaseID()
            }
        }
        
        //NodeWidthMapping
        
    }
    
}


extension ConceptLayout {
    
    /*
    private var _usedNodes = Set<ImageCollectionNode>()
    
    private var _unselectedWords = [ImageCollectionNode]()
    private var _unselectedIdeas = [ImageCollectionNode]()
    private var _selectedWords = [ImageCollectionNode]()
    private var _selectedIdeas = [ImageCollectionNode]()
    
    private var _unselectedWordsIndex = 0
    private var _unselectedWordsCount = 0
    private var _usedUnselectedWordsCount = 0
    private var _unselectedIdeasIndex = 0
    private var _unselectedIdeasCount = 0
    private var _usedUnselectedIdeasCount = 0
    private var _selectedWordsIndex = 0
    private var _selectedWordsCount = 0
    private var _usedSelectedWordsCount = 0
    private var _selectedIdeasIndex = 0
    private var _selectedIdeasCount = 0
    private var _usedSelectedIdeasCount = 0
    */
    
    
    private func addBestPossibleConceptConsideringOnlyUnselectedWordNodes(strip: ConceptStrip) -> Bool {
        
        let count = _unselectedWords.count
        guard count > 0 else { return false }
        if _unselectedWordsIndex < 0 { _unselectedWordsIndex = 0 }
        if _unselectedWordsIndex >= count { _unselectedWordsIndex = (count - 1) }
        
        let startIndex = _unselectedWordsIndex
        while true {
            let node = _unselectedWords[_unselectedWordsIndex]
            _unselectedWordsIndex += 1
            if _unselectedWordsIndex == count {
                _unselectedWordsIndex = 0
            }
            if !node.tempUsed {
                let ratio = getWidthRatio(node: node, strip: strip)
                if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                    _usedUnselectedWordsCount += 1
                    node.tempUsed = true
                    strip.add(node: node, ratio: ratio)
                    return true
                }
            }
            if _unselectedWordsIndex == startIndex {
                break
            }
        }
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlyUnselectedIdeaNodes(strip: ConceptStrip) -> Bool {
        let count = _unselectedIdeas.count
        guard count > 0 else { return false }
        if _unselectedIdeasIndex < 0 { _unselectedIdeasIndex = 0 }
        if _unselectedIdeasIndex >= count { _unselectedIdeasIndex = (count - 1) }
        
        let startIndex = _unselectedIdeasIndex
        while true {
            let node = _unselectedIdeas[_unselectedIdeasIndex]
            _unselectedIdeasIndex += 1
            if _unselectedIdeasIndex == count {
                _unselectedIdeasIndex = 0
            }
            if !node.tempUsed {
                let ratio = getWidthRatio(node: node, strip: strip)
                if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                    _usedUnselectedIdeasCount += 1
                    node.tempUsed = true
                    strip.add(node: node, ratio: ratio)
                    return true
                }
            }
            if _unselectedIdeasIndex == startIndex {
                break
            }
        }
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlyUnselectedNodesMixed(strip: ConceptStrip) -> Bool {
        
        let countWords = _unselectedWords.count
        guard countWords > 0 else { return addBestPossibleConceptConsideringOnlyUnselectedIdeaNodes(strip: strip) }
        
        let countIdeas = _unselectedIdeas.count
        guard countIdeas > 0 else { return addBestPossibleConceptConsideringOnlyUnselectedWordNodes(strip: strip) }
        
        if _unselectedWordsIndex < 0 { _unselectedWordsIndex = 0 }
        if _unselectedWordsIndex >= countWords { _unselectedWordsIndex = (countWords - 1) }
        
        if _unselectedIdeasIndex < 0 { _unselectedIdeasIndex = 0 }
        if _unselectedIdeasIndex >= countIdeas { _unselectedIdeasIndex = (countIdeas - 1) }
        
        let startIndexWords = _unselectedWordsIndex
        let startIndexIdeas = _unselectedIdeasIndex
        
        var finishedCheckingWords = false
        var finishedCheckingIdeas = false
        
        var type = ImageCollectionNodeType.word
        
        while (finishedCheckingWords == false) || (finishedCheckingIdeas == false) {
            
            if finishedCheckingWords {
                type = .idea
            } else if finishedCheckingIdeas {
                type = .word
            } else {
                if randomBucket.nextBool() {
                    type = .idea
                } else {
                    type = .word
                }
            }
            
            switch type {
            case .word:
                
                let node = _unselectedWords[_unselectedWordsIndex]
                _unselectedWordsIndex += 1
                if _unselectedWordsIndex == countWords {
                    _unselectedWordsIndex = 0
                }
                if !node.tempUsed {
                    let ratio = getWidthRatio(node: node, strip: strip)
                    if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                        _usedUnselectedWordsCount += 1
                        node.tempUsed = true
                        strip.add(node: node, ratio: ratio)
                        return true
                    }
                }
                if _unselectedWordsIndex == startIndexWords {
                    finishedCheckingWords = true
                }
            case .idea:
                let node = _unselectedIdeas[_unselectedIdeasIndex]
                _unselectedIdeasIndex += 1
                if _unselectedIdeasIndex == countIdeas {
                    _unselectedIdeasIndex = 0
                }
                if !node.tempUsed {
                    let ratio = getWidthRatio(node: node, strip: strip)
                    if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                        _usedUnselectedIdeasCount += 1
                        node.tempUsed = true
                        strip.add(node: node, ratio: ratio)
                        return true
                    }
                }
                if _unselectedIdeasIndex == startIndexIdeas {
                    finishedCheckingIdeas = true
                }
            }
        }
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlySelectedWordNodes(strip: ConceptStrip) -> Bool {
            
        let count = _selectedWords.count
        guard count > 0 else { return false }
        if _selectedWordsIndex < 0 { _selectedWordsIndex = 0 }
        if _selectedWordsIndex >= count { _selectedWordsIndex = (count - 1) }
        
        let startIndex = _selectedWordsIndex
        while true {
            let node = _selectedWords[_selectedWordsIndex]
            _selectedWordsIndex += 1
            if _selectedWordsIndex == count {
                _selectedWordsIndex = 0
            }
            if !node.tempUsed {
                let ratio = getWidthRatio(node: node, strip: strip)
                if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                    _usedSelectedWordsCount += 1
                    node.tempUsed = true
                    strip.add(node: node, ratio: ratio)
                    return true
                }
            }
            if _selectedWordsIndex == startIndex {
                break
            }
        }
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlySelectedIdeaNodes(strip: ConceptStrip) -> Bool {
        let count = _selectedIdeas.count
        guard count > 0 else { return false }
        if _selectedIdeasIndex < 0 { _selectedIdeasIndex = 0 }
        if _selectedIdeasIndex >= count { _selectedIdeasIndex = (count - 1) }
        
        let startIndex = _selectedIdeasIndex
        while true {
            let node = _selectedIdeas[_selectedIdeasIndex]
            _selectedIdeasIndex += 1
            if _selectedIdeasIndex == count {
                _selectedIdeasIndex = 0
            }
            if !node.tempUsed {
                let ratio = getWidthRatio(node: node, strip: strip)
                if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                    _usedSelectedIdeasCount += 1
                    node.tempUsed = true
                    strip.add(node: node, ratio: ratio)
                    return true
                }
            }
            if _selectedIdeasIndex == startIndex {
                break
            }
        }
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlySelectedNodesMixed(strip: ConceptStrip) -> Bool {
        
        let countWords = _selectedWords.count
        guard countWords > 0 else { return addBestPossibleConceptConsideringOnlySelectedIdeaNodes(strip: strip) }
        
        let countIdeas = _selectedIdeas.count
        guard countIdeas > 0 else { return addBestPossibleConceptConsideringOnlySelectedWordNodes(strip: strip) }
        
        if _selectedWordsIndex < 0 { _selectedWordsIndex = 0 }
        if _selectedWordsIndex >= countWords { _selectedWordsIndex = (countWords - 1) }
        
        if _selectedIdeasIndex < 0 { _selectedIdeasIndex = 0 }
        if _selectedIdeasIndex >= countIdeas { _selectedIdeasIndex = (countIdeas - 1) }
        
        let startIndexWords = _selectedWordsIndex
        let startIndexIdeas = _selectedIdeasIndex
        
        var finishedCheckingWords = false
        var finishedCheckingIdeas = false
        
        var type = ImageCollectionNodeType.word
        
        while (finishedCheckingWords == false) || (finishedCheckingIdeas == false) {
            
            if finishedCheckingWords {
                type = .idea
            } else if finishedCheckingIdeas {
                type = .word
            } else {
                if randomBucket.nextBool() {
                    type = .idea
                } else {
                    type = .word
                }
            }
            
            switch type {
            case .word:
                
                let node = _selectedWords[_selectedWordsIndex]
                _selectedWordsIndex += 1
                if _selectedWordsIndex == countWords {
                    _selectedWordsIndex = 0
                }
                if !node.tempUsed {
                    let ratio = getWidthRatio(node: node, strip: strip)
                    if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                        _usedSelectedWordsCount += 1
                        node.tempUsed = true
                        strip.add(node: node, ratio: ratio)
                        return true
                    }
                }
                if _selectedWordsIndex == startIndexWords {
                    finishedCheckingWords = true
                }
            case .idea:
                let node = _selectedIdeas[_selectedIdeasIndex]
                _selectedIdeasIndex += 1
                if _selectedIdeasIndex == countIdeas {
                    _selectedIdeasIndex = 0
                }
                if !node.tempUsed {
                    let ratio = getWidthRatio(node: node, strip: strip)
                    if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                        _usedSelectedIdeasCount += 1
                        node.tempUsed = true
                        strip.add(node: node, ratio: ratio)
                        return true
                    }
                }
                if _selectedIdeasIndex == startIndexIdeas {
                    finishedCheckingIdeas = true
                }
            }
        }
        return false
    }
    
    func addBestPossibleConceptConsideringOnlySelectedNodes(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType) -> Bool {
        switch stripLayoutNodeType {
        case .any:
            if (_usedSelectedWordsCount < _selectedWordsCount) {
                if (_usedSelectedIdeasCount < _selectedIdeasCount) {
                    return addBestPossibleConceptConsideringOnlySelectedNodesMixed(strip: strip)
                } else {
                    return addBestPossibleConceptConsideringOnlySelectedWordNodes(strip: strip)
                }
            } else if (_usedSelectedIdeasCount < _selectedIdeasCount) {
                return addBestPossibleConceptConsideringOnlySelectedIdeaNodes(strip: strip)
            } else {
                //can't use any of this
                return false
            }
        case .idea:
            if (_usedSelectedIdeasCount < _selectedIdeasCount) {
                return addBestPossibleConceptConsideringOnlySelectedIdeaNodes(strip: strip)
            } else {
                return false
            }
        case .word:
            if (_usedSelectedWordsCount < _selectedWordsCount) {
                return addBestPossibleConceptConsideringOnlySelectedWordNodes(strip: strip)
            } else {
                return false
            }
        }
    }
    
    func addBestPossibleConceptConsideringOnlyUnselectedNodes(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType) -> Bool {
        switch stripLayoutNodeType {
        case .any:
            if (_usedUnselectedWordsCount < _unselectedWordsCount) {
                if (_usedUnselectedIdeasCount < _unselectedIdeasCount) {
                    return addBestPossibleConceptConsideringOnlyUnselectedNodesMixed(strip: strip)
                } else {
                    return addBestPossibleConceptConsideringOnlyUnselectedWordNodes(strip: strip)
                }
            } else if (_usedUnselectedIdeasCount < _unselectedIdeasCount) {
                return addBestPossibleConceptConsideringOnlyUnselectedIdeaNodes(strip: strip)
            } else {
                return false
            }
        case .idea:
            if (_usedUnselectedIdeasCount < _unselectedIdeasCount) {
                return addBestPossibleConceptConsideringOnlyUnselectedIdeaNodes(strip: strip)
            } else {
                return false
            }
        case .word:
            if (_usedUnselectedWordsCount < _unselectedWordsCount) {
                return addBestPossibleConceptConsideringOnlyUnselectedWordNodes(strip: strip)
            } else {
                return false
            }
        }
    }
    
}

//This is the idea:
//For start index, find upper / lower bound. (this 2 sum)
//For s1, s2, upper/lower bound (this 3 sum)

/*
func lowerBound(element: Element) -> Int {
    var start = 0
    var end = count
    while start != end {
        let mid = (start + end) >> 1
        if element > values[mid] {
            start = mid + 1
        } else {
            end = mid
        }
    }
    return start
}

func upperBound(element: Element) -> Int {
    var start = 0
    var end = count
    while start != end {
        let mid = (start + end) >> 1
        if element >= values[mid] {
            start = mid + 1
        } else {
            end = mid
        }
    }
    return start
}
*/

extension ConceptLayout {
    
    static var capoffTolerance: Int = ApplicationController.isIpad() ? 10 : 6
    
    private func capOffUse(node: ImageCollectionNode) {
        node.tempUsed = true
        switch node.type {
        case .word:
            if node.tempSelected {
                _usedSelectedWordsCount += 1
            } else {
                _usedUnselectedWordsCount += 1
            }
        case .idea:
            if node.tempSelected {
                _usedSelectedIdeasCount += 1
            } else {
                _usedUnselectedIdeasCount += 1
            }
        }
    }
    
    func threeSumBucketLowerBound(height: Int) -> Int {
        var start = 0
        var end = capoffThreeSumBucketList.count
        while start != end {
            let mid = (start + end) >> 1
            if height > capoffThreeSumBucketList[mid].height {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
    }

    func threeSumBucketUpperBound(height: Int) -> Int {
        var start = 0
        var end = capoffThreeSumBucketList.count
        while start != end {
            let mid = (start + end) >> 1
            if height >= capoffThreeSumBucketList[mid].height {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
    }
    
    func twoSumBucketLowerBound(height: Int) -> Int {
        var start = 0
        var end = capoffTwoSumBucketList.count
        while start != end {
            let mid = (start + end) >> 1
            if height > capoffTwoSumBucketList[mid].height {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
    }

    func twoSumBucketUpperBound(height: Int) -> Int {
        var start = 0
        var end = capoffTwoSumBucketList.count
        while start != end {
            let mid = (start + end) >> 1
            if height >= capoffTwoSumBucketList[mid].height {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
    }
    
    
    func oneSumBucketLowerBound(height: Int) -> Int {
        var start = 0
        var end = capoffHeightBucketList.count
        while start != end {
            let mid = (start + end) >> 1
            if height > capoffHeightBucketList[mid].height {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
    }

    func oneSumBucketUpperBound(height: Int) -> Int {
        var start = 0
        var end = capoffHeightBucketList.count
        while start != end {
            let mid = (start + end) >> 1
            if height >= capoffHeightBucketList[mid].height {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
    }
    
    func bestSelectedCount(bucket1: CapOffHeightBucket) -> Int {
        var result = 0
        if bucket1.nodesSelected.count > 0 { result += 1 }
        return result
    }
    
    func bestSelectedCount(bucket1: CapOffHeightBucket, bucket2: CapOffHeightBucket) -> Int {
        var result = 0
        if bucket1.nodesSelected.count > 0 { result += 1 }
        if bucket2.nodesSelected.count > 0 { result += 1 }
        return result
    }
    
    func bestSelectedCount(bucket1: CapOffHeightBucket, bucket2: CapOffHeightBucket, bucket3: CapOffHeightBucket) -> Int {
        var result = 0
        if bucket1.nodesSelected.count > 0 { result += 1 }
        if bucket2.nodesSelected.count > 0 { result += 1 }
        if bucket3.nodesSelected.count > 0 { result += 1 }
        return result
    }
    
    func bestSelectedCount(bucket1: CapOffHeightBucket, bucket2: CapOffHeightBucket, bucket3: CapOffHeightBucket, bucket4: CapOffHeightBucket) -> Int {
        var result = 0
        if bucket1.nodesSelected.count > 0 { result += 1 }
        if bucket2.nodesSelected.count > 0 { result += 1 }
        if bucket3.nodesSelected.count > 0 { result += 1 }
        if bucket4.nodesSelected.count > 0 { result += 1 }
        return result
    }
    
    func capOff(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType) {
        
        capoffHeightBucketList.removeAll(keepingCapacity: true)
        capoffHeightBucketDict.removeAll(keepingCapacity: true)
        
        capoffTwoSumBucketList.removeAll(keepingCapacity: true)
        capoffTwoSumBucketDict.removeAll(keepingCapacity: true)
        
        capoffThreeSumBucketList.removeAll(keepingCapacity: true)
        capoffThreeSumBucketDict.removeAll(keepingCapacity: true)
        
        capoffNodes.removeAll(keepingCapacity: true)
        
        if stripLayoutNodeType == .any || stripLayoutNodeType == .word {
            for node in _selectedWords where !node.tempUsed {
                node.tempSelected = true
                capoffNodes.append(node)
            }
            for node in _unselectedWords where !node.tempUsed {
                node.tempSelected = false
                capoffNodes.append(node)
            }
        }
        
        if stripLayoutNodeType == .any || stripLayoutNodeType == .word {
            for node in _selectedIdeas where !node.tempUsed {
                node.tempSelected = true
                capoffNodes.append(node)
            }
            for node in _unselectedIdeas where !node.tempUsed {
                node.tempSelected = false
                capoffNodes.append(node)
            }
        }
        
        for node in capoffNodes {
            let ratio = getWidthRatio(node: node, strip: strip)
            node.tempWidth = Int(strip.width + 0.5)
            node.tempHeight = Int(node.height * ratio + 0.5)
        }
        
        for node in capoffNodes {
            if let bucket = capoffHeightBucketDict[node.tempHeight] {
                if node.tempSelected {
                    bucket.nodesSelected.append(node)
                } else {
                    bucket.nodesUnselected.append(node)
                }
            } else {
                let bucket = CapOffHeightBucket(height: node.tempHeight)
                if node.tempSelected {
                    bucket.nodesSelected.append(node)
                } else {
                    bucket.nodesUnselected.append(node)
                }
                capoffHeightBucketDict[node.tempHeight] = bucket
                capoffHeightBucketList.append(bucket)
            }
        }
        
        capoffHeightBucketList.sort {
            $0.height < $1.height
        }
        
        let target = Int((strip.height - strip.conceptsHeight) + 0.5)
        
        var index1: Int = 0
        var cap1: Int = 0
        var index2: Int = 0
        var cap2: Int = 0
        
        index1 = 0
        cap1 = (capoffHeightBucketList.count - 1)
        cap2 = capoffHeightBucketList.count
        while index1 < cap1 {
            index2 = index1 + 1
            while index2 < cap2 {
                let sum = capoffHeightBucketList[index1].height + capoffHeightBucketList[index2].height
                if sum < target {
                    if let bucket = capoffTwoSumBucketDict[sum] {
                        bucket.pairs.append(CapOffTwoSumBucketPair(heightBucket1: capoffHeightBucketList[index1],
                                                                   heightBucket2: capoffHeightBucketList[index2]))
                    } else {
                        let bucket = CapOffTwoSumBucket(height: sum)
                        bucket.pairs.append(CapOffTwoSumBucketPair(heightBucket1: capoffHeightBucketList[index1],
                                                                   heightBucket2: capoffHeightBucketList[index2]))
                        capoffTwoSumBucketList.append(bucket)
                        capoffTwoSumBucketDict[sum] = bucket
                    }
                    index2 += 1
                } else {
                    break
                }
            }
            index1 += 1
        }
        
        capoffTwoSumBucketList.sort {
            $0.height < $1.height
        }
        
        index1 = 0
        cap1 = (capoffHeightBucketList.count - 2)
        cap2 = capoffTwoSumBucketList.count
        while index1 < cap1 {
            index2 = 0
            while index2 < cap2 {
                let sum = capoffHeightBucketList[index1].height + capoffTwoSumBucketList[index2].height
                if sum < target {
                    if let bucket = capoffThreeSumBucketDict[sum] {
                        bucket.pairs.append(CapOffThreeSumBucketPair(twoSumBucket: capoffTwoSumBucketList[index2], heightBucket: capoffHeightBucketList[index1]))
                    } else {
                        let bucket = CapOffThreeSumBucket(height: sum)
                        bucket.pairs.append(CapOffThreeSumBucketPair(twoSumBucket: capoffTwoSumBucketList[index2], heightBucket: capoffHeightBucketList[index1]))
                        capoffThreeSumBucketDict[sum] = bucket
                        capoffThreeSumBucketList.append(bucket)
                    }
                    index2 += 1
                } else {
                    break
                }
            }
            index1 += 1
        }
        
        capoffThreeSumBucketList.sort {
            $0.height < $1.height
        }
        
        capoffMatches1.removeAll(keepingCapacity: true)
        capoffMatches2.removeAll(keepingCapacity: true)
        capoffMatches3.removeAll(keepingCapacity: true)
        capoffMatches4.removeAll(keepingCapacity: true)
        
        index1 = 0
        cap1 = (capoffHeightBucketList.count - 3)
        while index1 < cap1 {
            let threeSumLowerBound = threeSumBucketLowerBound(height: (target - capoffHeightBucketList[index1].height) - Self.capoffTolerance)
            let threeSumUpperBound = threeSumBucketUpperBound(height: (target - capoffHeightBucketList[index1].height))
            if threeSumUpperBound > threeSumLowerBound {
                let bucket1 = capoffHeightBucketList[index1]
                index2 = threeSumLowerBound
                while index2 < threeSumUpperBound {
                    let threeSumBucket = capoffThreeSumBucketList[index2]
                    for threeSumPair in threeSumBucket.pairs {
                        let bucket2 = threeSumPair.heightBucket
                        for twoSumPair in threeSumPair.twoSumBucket.pairs {
                            let bucket3 = twoSumPair.heightBucket1
                            let bucket4 = twoSumPair.heightBucket2
                            let bestSelectedCount = bestSelectedCount(bucket1: bucket1,
                                                                      bucket2: bucket2,
                                                                      bucket3: bucket3,
                                                                      bucket4: bucket4)
                            let match = CapOffMatch4(bucket1: bucket1,
                                                     bucket2: bucket2,
                                                     bucket3: bucket3,
                                                     bucket4: bucket4,
                                                     bestSelectedCount: bestSelectedCount)
                            capoffMatches4.append(match)
                        }
                    }
                    index2 += 1
                }
            }
            index1 += 1
        }
        
        let threeSumLowerBound = threeSumBucketLowerBound(height: target - Self.capoffTolerance)
        let threeSumUpperBound = threeSumBucketUpperBound(height: target)
        if threeSumUpperBound > threeSumLowerBound {
            index1 = threeSumLowerBound
            while index1 < threeSumUpperBound {
                let threeSumBucket = capoffThreeSumBucketList[index1]
                for threeSumPair in threeSumBucket.pairs {
                    let bucket1 = threeSumPair.heightBucket
                    for twoSumPair in threeSumPair.twoSumBucket.pairs {
                        let bucket2 = twoSumPair.heightBucket1
                        let bucket3 = twoSumPair.heightBucket2
                        let bestSelectedCount = bestSelectedCount(bucket1: bucket1,
                                                                  bucket2: bucket2,
                                                                  bucket3: bucket3)
                        let match = CapOffMatch3(bucket1: bucket1,
                                                 bucket2: bucket2,
                                                 bucket3: bucket3,
                                                 bestSelectedCount: bestSelectedCount)
                        capoffMatches3.append(match)
                    }
                }
                index1 += 1
            }
        }
        
        let twoSumLowerBound = twoSumBucketLowerBound(height: target - Self.capoffTolerance)
        let twoSumUpperBound = twoSumBucketUpperBound(height: target)
        if twoSumUpperBound > twoSumLowerBound {
            index1 = twoSumLowerBound
            while index1 < twoSumUpperBound {
                let twoSumBucket = capoffTwoSumBucketList[index1]
                for twoSumPair in twoSumBucket.pairs {
                    let bucket1 = twoSumPair.heightBucket1
                    let bucket2 = twoSumPair.heightBucket2
                    let bestSelectedCount = bestSelectedCount(bucket1: bucket1,
                                                              bucket2: bucket2)
                    let match = CapOffMatch2(bucket1: bucket1,
                                             bucket2: bucket2,
                                             bestSelectedCount: bestSelectedCount)
                    capoffMatches2.append(match)
                }
                index1 += 1
            }
        }
        
        let oneSumLowerBound = oneSumBucketLowerBound(height: target - Self.capoffTolerance)
        let oneSumUpperBound = oneSumBucketUpperBound(height: target)
        if oneSumUpperBound > oneSumLowerBound {
            index1 = oneSumLowerBound
            while index1 < oneSumUpperBound {
                let bucket1 = capoffHeightBucketList[index1]
                let bestSelectedCount = bestSelectedCount(bucket1: bucket1)
                let match = CapOffMatch1(bucket1: bucket1,
                                         bestSelectedCount: bestSelectedCount)
                capoffMatches1.append(match)
                index1 += 1
            }
        }
        
        capOffStir()
        
        capOffProceedWithMatches(strip: strip, stripLayoutNodeType: stripLayoutNodeType)
    }
    
    func capOffStir() {
        for index in 0..<capoffMatches4.count {
            let rand = randomBucket.nextInt(capoffMatches4.count)
            capoffMatches4.swapAt(rand, index)
        }
        for index in 0..<capoffMatches3.count {
            let rand = randomBucket.nextInt(capoffMatches3.count)
            capoffMatches3.swapAt(rand, index)
        }
        for index in 0..<capoffMatches2.count {
            let rand = randomBucket.nextInt(capoffMatches2.count)
            capoffMatches2.swapAt(rand, index)
        }
        for index in 0..<capoffMatches1.count {
            let rand = randomBucket.nextInt(capoffMatches1.count)
            capoffMatches1.swapAt(rand, index)
        }
        for bucket in capoffHeightBucketList {
            for index in 0..<bucket.nodesSelected.count {
                let rand = randomBucket.nextInt(bucket.nodesSelected.count)
                bucket.nodesSelected.swapAt(rand, index)
            }
            for index in 0..<bucket.nodesUnselected.count {
                let rand = randomBucket.nextInt(bucket.nodesUnselected.count)
                bucket.nodesUnselected.swapAt(rand, index)
            }
        }
    }
    
    func capOffProceedWithMatches(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType) {

        let capOffTypes = capOffTypesRandomized()
        for capOffType in capOffTypes {
            switch capOffType {
            case .one:
                if capOffTryOne(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 1) {
                    return
                }
            case .two:
                if capOffTryTwo(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 2) {
                    return
                }
            case .three:
                if capOffTryThree(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 3) {
                    return
                }
            case .four:
                if capOffTryFour(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 4) {
                    return
                }
            }
        }
        
        if capOffTryFour(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 3) {
            return
        }
        
        if capOffTryThree(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 2) {
            return
        }
        
        if randomBucket.nextBool() {
            if capOffTryTwo(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 1) {
                return
            }
            if capOffTryFour(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 2) {
                return
            }
        } else {
            if capOffTryFour(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 2) {
                return
            }
            if capOffTryTwo(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 1) {
                return
            }
        }
        
        if capOffTryThree(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 1) {
            return
        }
        
        if capOffTryFour(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 1) {
            return
        }
        
        for capOffType in capOffTypes {
            switch capOffType {
            case .one:
                if capOffTryOne(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 0) {
                    return
                }
            case .two:
                if capOffTryTwo(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 0) {
                    return
                }
            case .three:
                if capOffTryThree(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 0) {
                    return
                }
            case .four:
                if capOffTryFour(strip: strip, stripLayoutNodeType: stripLayoutNodeType, requiredSelectedCount: 0) {
                    return
                }
            }
        }
    }
    
    func capOffTypesRandomized() -> [CapOffType] {
        var result: [CapOffType] = [.one, .two, .three, .four]
        for index in 0..<result.count {
            let rand = randomBucket.nextInt(result.count)
            result.swapAt(rand, index)
        }
        return result
    }
    
    func capOffComplete(strip: ConceptStrip, node1: ImageCollectionNode, node2: ImageCollectionNode, node3: ImageCollectionNode, node4: ImageCollectionNode) {
        capOffComplete(strip: strip, node1: node1)
        capOffComplete(strip: strip, node1: node2)
        capOffComplete(strip: strip, node1: node3)
        capOffComplete(strip: strip, node1: node4)
    }
    
    func capOffComplete(strip: ConceptStrip, node1: ImageCollectionNode, node2: ImageCollectionNode, node3: ImageCollectionNode) {
        capOffComplete(strip: strip, node1: node1)
        capOffComplete(strip: strip, node1: node2)
        capOffComplete(strip: strip, node1: node3)
    }
    
    func capOffComplete(strip: ConceptStrip, node1: ImageCollectionNode, node2: ImageCollectionNode) {
        capOffComplete(strip: strip, node1: node1)
        capOffComplete(strip: strip, node1: node2)
    }
    
    func capOffComplete(strip: ConceptStrip, node1: ImageCollectionNode) {
        
        let ratio = getWidthRatio(node: node1, strip: strip)
        strip.add(node: node1, ratio: ratio)
        node1.tempUsed = true
        
        if node1.tempSelected {
            switch node1.type {
            case .word:
                _usedSelectedWordsCount += 1
            case .idea:
                _usedSelectedIdeasCount += 1
            }
        } else {
            switch node1.type {
            case .word:
                _usedUnselectedWordsCount += 1
            case .idea:
                _usedUnselectedIdeasCount += 1
            }
        }
    }
    
    func capOffNotSame(node1: ImageCollectionNode, node2: ImageCollectionNode, node3: ImageCollectionNode, node4: ImageCollectionNode) -> Bool {
        if node1 == node2 { return false }
        if node1 == node3 { return false }
        if node1 == node4 { return false }
        if node2 == node3 { return false }
        if node2 == node4 { return false }
        if node3 == node4 { return false }
        return true
    }
    
    func capOffNotSame(node1: ImageCollectionNode, node2: ImageCollectionNode, node3: ImageCollectionNode) -> Bool {
        if node1 == node2 { return false }
        if node1 == node3 { return false }
        if node2 == node3 { return false }
        return true
    }
    
    func capOffNotSame(node1: ImageCollectionNode, node2: ImageCollectionNode) -> Bool {
        if node1 == node2 { return false }
        return true
    }
    
    func capOffTryOne(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType, requiredSelectedCount: Int) -> Bool {
        
        // Can we just skip this?
        var selectedCountAvailable = 0
        var selectedCountUsed = 0
        switch stripLayoutNodeType {
        case .any:
            selectedCountAvailable = _selectedWordsCount + _selectedIdeasCount
            selectedCountUsed = _usedSelectedWordsCount + _usedSelectedIdeasCount
        case .idea:
            selectedCountAvailable = _selectedIdeasCount
            selectedCountUsed = _usedSelectedIdeasCount
        case .word:
            selectedCountAvailable = _selectedWordsCount
            selectedCountUsed = _usedSelectedWordsCount
        }
        
        if (selectedCountAvailable - selectedCountUsed) < requiredSelectedCount {
            //print("skip try 1, selectedCountAvailable = \(selectedCountAvailable), selectedCountUsed = \(selectedCountUsed), requiredSelectedCount = \(requiredSelectedCount)")
            return false
        }
        
        for match in capoffMatches1 {
            if match.bestSelectedCount == requiredSelectedCount {
                let arr1 = match.bucket1.nodesSelected.count > 0 ? match.bucket1.nodesSelected : match.bucket1.nodesUnselected
                for node1 in arr1 {
                    capOffComplete(strip: strip, node1: node1)
                    return true
                }
            }
        }
        
        return false
    }
    
    func capOffTryTwo(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType, requiredSelectedCount: Int) -> Bool {
        
        // Can we just skip this?
        var selectedCountAvailable = 0
        var selectedCountUsed = 0
        switch stripLayoutNodeType {
        case .any:
            selectedCountAvailable = _selectedWordsCount + _selectedIdeasCount
            selectedCountUsed = _usedSelectedWordsCount + _usedSelectedIdeasCount
        case .idea:
            selectedCountAvailable = _selectedIdeasCount
            selectedCountUsed = _usedSelectedIdeasCount
        case .word:
            selectedCountAvailable = _selectedWordsCount
            selectedCountUsed = _usedSelectedWordsCount
        }
        
        if (selectedCountAvailable - selectedCountUsed) < requiredSelectedCount {
            //print("skip try 2, selectedCountAvailable = \(selectedCountAvailable), selectedCountUsed = \(selectedCountUsed), requiredSelectedCount = \(requiredSelectedCount)")
            return false
        }
        
        for match in capoffMatches2 {
            if match.bestSelectedCount == requiredSelectedCount {
                let arr1 = match.bucket1.nodesSelected.count > 0 ? match.bucket1.nodesSelected : match.bucket1.nodesUnselected
                let arr2 = match.bucket2.nodesSelected.count > 0 ? match.bucket2.nodesSelected : match.bucket2.nodesUnselected
                for node1 in arr1 {
                    for node2 in arr2 {
                        if capOffNotSame(node1: node1, node2: node2) {
                            capOffComplete(strip: strip, node1: node1, node2: node2)
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func capOffTryThree(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType, requiredSelectedCount: Int) -> Bool {
        
        // Can we just skip this?
        var selectedCountAvailable = 0
        var selectedCountUsed = 0
        switch stripLayoutNodeType {
        case .any:
            selectedCountAvailable = _selectedWordsCount + _selectedIdeasCount
            selectedCountUsed = _usedSelectedWordsCount + _usedSelectedIdeasCount
        case .idea:
            selectedCountAvailable = _selectedIdeasCount
            selectedCountUsed = _usedSelectedIdeasCount
        case .word:
            selectedCountAvailable = _selectedWordsCount
            selectedCountUsed = _usedSelectedWordsCount
        }
        
        if (selectedCountAvailable - selectedCountUsed) < requiredSelectedCount {
            //print("skip try 3, selectedCountAvailable = \(selectedCountAvailable), selectedCountUsed = \(selectedCountUsed), requiredSelectedCount = \(requiredSelectedCount)")
            return false
        }
        
        for match in capoffMatches3 {
            if match.bestSelectedCount == requiredSelectedCount {
                let arr1 = match.bucket1.nodesSelected.count > 0 ? match.bucket1.nodesSelected : match.bucket1.nodesUnselected
                let arr2 = match.bucket2.nodesSelected.count > 0 ? match.bucket2.nodesSelected : match.bucket2.nodesUnselected
                let arr3 = match.bucket3.nodesSelected.count > 0 ? match.bucket3.nodesSelected : match.bucket3.nodesUnselected
                for node1 in arr1 {
                    for node2 in arr2 {
                        for node3 in arr3 {
                            if capOffNotSame(node1: node1, node2: node2, node3: node3) {
                                capOffComplete(strip: strip, node1: node1, node2: node2, node3: node3)
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func capOffTryFour(strip: ConceptStrip, stripLayoutNodeType: LayoutNodeType, requiredSelectedCount: Int) -> Bool {
        
        
        // Can we just skip this?
        var selectedCountAvailable = 0
        var selectedCountUsed = 0
        switch stripLayoutNodeType {
        case .any:
            selectedCountAvailable = _selectedWordsCount + _selectedIdeasCount
            selectedCountUsed = _usedSelectedWordsCount + _usedSelectedIdeasCount
        case .idea:
            selectedCountAvailable = _selectedIdeasCount
            selectedCountUsed = _usedSelectedIdeasCount
        case .word:
            selectedCountAvailable = _selectedWordsCount
            selectedCountUsed = _usedSelectedWordsCount
        }
        
        if (selectedCountAvailable - selectedCountUsed) < requiredSelectedCount {
            //print("skip try 4, selectedCountAvailable = \(selectedCountAvailable), selectedCountUsed = \(selectedCountUsed), requiredSelectedCount = \(requiredSelectedCount)")
            return false
        }
         
        for match in capoffMatches4 {
            if match.bestSelectedCount == requiredSelectedCount {
                let arr1 = match.bucket1.nodesSelected.count > 0 ? match.bucket1.nodesSelected : match.bucket1.nodesUnselected
                let arr2 = match.bucket2.nodesSelected.count > 0 ? match.bucket2.nodesSelected : match.bucket2.nodesUnselected
                let arr3 = match.bucket3.nodesSelected.count > 0 ? match.bucket3.nodesSelected : match.bucket3.nodesUnselected
                let arr4 = match.bucket4.nodesSelected.count > 0 ? match.bucket4.nodesSelected : match.bucket4.nodesUnselected
                for node1 in arr1 {
                    for node2 in arr2 {
                        for node3 in arr3 {
                            for node4 in arr4 {
                                if capOffNotSame(node1: node1, node2: node2, node3: node3, node4: node4) {
                                    capOffComplete(strip: strip, node1: node1, node2: node2, node3: node3, node4: node4)
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    
    //var bestSelectedCount = 0
    
    
    
    /*
    func capOffFloodOneSum(target: Int) {
        if capoffNodes.count <= 0 {
            return
        }
        for index1 in 0..<capoffNodes.count {
            let node = capoffNodes[index1]
            if (node.tempHeight <= target) && ((target - node.tempHeight) <= Self.capoffTolerance) {
                capoffMatches1.append(CapOffMatch1(index1: index1))
            }
        }
    }
    
    func capOffFloodTwoSum(target: Int) {
        if capoffNodes.count <= 1 {
            return
        }
        
        var index1 = 0
        var index2 = capoffNodes.count - 1
        
        while index1 < index2 {
            let sum =   capoffNodes[index1].tempHeight +
                        capoffNodes[index2].tempHeight
            if (sum <= target) && ((target - sum) <= Self.capoffTolerance) {
                capoffMatches2.append(CapOffMatch2(index1: index1, index2: index2))
            }
            if sum < target {
                index1 += 1
            } else {
                index2 -= 1
            }
        }
    }
    
    func capOffFloodThreeSum(target: Int) {
        if capoffNodes.count <= 2 {
            return
        }
        
        for index1 in 0..<(capoffNodes.count - 2) {
            var index2 = index1 + 1
            var index3 = capoffNodes.count - 1
            while index2 < index3 {
                let sum =   capoffNodes[index1].tempHeight +
                            capoffNodes[index2].tempHeight +
                            capoffNodes[index3].tempHeight
                if (sum <= target) && ((target - sum) <= Self.capoffTolerance) {
                    capoffMatches3.append(CapOffMatch3(index1: index1, index2: index2, index3: index3))
                }
                if sum < target {
                    index2 += 1
                } else {
                    index3 -= 1
                }
            }
        }
    }
    
    func capOffFloodFourSum(target: Int) {
        if capoffNodes.count <= 3 {
            return
        }
        
        var loops = 0
        for index1 in 0..<(capoffNodes.count - 3) {
            for index2 in (index1 + 1)..<(capoffNodes.count - 2) {
                var index3 = index2 + 1
                var index4 = capoffNodes.count - 1
                while index3 < index4 {
                    loops += 1
                    let sum =   capoffNodes[index1].tempHeight +
                                capoffNodes[index2].tempHeight +
                                capoffNodes[index3].tempHeight +
                                capoffNodes[index4].tempHeight
                    if (sum <= target) && ((target - sum) <= Self.capoffTolerance) {
                        capoffMatches4.append(CapOffMatch4(index1: index1, index2: index2, index3: index3, index4: index4))
                    }
                    if sum < target {
                        index3 += 1
                    } else {
                        index4 -= 1
                    }
                }
            }
        }
        print("loops = \(loops)")
    }
    
    func logSum(cap1: CapOffMatch1, strip: ConceptStrip) {
        let nodes = [capoffNodes[cap1.index1]]
        logSum(result: nodes, strip: strip)
    }
    
    func logSum(cap2: CapOffMatch2, strip: ConceptStrip) {
        let nodes = [capoffNodes[cap2.index1], capoffNodes[cap2.index2]]
        logSum(result: nodes, strip: strip)
    }
    
    func logSum(cap3: CapOffMatch3, strip: ConceptStrip) {
        let nodes = [capoffNodes[cap3.index1], capoffNodes[cap3.index2], capoffNodes[cap3.index3]]
        logSum(result: nodes, strip: strip)
    }
    
    func logSum(cap4: CapOffMatch4, strip: ConceptStrip) {
        let nodes = [capoffNodes[cap4.index1], capoffNodes[cap4.index2], capoffNodes[cap4.index3], capoffNodes[cap4.index4]]
        logSum(result: nodes, strip: strip)
    }
    
    func logSum(result: [ImageCollectionNode], strip: ConceptStrip) {
        
        let remainingHeight = strip.height - strip.conceptsHeight
        let resultHeight = result.reduce(0) { val, node in
            val + node.tempHeight
        }
        print("____________")
        print("best match for \(strip.width) x \(strip.height), remaining: \(remainingHeight), \(result.count) nodes...")
        for (index, node) in result.enumerated() {
            print("node[\(index)][\(node.fileName)] height: \(node.tempHeight), total: \(resultHeight)")
        }
        print("____________")
    }
    */
    
    /*
    func capOffFindClosestMatch(sorted: [ImageCollectionNode], strip: ConceptStrip) -> [ImageCollectionNode] {
        
        let remainingHeight = strip.height - strip.conceptsHeight
        
        let bestOne = capOffFindClosestMatchOneSum(sorted: sorted, target: remainingHeight)
        let bestTwo = capOffFindClosestMatchTwoSum(sorted: sorted, target: remainingHeight)
        let bestThree = capOffFindClosestMatchThreeSum(sorted: sorted, target: remainingHeight)
        
        let sum1 = bestOne.reduce(0) { val, node in
            val + node.tempHeight
        }
        let sum2 = bestTwo.reduce(0) { val, node in
            val + node.tempHeight
        }
        let sum3 = bestThree.reduce(0) { val, node in
            val + node.tempHeight
        }
        
        let diff1 = remainingHeight - sum1
        let diff2 = remainingHeight - sum2
        let diff3 = remainingHeight - sum3
        
        if diff1 < diff2 {
            if diff1 < diff3 {
                return bestOne
            } else {
                return bestThree
            }
        } else {
            if diff2 < diff3 {
                return bestTwo
            } else {
                return bestThree
            }
        }
    }
    
    func capOffFindClosestMatchOneSum(sorted: [ImageCollectionNode], target: CGFloat) -> [ImageCollectionNode] {
        var result = [ImageCollectionNode]()
        if sorted.count <= 0 {
            return result
        }
        
        var bestDistance = CGFloat(1_000_000_000.0)
        for index in 0..<sorted.count {
            let node = sorted[index]
            if node.tempHeight <= target {
                let diff = target - node.tempHeight
                if diff < bestDistance {
                    bestDistance = diff
                    result = [node]
                }
            }
        }
        return result
    }
    
    func capOffFindClosestMatchTwoSum(sorted: [ImageCollectionNode], target: CGFloat) -> [ImageCollectionNode] {
        var result = [ImageCollectionNode]()
        if sorted.count <= 1 {
            return result
        }
        
        var bestDistance = CGFloat(1_000_000_000.0)
        var lo = 0
        var hi = sorted.count - 1
        var chosenIndex1 = -1
        var chosenIndex2 = -1
        
        while lo < hi {
            let sum = sorted[lo].tempHeight + sorted[hi].tempHeight
            if sum <= target {
                let diff = target - sum
                if diff < bestDistance {
                    bestDistance = diff
                    chosenIndex1 = lo
                    chosenIndex2 = hi
                }
            }
            
            if sum < target {
                lo += 1
            } else {
                hi -= 1
            }
        }
        if (chosenIndex1 != -1) && (chosenIndex2 != -1) {
            result = [sorted[chosenIndex1], sorted[chosenIndex2]]
        }
        return result
    }
    
    func capOffFindClosestMatchThreeSum(sorted: [ImageCollectionNode], target: CGFloat) -> [ImageCollectionNode] {
        var result = [ImageCollectionNode]()
        if sorted.count <= 2 {
            return result
        }
        
        var chosenIndex1 = -1
        var chosenIndex2 = -1
        var chosenIndex3 = -1
        
        var bestDistance = CGFloat(1_000_000_000.0)
        for outer in 0..<(sorted.count - 2) {
            var lo = outer + 1
            var hi = sorted.count - 1
            while lo < hi {
                let sum = sorted[outer].tempHeight + sorted[lo].tempHeight + sorted[hi].tempHeight
                if sum <= target {
                    let diff = target - sum
                    if diff < bestDistance {
                        bestDistance = diff
                        chosenIndex1 = outer
                        chosenIndex2 = lo
                        chosenIndex3 = hi
                    }
                }
                if sum < target {
                    lo += 1
                } else {
                    hi -= 1
                }
            }
        }
        if (chosenIndex1 != -1) && (chosenIndex2 != -1) && (chosenIndex3 != -1) {
            result = [sorted[chosenIndex1], sorted[chosenIndex2], sorted[chosenIndex3]]
        }
        return result
    }
    */
    
}

