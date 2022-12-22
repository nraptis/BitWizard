//
//  ConceptStrip.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/19/22.
//

import Foundation

class ConceptStrip {
    
    //Idea: Cutoff Factor Lo, Cutoff Factor Hi
    // Can only try to add when < Lo,
    // But if goes > Hi, cannot add
    // This will guarantee some wiggle room
    static let capCutoffHeightFactorMin = 1.0
    static let capCutoffHeightFactorMax = 1.0
    
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    var capCutoffHeightMin: CGFloat
    var capCutoffHeightMax: CGFloat
    
    
    var concepts = [ConceptModel]()
    var conceptsHeight: CGFloat = 0.0
    
    init(x: CGFloat,
         y: CGFloat,
         width: CGFloat,
         height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
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
    
    func layoutConceptsFromTopDown(bucket: RandomBucket) {
        let x: CGFloat = x
        var y: CGFloat = y
        for concept in concepts {
            concept.x = x
            concept.y = y
            y += concept.height
        }
        
    }
    
}



