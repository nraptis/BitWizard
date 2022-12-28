//
//  GridLayout.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import UIKit

class GridLayout: ConceptLayout {
    
    required init(imageBucket: ImageBucket) {
        super.init(imageBucket: imageBucket)
        print("GridLayout.init()")
    }
    
    deinit {
        print("GridLayout.deinit()")
    }
    
    func build(gridWidth: Int, showHideMode: ShowHideMode) -> ConceptLayoutBuildResponse {
        
        let result = ConceptLayoutBuildResponse()
        beginFreshBuild(showHideMode: showHideMode)
        let frame = CGRect(x: 0, y: 0, width: layoutWidth, height: layoutHeight)
        placeStripsIn(rect: frame,
                      gridWidth: gridWidth,
                      alignment: .center)
        addConceptsToEachStrip(showHideMode: showHideMode)
        for concept in concepts {
            result.add(node: concept.node)
        }
        return result
    }
}
