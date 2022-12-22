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

class ConceptLayout {
    
    var layoutWidth: CGFloat = 256.0
    var layoutHeight: CGFloat = 256.0
    var gridWidth: Int = 0
    
    var centerX: CGFloat = 128.0
    var centerY: CGFloat = 128.0
    
    var concepts = [ConceptModel]()
    var rects = [RectModel]()
    var strips = [ConceptStrip]()
    
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
    
    fileprivate var _usedNodes = Set<ImageCollectionNode>()
    
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
        
        _usedNodes.removeAll(keepingCapacity: true)
        
        _selectedWords.removeAll(keepingCapacity: true)
        _unselectedWords.removeAll(keepingCapacity: true)
        for node in imageBucket.words {
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
    
    func reenqueue(node: ImageCollectionNode) {
        if _usedNodes.contains(node) {
            _usedNodes.remove(node)
            if _selectedWords.contains(node) {
                _usedSelectedWordsCount -= 1
            }
            if _unselectedWords.contains(node) {
                _usedUnselectedWordsCount -= 1
            }
            if _selectedIdeas.contains(node) {
                _usedSelectedIdeasCount -= 1
            }
            if _unselectedIdeas.contains(node) {
                _usedUnselectedIdeasCount -= 1
            }
        }
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
            if !_usedNodes.contains(checkNode) {
                usedCount += 1
                _usedNodes.insert(checkNode)
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
                for strip in strips {
                    if !strip.shouldBeCappedOff() {
                        if addBestPossibleConceptConsideringOnlySelectedNodes(strip: strip,
                                                                              stripLayoutNodeType: stripLayoutNodeType) {
                            reloop = true
                        }
                    }
                    /*
                     print("strip: \(strip.x), \(strip.y), \(strip.width), \(strip.height)")
                     if let dequeue = dequeueAny() {
                     strip.add(node: dequeue, ratio: getWidthRatio(node: dequeue, strip: strip))
                     }
                     */
                }
            }
            if !reloop {
                for strip in strips {
                    if !strip.shouldBeCappedOff() {
                        if addBestPossibleConceptConsideringOnlyUnselectedNodes(strip: strip,
                                                                                stripLayoutNodeType: stripLayoutNodeType) {
                            reloop = true
                        }
                    }
                }
            }
        }
        
        for strip in strips {
            capOff(strip: strip)
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
            if !_usedNodes.contains(node) {
                let ratio = getWidthRatio(node: node, strip: strip)
                if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                    _usedUnselectedWordsCount += 1
                    _usedNodes.insert(node)
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
            if !_usedNodes.contains(node) {
                let ratio = getWidthRatio(node: node, strip: strip)
                if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                    _usedUnselectedIdeasCount += 1
                    _usedNodes.insert(node)
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
                if !_usedNodes.contains(node) {
                    let ratio = getWidthRatio(node: node, strip: strip)
                    if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                        _usedUnselectedWordsCount += 1
                        _usedNodes.insert(node)
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
                if !_usedNodes.contains(node) {
                    let ratio = getWidthRatio(node: node, strip: strip)
                    if strip.canAddWithoutCapping(node: node, ratio: ratio) {
                        _usedUnselectedIdeasCount += 1
                        _usedNodes.insert(node)
                        strip.add(node: node, ratio: ratio)
                        return true
                    }
                }
                if _unselectedIdeasIndex == startIndexIdeas {
                    finishedCheckingIdeas = true
                }
            }
        }
        
        
        //var lastIndexWords = _unselectedWordsIndex - 1
        //if lastIndexWords < 0 { lastIndexWords = (countWords - 1) }
        
        //var lastIndex = _unselectedIdeasIndex - 1
        //if lastIndex < 0 { lastIndex = (count - 1) }
        
        
        
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlySelectedWordNodes(strip: ConceptStrip) -> Bool {
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlySelectedIdeaNodes(strip: ConceptStrip) -> Bool {
        return false
    }
    
    private func addBestPossibleConceptConsideringOnlySelectedNodesMixed(strip: ConceptStrip) -> Bool {
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


extension ConceptLayout {
    
    func capOff(strip: ConceptStrip) {
        
        var nodes = [ImageCollectionNode]()
        for node in _selectedWords where !_usedNodes.contains(node) {
            node.tempSelected = true
            nodes.append(node)
        }
        for node in _selectedIdeas where !_usedNodes.contains(node) {
            node.tempSelected = true
            nodes.append(node)
        }
        for node in _unselectedWords where !_usedNodes.contains(node) {
            node.tempSelected = false
            nodes.append(node)
        }
        for node in _unselectedIdeas where !_usedNodes.contains(node) {
            node.tempSelected = false
            nodes.append(node)
        }
        
        for node in nodes {
            let ratio = getWidthRatio(node: node, strip: strip)
            let adjustedWidth = node.width * ratio
            let adjustedHeight = node.height * ratio
            node.tempWidth = strip.width
            node.tempHeight = node.height * ratio
        }
        
        nodes.sort {
            $0.tempHeight < $1.tempHeight
        }
        
        for node in nodes {
            //print("\(node.fileName) => \(node.tempHeight)")
        }
        
        let match = capOffFindClosestMatch(sorted: nodes, strip: strip)
        
        
        for a in match {
            _usedNodes.insert(a)
            strip.add(node: a, ratio: getWidthRatio(node: a, strip: strip))
        }
        
        /*
        var tempWidth: CGFloat = 0.0
        var tempHeight: CGFloat = 0.0
        var tempSelected: Bool = false
        */
        
        //extension ConceptLayout {
        
        
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
        
        var chosenIndex1 = lo
        var chosenIndex2 = hi
        
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
        result = [sorted[chosenIndex1], sorted[chosenIndex2]]
        return result
    }
    
    func capOffFindClosestMatchThreeSum(sorted: [ImageCollectionNode], target: CGFloat) -> [ImageCollectionNode] {
        var result = [ImageCollectionNode]()
        if sorted.count <= 2 {
            return result
        }
        
        var chosenIndex1 = 0
        var chosenIndex2 = 1
        var chosenIndex3 = 2
        
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
        result = [sorted[chosenIndex1], sorted[chosenIndex2], sorted[chosenIndex3]]
        return result
    }
    
    
    
}

//var adjustedWidth: CGFloat = 0.0
//var adjustedHeight: CGFloat = 0.0


