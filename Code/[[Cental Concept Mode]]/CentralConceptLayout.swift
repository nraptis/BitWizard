//
//  CentralConceptLayout.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import UIKit

class CentralConceptLayout: ConceptLayout {
    
    required init(imageBucket: ImageBucket) {
        super.init(imageBucket: imageBucket)
    }
    
    deinit {
        
    }
    
    func build(gridWidth: Int, showHideMode: ShowHideMode) -> ConceptLayoutBuildResponse {
        
        let result = ConceptLayoutBuildResponse()
        
        beginFreshBuild(showHideMode: showHideMode)
        
        let centerBox = addCenterPiece(gridWidth: gridWidth)
        let centerBoxPadding = ApplicationController.isIpad() ? 5.0 : 3.0
        let centerBoxExpanded = CGRect(x: centerBox.minX - centerBoxPadding,
                                       y: centerBox.minY - centerBoxPadding,
                                       width: centerBox.width + centerBoxPadding + centerBoxPadding,
                                       height: centerBox.height + centerBoxPadding + centerBoxPadding)
        let topBox = CGRect(x: 0,
                            y: 0,
                            width: layoutWidth,
                            height: centerBoxExpanded.minY)
        let bottomBox = CGRect(x: 0,
                               y: centerBoxExpanded.maxY,
                               width: layoutWidth,
                               height: layoutHeight - centerBoxExpanded.maxY)
        
        let stripsResultTop = placeStripsIn(rect: topBox,
                                            gridWidth: gridWidth,
                                            alignment: .bottom)
        let stripsResultBottom = placeStripsIn(rect: bottomBox,
                                               gridWidth: gridWidth,
                                               alignment: .top)
        
        let topBoxUsed = stripsResultTop.rect
        let bottomBoxUsed = stripsResultBottom.rect
        
        let topBottomRight = min(topBoxUsed.maxX, bottomBoxUsed.maxX)
        let topBottomLeft = max(topBoxUsed.minX, bottomBoxUsed.minX)
        
        let leftBox = CGRect(x: topBoxUsed.minX,
                             y: centerBoxExpanded.minY,
                             width: (centerBoxExpanded.minX - topBottomLeft),
                             height: centerBoxExpanded.height)
        let rightBox = CGRect(x: centerBoxExpanded.maxX,
                              y: centerBoxExpanded.minY,
                              width: (topBottomRight - centerBoxExpanded.maxX),
                              height: centerBoxExpanded.height)
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
            placeStripsIn(rect: leftBox,
                          gridWidth: placementCount,
                          alignment: .center)
            placeStripsIn(rect: rightBox,
                          gridWidth: placementCount,
                          alignment: .center)
        }
        
        addConceptsToEachStrip()
        
        for concept in concepts {
            result.add(node: concept.node)
        }
        
        return result
    }
    
    private func addCenterPiece(gridWidth: Int) -> CGRect {
        
        let fitBox = CGRect(x: centerX - 60.0, y: centerY - 60.0, width: 120.0, height: 120.0)
        
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
        
        var sizeH = findLargestAppropriateColumnWidthFor(gridWidth: gridWidth)
        if ApplicationController.isIpad() {
            sizeH += 6
        } else {
            sizeH += 4
        }
        
        var sizeV = sizeH
        let maxSizeV = Int(layoutHeight * 0.333 + 0.5)
        if sizeV > maxSizeV {
            sizeV = maxSizeV
        }
        
        let fitSize = CGSize(width: CGFloat(sizeH),
                             height: CGFloat(sizeV))
        let nodeSize = CGSize(width: node.width,
                              height: node.height)
        
        let size = fitSize.getAspectFit(nodeSize)
        let frame = CGRect(x: round(layoutWidth * 0.5 - size.width * 0.5),
                        
                           y: round(layoutHeight * 0.5 - size.height * 0.5),
                           width: round(CGFloat(size.width)),
                           height: round(CGFloat(size.height)))
        
        let concept = ConceptModel(id: baseID, x: frame.minX, y: frame.minY, width: frame.width, height: frame.height, image: node.image, node: node)
        incrementBaseID()
        concepts.append(concept)
        return frame
    }
}
