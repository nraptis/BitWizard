//
//  ConceptStrip.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/19/22.
//

import Foundation

class ConceptStrip {
    
    static let capCutoffHeightFactor = 3.0
    
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    var capCutoffHeight: CGFloat
    
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
        self.capCutoffHeight = height //- (Self.capCutoffHeightFactor * width)
    }
    
    func shouldBeCappedOff() -> Bool {
        if conceptsHeight < capCutoffHeight {
            return false
        } else {
            return true
        }
    }
    
    func canAdd(node: ImageCollectionNode, ratio: CGFloat) -> Bool  {
        let conceptHeight = node.height * ratio
        if conceptsHeight + conceptHeight <= height {
            return true
        } else {
            return false
        }
    }
    
    func add(node: ImageCollectionNode, ratio: CGFloat) {
        var centerY = self.height * 0.5 + self.y
        
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
        print("concepts[\(concepts.count)] height: \(conceptsHeight) (my height: \(height))")
    }
    
    func layoutConceptsFromTopDown(bucket: RandomBucket) {
        
        
        var x: CGFloat = x
        var y: CGFloat = y
        for concept in concepts {
            concept.x = x
            concept.y = y
            y += concept.height
        }
        
    }
    
}



