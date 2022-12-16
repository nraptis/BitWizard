//
//  CentralConceptViewContent.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/4/22.
//

import SwiftUI

struct CentralConceptViewContent: View {
    @ObservedObject var centralConceptViewModel: CentralConceptViewModel
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let concepts: [ConceptModel]
    var x: [CGFloat]
    var y: [CGFloat]
    var width: [CGFloat]
    var height: [CGFloat]
    var selected: [Bool]
    let range: Range<Int>
    
    init(centralConceptViewModel: CentralConceptViewModel, mainContainerViewModel: MainContainerViewModel, concepts: [ConceptModel]) {
        self.centralConceptViewModel = centralConceptViewModel
        self.mainContainerViewModel = mainContainerViewModel
        self.concepts = concepts
        
        range = 0..<concepts.count
        
        x = [CGFloat](repeating: 0.0, count: concepts.count)
        y = [CGFloat](repeating: 0.0, count: concepts.count)
        width = [CGFloat](repeating: 0.0, count: concepts.count)
        height = [CGFloat](repeating: 0.0, count: concepts.count)
        selected = [Bool](repeating: false, count: concepts.count)
        
        for index in 0..<concepts.count {
            x[index] = concepts[index].x
            y[index] = concepts[index].y
            width[index] = concepts[index].width
            height[index] = concepts[index].height
            selected[index] = mainContainerViewModel.imageBucket.isSelected(node: concepts[index].node)
        }
    }
    
    var body: some View {
        ForEach(range, id: \.self) { index in
            cell(index: index)
        }
    }
    
    func cell(index: Int) -> some View {
        let _concept = concepts[index]
        let _x = x[index]
        let _y = y[index]
        let _width = width[index]
        let _height = height[index]
        let _selected = selected[index]
        return ConceptCell(mainContainerViewModel: mainContainerViewModel,
                    concept: _concept,
                    selected: _selected,
                    x: _x, y: _y, width: _width, height: _height)
    }
}
