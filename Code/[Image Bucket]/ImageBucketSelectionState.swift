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
    let recentlyDeselectedBagContents: [String]
    
    
    init(selectedBag: Set<ImageCollectionNode>,
         recentlySelectedBag: Set<ImageCollectionNode>,
         recentlyDeselectedBag: Set<ImageCollectionNode>
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
        
        var _recentlyDeselectedBagContents = [String]()
        for node in recentlyDeselectedBag {
            _recentlyDeselectedBagContents.append(node.fileName)
        }
        self.recentlyDeselectedBagContents = _recentlyDeselectedBagContents
    }
}
