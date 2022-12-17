//
//  CentralConceptView.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import SwiftUI

struct CentralConceptView: View {
    @ObservedObject var centralConceptViewModel: CentralConceptViewModel
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        GeometryReader { _ in
            CentralConceptViewContent(centralConceptViewModel: centralConceptViewModel,
                                             mainContainerViewModel: mainContainerViewModel,
                                      
                                      concepts: centralConceptViewModel.layout.concepts,
                                      
                                      rects: centralConceptViewModel.layout.rects
                                        )
        }
        .frame(width: width, height: height)
        .background(Color.black)
    }
    
    /*
    func content() -> some View {
        var selected = [Bool](repeating: false, count: centralConceptViewModel.layout.concepts.count)
        for index in 0..<selected.count {
            let concept = centralConceptViewModel.layout.concepts[index]
            let node = concept.node
            let _selected = mainContainerViewModel.imageBucket.isSelected(node: node)
            selected[index] = _selected
        }
        print("selected = \(selected)")
        
        return CentralConceptViewContent(centralConceptViewModel: centralConceptViewModel,
                                         mainContainerViewModel: mainContainerViewModel,
                                         concepts: centralConceptViewModel.layout.concepts,
                                         selected: selected)
        
    }
    */
    
}

struct CentralConceptView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            CentralConceptView(centralConceptViewModel: CentralConceptViewModel.preview(), mainContainerViewModel: MainContainerViewModel.preview(), width: geometry.size.width, height: geometry.size.height)
        }
    }
}
