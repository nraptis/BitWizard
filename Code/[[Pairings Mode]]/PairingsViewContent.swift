//
//  PairingsViewContent.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import SwiftUI

struct PairingsViewContent: View {
    @ObservedObject var pairingsViewModel: PairingsViewModel
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let concepts: [ConceptModel]
    let rects: [RectModel]
    var x: [CGFloat]
    var y: [CGFloat]
    var width: [CGFloat]
    var height: [CGFloat]
    var selected: [Bool]
    let conceptsRange: Range<Int>
    let rectsRange: Range<Int>
    
    init(pairingsViewModel: PairingsViewModel, mainContainerViewModel: MainContainerViewModel, concepts: [ConceptModel], rects: [RectModel]) {
        self.pairingsViewModel = pairingsViewModel
        self.mainContainerViewModel = mainContainerViewModel
        self.concepts = concepts
        self.rects = rects
        
        conceptsRange = 0..<concepts.count
        rectsRange = 0..<rects.count
        
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
            .background(RoundedRectangle(cornerRadius: 8.0).fill().foregroundColor(Color(uiColor: _rect.color)))
        }
        .frame(width: _rect.width, height: _rect.height)
        .background(RoundedRectangle(cornerRadius: 8.0).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(Color(uiColor: _rect.color)))
        .offset(x: _rect.x, y: _rect.y)
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
