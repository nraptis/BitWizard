//
//  ConceptCell.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/14/22.
//

import SwiftUI

struct ConceptCell: View {
    
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let concept: ConceptModel
    let selected: Bool
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    init(mainContainerViewModel: MainContainerViewModel,
         concept: ConceptModel,
         selected: Bool,
         x: CGFloat,
         y: CGFloat,
         width: CGFloat,
         height: CGFloat) {
        self.mainContainerViewModel = mainContainerViewModel
        self.concept = concept
        self.selected = selected
        self.x = x + 1.0
        self.y = y + 1.0
        self.width = width - 2.0
        self.height = height - 2.0
    }
    
    var body: some View {
        ZStack {
            Button {
                mainContainerViewModel.toggleSelected(concept: concept)
            } label: {
                ZStack {
                    Image(uiImage: concept.image)
                        .resizable()
                        .frame(width: width - 4.0, height: height - 4.0)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    if selected {
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(style: StrokeStyle(lineWidth: 2.0))
                            .frame(width: width - 3.0, height: height - 3.0)
                            .foregroundColor(Color.black.opacity(0.5))
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(style: StrokeStyle(lineWidth: 2.0))
                            .frame(width: width - 2.0, height: height - 2.0)
                            .foregroundColor(Color("yarn"))
                    } else {
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(style: StrokeStyle(lineWidth: 2.0))
                            .frame(width: width - 3.0, height: height - 3.0)
                            .foregroundColor(Color.black.opacity(0.5))
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(style: StrokeStyle(lineWidth: 2.0))
                            .frame(width: width - 2.0, height: height - 2.0)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: width, height: height)
            }
        }
        .frame(width: width, height: height)
        
        .offset(x: x, y: y)
        .animation(nil, value: false)
    }
    
    //func scale
}

struct ConceptCell_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                ConceptCell(mainContainerViewModel: MainContainerViewModel.preview(), concept: ConceptModel.previewWord(), selected: false, x: 0, y: 0, width: ConceptModel.previewWord().width, height: ConceptModel.previewWord().height)
                ConceptCell(mainContainerViewModel: MainContainerViewModel.preview(), concept: ConceptModel.previewWord(), selected: true, x: 0, y: 0, width: ConceptModel.previewWord().width, height: ConceptModel.previewWord().height)
                Spacer()
            }
            
            HStack {
                Spacer()
                ConceptCell(mainContainerViewModel: MainContainerViewModel.preview(), concept: ConceptModel.previewIdea(), selected: false, x: 0, y: 0, width: ConceptModel.previewIdea().width, height: ConceptModel.previewIdea().height)
                ConceptCell(mainContainerViewModel: MainContainerViewModel.preview(), concept: ConceptModel.previewIdea(), selected: true, x: 0, y: 0, width: ConceptModel.previewIdea().width, height: ConceptModel.previewIdea().height)
                Spacer()
            }
            
            Spacer()
        }
        .background(Color.black)
        
    }
}
