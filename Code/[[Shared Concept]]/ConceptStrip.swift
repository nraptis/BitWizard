//
//  ConceptStrip.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/19/22.
//

import Foundation

enum ConceptStripAlignment {
    case top
    case center
    case bottom
}

class ConceptStrip {
    
    //Idea: Cutoff Factor Lo, Cutoff Factor Hi
    // Can only try to add when < Lo,
    // But if goes > Hi, cannot add
    // This will guarantee some wiggle room
    static let capCutoffHeightFactorMin = 0.0
    static let capCutoffHeightFactorMax = 0.65
    
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let alignment: ConceptStripAlignment
    var capCutoffHeightMin: CGFloat
    var capCutoffHeightMax: CGFloat
    
    var concepts = [ConceptModel]()
    var conceptsHeight: CGFloat = 0.0
    
    init(x: CGFloat,
         y: CGFloat,
         width: CGFloat,
         height: CGFloat,
         alignment: ConceptStripAlignment) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.alignment = alignment
        self.capCutoffHeightMin = height - (Self.capCutoffHeightFactorMin * width)
        self.capCutoffHeightMax = height - (Self.capCutoffHeightFactorMax * width)
    }
    
    func shouldBeCappedOff() -> Bool {
        if conceptsHeight < capCutoffHeightMin {
            return false
        } else {
            return true
        }
    }
    
    func canAddWithoutCapping(node: ImageCollectionNode, ratio: CGFloat) -> Bool  {
        let conceptHeight = node.height * ratio
        if conceptsHeight + conceptHeight <= capCutoffHeightMax {
            return true
        } else {
            return false
        }
    }
    
    /*
    func canAdd(node: ImageCollectionNode, ratio: CGFloat) -> Bool  {
        let conceptHeight = node.height * ratio
        if conceptsHeight + conceptHeight <= height {
            return true
        } else {
            return false
        }
    }
    */
    
    func add(node: ImageCollectionNode, ratio: CGFloat) {
        let centerY = self.height * 0.5 + self.y
        
        let conceptWidth = width
        let conceptHeight = node.height * ratio
        
        let conceptX = x
        let conceptY = centerY - conceptHeight * 0.5
        
        let concept = ConceptModel(id: 0,
                                   x: conceptX,
                                   y: conceptY,
                                   width: conceptWidth,
                                   height: conceptHeight,
                                   image: node.image,
                                   node: node)
        
        add(concept: concept)
    }
    
    
    
    func add(concept: ConceptModel) {
        concepts.append(concept)
        conceptsHeight += concept.height
    }
    
    func layoutConcepts(bucket: RandomBucket) {
        var totalHeight: CGFloat = 0.0
        for concept in concepts {
            totalHeight += concept.height
        }
        
        for _ in 0..<4 where totalHeight < height {
            for concept in concepts where totalHeight < height {
                concept.height += 1.0
                totalHeight += 1.0
            }
        }
        
        var conceptsShuffled = [ConceptModel]()
        conceptsShuffled.append(contentsOf: concepts)
        for index in 0..<conceptsShuffled.count {
            let rand = bucket.nextInt(conceptsShuffled.count)
            conceptsShuffled.swapAt(index, rand)
        }
        
        let _x: CGFloat = x
        var _y: CGFloat = y
        
        switch alignment {
        case .center:
            _y = CGFloat(Int((y + height * 0.5) - (totalHeight * 0.5) + 0.5))
        case .bottom:
            _y = height - CGFloat(totalHeight)
        default:
            break
        }
        
        for concept in conceptsShuffled {
            concept.x = _x
            concept.y = _y
            _y += concept.height
        }
    }
}



