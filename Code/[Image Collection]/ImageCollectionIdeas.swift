//
//  ImageCollectionIdeas.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/4/22.
//

import Foundation

class ImageCollectionIdeas: ImageCollection {
    init(app: ApplicationController, cache: ImageCache) {
        super.init(app: app, cache: cache, idOffset: 1_000_000_000)
        setUp(imageNames: Self.imageNames(), type: .idea)
    }
    
    
    
}
