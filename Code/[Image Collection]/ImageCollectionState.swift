//
//  ImageCollectionState.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

class ImageCollectionState {
    let fetchOffset: Int
    let fileNames: [String]
    init(fetchOffset: Int, nodes: [ImageCollectionNode]) {
        self.fetchOffset = fetchOffset
        self.fileNames = nodes.map { $0.fileName }
    }
}
