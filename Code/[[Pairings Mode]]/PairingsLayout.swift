//
//  PairingsLayout.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import UIKit

class PairingsLayout: ConceptLayout {
    
    required init(imageBucket: ImageBucket) {
        super.init(imageBucket: imageBucket)
        print("PairingsLayout.init()")
    }
    
    deinit {
        print("PairingsLayout.deinit()")
    }
    
    func build(gridWidth: Int) -> ConceptLayoutBuildResponse {
        
        let result = ConceptLayoutBuildResponse()
        
        
        
        beginFreshBuild()
        
        let centerBox = addCenterPiece(gridWidth: gridWidth)
        let centerBoxPadding = 12.0
        let centerBoxExpanded = CGRect(x: centerBox.minX - centerBoxPadding,
                                       y: centerBox.minY - centerBoxPadding,
                                       width: centerBox.width + centerBoxPadding + centerBoxPadding,
                                       height: centerBox.height + centerBoxPadding + centerBoxPadding)
        
        rects.append(RectModel(id: baseID, x: centerBoxExpanded.origin.x, y: centerBoxExpanded.origin.y, width: centerBoxExpanded.size.width, height: centerBoxExpanded.size.height, color: UIColor.blue.withAlphaComponent(0.5)))
        incrementBaseID()
        
        
        let topBox = CGRect(x: 0, y: 0, width: layoutWidth, height: centerBoxExpanded.minY)
        
        rects.append(RectModel(id: baseID, x: topBox.minX,
                               y: topBox.minY,
                               width: topBox.width,
                               height: topBox.height,
                               color: UIColor.orange.withAlphaComponent(0.5)))
        incrementBaseID()
        
        let bottomBox = CGRect(x: 0, y: centerBoxExpanded.maxY, width: layoutWidth, height: layoutHeight - centerBoxExpanded.maxY)
        
        rects.append(RectModel(id: baseID, x: bottomBox.minX,
                               y: bottomBox.minY,
                               width: bottomBox.width,
                               height: bottomBox.height,
                               color: UIColor.cyan.withAlphaComponent(0.5)))
        incrementBaseID()
        
        let stripsResultTop = placeStripsIn(rect: topBox, gridWidth: gridWidth)
        let stripsResultBottom = placeStripsIn(rect: bottomBox, gridWidth: gridWidth)
        
        let topBoxUsed = stripsResultTop.rect
        let bottomBoxUsed = stripsResultBottom.rect
        
        let topBottomRight = min(topBoxUsed.maxX, bottomBoxUsed.maxX)
        let topBottomLeft = max(topBoxUsed.minX, bottomBoxUsed.minX)
        
        let leftBox = CGRect(x: topBoxUsed.minX,
                             y: centerBoxExpanded.minY,
                             width: (centerBoxExpanded.minX - topBottomLeft),
                             height: centerBoxExpanded.height)
        
        rects.append(RectModel(id: baseID, x: leftBox.minX,
                               y: leftBox.minY,
                               width: leftBox.width,
                               height: leftBox.height,
                               color: UIColor.purple.withAlphaComponent(0.5)))
        incrementBaseID()
        
        
        let rightBox = CGRect(x: centerBoxExpanded.maxX,
                              y: centerBoxExpanded.minY,
                              width: (topBottomRight - centerBoxExpanded.maxX),
                              height: centerBoxExpanded.height)
        
        rects.append(RectModel(id: baseID, x: rightBox.minX,
                               y: rightBox.minY,
                               width: rightBox.width,
                               height: rightBox.height,
                               color: UIColor.white.withAlphaComponent(0.5)))
        incrementBaseID()
        
        
        let smallSize = Int(CGFloat(findLargestAppropriateColumnWidthFor(gridWidth: gridWidth)) * 0.25)
        if (leftBox.width > CGFloat(smallSize)) || (rightBox.width > CGFloat(smallSize)) {
            let sideWidth = min(leftBox.width, rightBox.width)
            let placedColumnWidth = max(stripsResultTop.stripWidth(), stripsResultBottom.stripWidth())
            
            var placementCount = 1
            var bestDiff = abs(sideWidth - placedColumnWidth)
            for checkPlacementCount in 2..<10 {
                let expectedWidth = leftBox.width / CGFloat(checkPlacementCount)
                let diff = abs(expectedWidth - placedColumnWidth)
                if diff < bestDiff {
                    bestDiff = diff
                    placementCount = checkPlacementCount
                }
            }
            
            placeStripsIn(rect: leftBox, gridWidth: placementCount)
            placeStripsIn(rect: rightBox, gridWidth: placementCount)
            
        }
        
        addConceptsToEachStrip()
        
        for concept in concepts {
            result.add(node: concept.node)
        }
        
        return result
    }
    
    private func addCenterPiece(gridWidth: Int) -> CGRect {
        
        var fitBox = CGRect(x: centerX - 60.0, y: centerY - 60.0, width: 120.0, height: 120.0)
        
        var _picked: ImageCollectionNode?
        if let idea = dequeueIdea() {
            _picked = idea
        } else {
            if let word = dequeueWord() {
                _picked = word
            }
        }
        guard let node = _picked else {
            return fitBox
        }
        
        let frame = fitBox
        if gridWidth <= 1 {
            let big = findLargestAppropriateColumnWidthForSizeOne()
        }
        
        let concept = ConceptModel(id: baseID, x: frame.minX, y: frame.minY, width: frame.width, height: frame.height, image: node.image, node: node)
        incrementBaseID()
        concepts.append(concept)
        return fitBox
        
        
        
    }
}
