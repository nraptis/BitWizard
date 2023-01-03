//
//  PairingsLayout.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import UIKit

/*
enum PairingClusterGrade {
    case unknown
    case perfect
    case worthy
    case unworthy
    case terribleOverflow
    case terribleUnderflow
    func score() -> Int {
        switch self {
        case .unknown:
            return 0
        case .perfect:
            return 300
        case .worthy:
            return 250
        case .unworthy:
            return -500
        case .terribleOverflow:
            return -5000
        case .terribleUnderflow:
            return -2500
        }
    }
}
*/

struct PairingCluster {
    var node1: ImageCollectionNode?
    var node2: ImageCollectionNode?
    //var grade = PairingClusterGrade.unknown
    let strip: ConceptStrip
    let plusWidth: CGFloat
    let plusHeight: CGFloat
    init(strip: ConceptStrip, plusWidth: CGFloat, plusHeight: CGFloat) {
        self.strip = strip
        self.plusWidth = plusWidth
        self.plusHeight = plusHeight
    }
    
    mutating func write(cluster: PairingCluster) {
        self.node1 = cluster.node1
        self.node2 = cluster.node2
    }
    
}

class PairingsLayout: ConceptLayout {
    
    private(set) var pluses = [PlusSignModel]()
    
    private var clusters = [PairingCluster]()
    
    let plusSpacingH = ApplicationController.isIpad() ? 6 : 4
    
    let spacingH = ApplicationController.isIpad() ? 12 : 8
    let spacingV = ApplicationController.isIpad() ? 6 : 4
    
    fileprivate var pairingNodes = [ImageCollectionNode]()
    
    required init(imageBucket: ImageBucket) {
        super.init(imageBucket: imageBucket)
    }
    
    deinit {
        
    }
    
    // The obvious problems: Some single images are already too large,
    // we do not want to exclude these images.
    
    // Any concept + Any concept should be valid!!!
    
    // ... There are no two images which should not be able to be compared.
    
    
    func build(gridWidth: Int, showHideMode: ShowHideMode) -> ConceptLayoutBuildResponse {
        
        let result = ConceptLayoutBuildResponse()
        
        clusters.removeAll(keepingCapacity: true)
        
        pluses.removeAll(keepingCapacity: true)
        
        beginFreshBuild(showHideMode: showHideMode)
        
        let paddingLeft = ApplicationController.isIpad() ? 12 : 8
        let paddingRight = ApplicationController.isIpad() ? 12 : 8
        let paddingTop = ApplicationController.isIpad() ? 6 : 4
        let paddingBottom = ApplicationController.isIpad() ? 6 : 4
        
        var availableWidth = Int(layoutWidth + 0.5) - (paddingLeft + paddingRight)
        if gridWidth > 1 {
            availableWidth -= (gridWidth - 1) * spacingH
        }
        
        let _widthArray = widthArray(width: availableWidth, gridWidth: gridWidth)
        
        var _xArray = [Int]()
        var _x = paddingLeft
        for index in 0..<_widthArray.count {
            _xArray.append(_x)
            _x += _widthArray[index] + spacingH
        }
        
        let boxWidth = _widthArray[0]
        let expectedHeight = boxWidth / 4
        
        var availableHeight = Int(layoutHeight + 0.5) - (paddingTop + paddingBottom)
        
        let gridHeight = numberOfRows(availableHeight: CGFloat(availableHeight),
                                      maxHeight: expectedHeight,
                                      spacingV: spacingV)
        
        if gridHeight > 1 {
            availableHeight -= (gridHeight - 1) * spacingV
        }
        
        let _heightArray = widthArray(width: availableHeight, gridWidth: gridHeight)
        
        var _yArray = [Int]()
        var _y = paddingTop
        for index in 0..<_heightArray.count {
            _yArray.append(_y)
            _y += _heightArray[index] + spacingV
        }
        
        for xIndex in 0..<_xArray.count {
            let x = _xArray[xIndex]
            let width = _widthArray[xIndex]
            for yIndex in 0..<_yArray.count {
                let y = _yArray[yIndex]
                let height = _heightArray[yIndex]
                addStrip(x: CGFloat(x),
                         y: CGFloat(y),
                         width: CGFloat(width),
                         height: CGFloat(height),
                         alignment: .center)
            }
        }
        
        for index in 0..<strips.count {
            let rand = randomBucket.nextInt(strips.count)
            strips.swapAt(index, rand)
        }
        
        for strip in strips {
            let plusSize = plusSize(strip: strip)
            clusters
                .append(PairingCluster(strip: strip,
                                       plusWidth: plusSize.width,
                                       plusHeight: plusSize.height))
        }
        
        for node in _selectedWords { node.tempUsed = false }
        for node in _selectedIdeas { node.tempUsed = false }
        for node in _unselectedWords { node.tempUsed = false }
        for node in _unselectedIdeas { node.tempUsed = false }
        
        floodWithSelectedOnly()
        floodWithUnselectedSinglePass()
        floodWithUnselectedSinglePass()
        
        for index in 0..<clusters.count {
            if randomBucket.nextBool() {
                let hold = clusters[index].node1
                clusters[index].node1 = clusters[index].node2
                clusters[index].node2 = hold
            }
        }
        
        layoutAll()
        
        
        for concept in concepts {
            result.add(node: concept.node)
        }
        
        return result
    }
    
    
    func numberOfRows(availableHeight: CGFloat, maxHeight: Int, spacingV: Int) -> Int {
        var result = 1
        var verticalCount = 2
        while verticalCount < 32 {
            let totalSpaceHeight = CGFloat((verticalCount - 1) * spacingV)
            
            let availableHeightForCells = availableHeight - totalSpaceHeight
            let expectedCellHeight = availableHeightForCells / CGFloat(verticalCount)
            
            if expectedCellHeight < CGFloat(maxHeight) {
                break
            } else {
                result = verticalCount
                verticalCount += 1
            }
        }
        return result
    }
    
