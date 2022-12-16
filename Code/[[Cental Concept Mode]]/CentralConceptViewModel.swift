//
//  CentralConceptViewModel.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import Foundation

class CentralConceptViewModel: ObservableObject {
    
    static func preview() -> CentralConceptViewModel {
        let mcvm = MainContainerViewModel.preview()
        return CentralConceptViewModel(app: ApplicationController.preview(), imageBucket: mcvm.imageBucket, mainContainerViewModel: mcvm)
    }
    
    deinit {
        print("CentralConceptViewModel.destroy()")
    }
    
    var usedWords = [ImageCollectionNode]()
    var usedIdeas = [ImageCollectionNode]()
    
    let app: ApplicationController
    let imageBucket: ImageBucket
    let mainContainerViewModel: MainContainerViewModel
    lazy var layout: CentralConceptLayout = {
        CentralConceptLayout(imageBucket: mainContainerViewModel.imageBucket)
    }()
    
    
    required init(app: ApplicationController, imageBucket: ImageBucket, mainContainerViewModel: MainContainerViewModel) {
        self.app = app
        self.imageBucket = imageBucket
        self.mainContainerViewModel = mainContainerViewModel
    }
    
    func register(layoutWidth: CGFloat, layoutHeight: CGFloat) {
        
        let diff1 = abs(layoutWidth - layout.layoutWidth)
        let diff2 = abs(layoutHeight - layout.layoutHeight)
        
        guard (diff1 > 0.5) || (diff2 > 0.5) else {
            //print("CentralConceptViewModel (\(layoutWidth) x \(layoutHeight)) SAME (\(layout.layoutWidth) x \(layout.layoutHeight))")
            return
        }
        
        layout.register(layoutWidth: layoutWidth,
                        layoutHeight: layoutHeight)
        
        let buildResponse = layout.build()
        
        usedWords = buildResponse.usedWords
        usedIdeas = buildResponse.usedIdeas
        
        DispatchQueue.main.async {
            self.mainContainerViewModel.objectWillChange.send()
            self.objectWillChange.send()
        }
    }
    
    func build() {
        print("Central Concept => build")
        
        let buildResponse = layout.build()
        
        usedWords = buildResponse.usedWords
        usedIdeas = buildResponse.usedIdeas
        
        DispatchQueue.main.async {
            self.mainContainerViewModel.objectWillChange.send()
            self.objectWillChange.send()
        }
        
    }
    
}
