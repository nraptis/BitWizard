//
//  ImageBucketSelectionState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

class ImageBucketSelectionState {
    
    let selectedBagContents: [String]
    let recentlySelectedBagContents: [String]
    
    init(selectedBag: Set<ImageCollectionNode>,
         recentlySelectedBag: Set<ImageCollectionNode>
    ) {
        var _selectedBagContents = [String]()
        for node in selectedBag {
            _selectedBagContents.append(node.fileName)
        }
        self.selectedBagContents = _selectedBagContents
        
        var _recentlySelectedBagContents = [String]()
        for node in recentlySelectedBag {
            _recentlySelectedBagContents.append(node.fileName)
        }
        self.recentlySelectedBagContents = _recentlySelectedBagContents
    }
}