    func plusSize(strip: ConceptStrip) -> CGSize {
        let maxSize1: CGFloat = ApplicationController.isIpad() ? 64.0 : 42.0
        let maxSize2: CGFloat = strip.width * 0.25
        var dimension = strip.height
        if dimension > maxSize1 { dimension = maxSize1 }
        if dimension > maxSize2 { dimension = maxSize2 }
        return CGSize(width: CGFloat(Int(dimension + 0.5)),
                      height: CGFloat(Int(dimension + 0.5)))
    }
    
    func floodWithSelectedOnly() {
        
        var clustersIndices = [Int]()
        for index in 0..<clusters.count {
            clustersIndices.append(index)
            clustersIndices.append(index)
        }
        
        for index in 0..<clustersIndices.count {
            let rand = randomBucket.nextInt(clustersIndices.count)
            clustersIndices.swapAt(index, rand)
        }
        
        pairingNodes.removeAll(keepingCapacity: true)
        if stripLayoutNodeType == .any || stripLayoutNodeType == .word {
            for node in _selectedWords {
                pairingNodes.append(node)
            }
        }
        
        if stripLayoutNodeType == .any || stripLayoutNodeType == .idea {
            for node in _selectedIdeas {
                pairingNodes.append(node)
            }
        }
        
        for index in 0..<pairingNodes.count {
            let rand = randomBucket.nextInt(pairingNodes.count)
            pairingNodes.swapAt(index, rand)
        }
        
        var index = 0
        let cap = min(pairingNodes.count, clustersIndices.count)
        while index < cap {
            let clusterIndex = clustersIndices[index]
            let node = pairingNodes[index]
            if clusters[clusterIndex].node1 == nil {
                clusters[clusterIndex].node1 = node
                node.tempUsed = true
            } else if clusters[clusterIndex].node2 == nil {
                clusters[clusterIndex].node2 = node
                node.tempUsed = true
            } else {
                print("??? 1.0 Tripped Illegal, for selected, this should not happen ???")
            }
            index += 1
        }
    }
    
