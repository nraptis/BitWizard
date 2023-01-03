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
    let rects: [RectModel]
    let conceptsRange: Range<Int>
    let rectsRange: Range<Int>
    
    init(centralConceptViewModel: CentralConceptViewModel, mainContainerViewModel: MainContainerViewModel, concepts: [ConceptModel], rects: [RectModel]) {
        self.centralConceptViewModel = centralConceptViewModel
        self.mainContainerViewModel = mainContainerViewModel
        self.concepts = concepts
        self.rects = rects
        conceptsRange = 0..<concepts.count
        rectsRange = 0..<rects.count
    }
    
    //@ViewBuilder
    var body: some View {
        
        ForEach(rectsRange, id: \.self) { index in
            rect(index: index)
        }

        ForEach(conceptsRange, id: \.self) { index in
            cell(index: index)
        }
    }
    
    func rect(index: Int) -> some View {
        let _rect = rects[index]
        return ZStack {
            ZStack {
                
            }
            .frame(width: _rect.width, height: _rect.height)
            .background(RoundedRectangle(cornerRadius: 8.0).fill().foregroundColor(Color.yellow.opacity(0.5)))
        }
        .frame(width: _rect.width, height: _rect.height)
        .background(RoundedRectangle(cornerRadius: 8.0).stroke(style: StrokeStyle(lineWidth: 4)).foregroundColor(Color.red).opacity(0.5))
        .offset(x: _rect.x, y: _rect.y)
    }
    
    func cell(index: Int) -> some View {
        
        let _concept = concepts[index]
        let _x = _concept.x
        let _y = _concept.y
        let _width = _concept.width
        let _height = _concept.height
        let _selected =  mainContainerViewModel.imageBucket.isSelected(node: concepts[index].node)
        return ConceptCell(mainContainerViewModel: mainContainerViewModel,
                           concept: _concept,
                           selected: _selected,
                           x: _x,
                           y: _y,
                           width: _width,
                           height: _height)
    }
}
