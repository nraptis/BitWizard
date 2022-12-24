//
//  GridView.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var gridViewModel: GridViewModel
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        GeometryReader { _ in
            GridViewContent(gridViewModel: gridViewModel,
                            mainContainerViewModel: mainContainerViewModel,
                            concepts: gridViewModel.layout.concepts,
                            rects: gridViewModel.layout.rects)
        }
        .frame(width: width, height: height)
        .background(Color.black)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            GridView(gridViewModel: GridViewModel.preview(),
                     mainContainerViewModel: MainContainerViewModel.preview(),
                     width: geometry.size.width,
                     height: geometry.size.height)
        }
    }
}
