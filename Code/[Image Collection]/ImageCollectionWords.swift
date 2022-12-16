//
//  ImageCollectionWords.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import Foundation

class ImageCollectionWords: ImageCollection {
    
    init(app: ApplicationController, cache: ImageCache) {
        super.init(app: app, cache: cache, idOffset: 2_000_000_000)
        setUp(imageNames: Self.imageNames(), type: .word)
    }
    
}