    func floodWithUnselectedSinglePass() {
        var clustersIndices = [Int]()
        for index in 0..<clusters.count {
            if clusters[index].node2 == nil {
                clustersIndices.append(index)
            }
        }
        
        for index in 0..<clustersIndices.count {
            let rand = randomBucket.nextInt(clustersIndices.count)
            clustersIndices.swapAt(index, rand)
        }
        
        pairingNodes.removeAll(keepingCapacity: true)
        if stripLayoutNodeType == .any || stripLayoutNodeType == .word {
            for node in _unselectedWords where !(node.tempUsed) {
                pairingNodes.append(node)
            }
        }
        
        if stripLayoutNodeType == .any || stripLayoutNodeType == .idea {
            for node in _unselectedIdeas where !(node.tempUsed) {
                pairingNodes.append(node)
            }
        }
        
        for index in 0..<pairingNodes.count {
            let rand = randomBucket.nextInt(pairingNodes.count)
            pairingNodes.swapAt(index, rand)
        }
        
        var index = 0
        let cap = min(pairingNodes.count, clustersIndices.count)
        while index < cap {
            let clusterIndex = clustersIndices[index]
            let node = pairingNodes[index]
            if clusters[clusterIndex].node1 == nil {
                clusters[clusterIndex].node1 = node
                node.tempUsed = true
            } else if clusters[clusterIndex].node2 == nil {
                clusters[clusterIndex].node2 = node
                node.tempUsed = true
            } else {
                print("??? 2.0 Tripped Illegal, for selected, this should not happen ???")
            }
            index += 1
        }
    }
    
    
    func layoutAll() {
    
        for cluster in clusters {
            
            guard let node1 = cluster.node1 else { continue }
            guard let node2 = cluster.node2 else { continue }
            
            let strip = cluster.strip
            
            let availableWidth = strip.width - (cluster.plusWidth + CGFloat(plusSpacingH + plusSpacingH))
            
            let originalWidth1 = node1.width
            let originalHeight1 = node1.height
            
            let originalWidth2 = node2.width
            let originalHeight2 = node2.height
            
            if originalWidth1 < 32 { continue }
            if originalHeight1 < 32 { continue }
            
            if originalWidth2 < 32 { continue }
            if originalHeight2 < 32 { continue }
            
            if availableWidth < 8 { continue }
            if strip.height < 8 { continue }
            
            
            let ratio1 = originalHeight1 / originalWidth1
            let ratio2 = originalHeight2 / originalWidth2
            
            //print("w1: \(originalWidth1), h1: \(originalHeight1), wr1: \(ratio1)")
            //print("w2: \(originalWidth2), h2: \(originalHeight2), wr2: \(ratio2)")
            
            var factor = ratio2 / (ratio1 + ratio2)
            if factor < 0.4 { factor = 0.4 }
            if factor > 0.6 { factor = 0.6 }
            
            //print("factor1: \(factor)")
            
            let boxWidth1 = availableWidth * factor
            let boxWidth2 = availableWidth * (1.0 - factor)
            
            let size1 = CGSize(width: boxWidth1, height: strip.height)
            let size2 = CGSize(width: boxWidth2, height: strip.height)
            
            let fitFrame1 = size1.getAspectFit(CGSize(width: originalWidth1, height: originalHeight1))
            let fitFrame2 = size2.getAspectFit(CGSize(width: originalWidth2, height: originalHeight2))
            
            
            
            let height1 = fitFrame1.height
            let width1 = fitFrame1.width
            
            let height2 = fitFrame2.height
            let width2 = fitFrame2.width
            
            let widthTotal = width1 + width2 + cluster.plusWidth + CGFloat(plusSpacingH + plusSpacingH)
            
            var x = CGFloat(Int((strip.x + strip.width * 0.5) - (widthTotal * 0.5)))
            
            let y1 = CGFloat(Int((strip.y + strip.height * 0.5) - (height1 * 0.5)))
            let concept1 = ConceptModel(id: baseID,
                                        x: x,
                                        y: y1,
                                        width: width1,
                                        height: height1,
                                        image: node1.image,
                                        node: node1)
            incrementBaseID()
            concepts.append(concept1)
            
            x += width1 + CGFloat(plusSpacingH)
            
            let plusY = CGFloat(Int((strip.y + strip.height * 0.5) - (cluster.plusHeight * 0.5)))
            let plus = PlusSignModel(id: baseID,
                                     x: x,
                                     y: plusY,
                                     width: cluster.plusWidth,
                                     height: cluster.plusHeight)
            incrementBaseID()
            pluses.append(plus)
            
            x += cluster.plusWidth + CGFloat(plusSpacingH)
            let y2 = CGFloat(Int((strip.y + strip.height * 0.5) - (height2 * 0.5)))
            
            let concept2 = ConceptModel(id: baseID,
                                        x: x,
                                        y: y2,
                                        width: width2,
                                        height: height2,
                                        image: node2.image,
                                        node: node2)
            incrementBaseID()
            concepts.append(concept2)
            
            
            
            /*
            let ratio1 = getHeightRatio(node: node1, strip: strip)
            let ratio2 = getHeightRatio(node: node2, strip: strip)
            
            let height1 = strip.height
            let width1 = node1.width * ratio1
            
            let height2 = strip.height
            let width2 = node2.width * ratio2
            
            var x = strip.x
            var y = strip.y
            
            let concept1 = ConceptModel(id: baseID,
                                        x: x,
                                        y: y,
                                        width: width1,
                                        height: height1,
                                        image: node1.image,
                                        node: node1)
            incrementBaseID()
            concepts.append(concept1)
            
            x += width1 + CGFloat(plusSpacingH)
            
            var plusY = CGFloat(Int((strip.y + strip.height * 0.5) - (cluster.plusHeight * 0.5)))
            let plus = PlusSignModel(id: baseID,
                                     x: x,
                                     y: plusY,
                                     width: cluster.plusWidth,
                                     height: cluster.plusHeight)
            incrementBaseID()
            pluses.append(plus)
            
            x += cluster.plusWidth + CGFloat(plusSpacingH)
            
            
            let concept2 = ConceptModel(id: baseID,
                                        x: x,
                                        y: y,
                                        width: width2,
                                        height: height2,
                                        image: node2.image,
                                        node: node2)
            incrementBaseID()
            concepts.append(concept2)
            */
        }
    }
    
}
