//
//  PairingsView.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/24/22.
//

import SwiftUI

struct PairingsView: View {
    @ObservedObject var pairingsViewModel: PairingsViewModel
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        GeometryReader { _ in
            PairingsViewContent(pairingsViewModel: pairingsViewModel,
                                mainContainerViewModel: mainContainerViewModel,
                                concepts: pairingsViewModel.layout.concepts,
                                rects: pairingsViewModel.layout.rects)
        }
        .frame(width: width, height: height)
        .background(Color.black)
    }
}

struct PairingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PairingsView(pairingsViewModel: PairingsViewModel.preview(),
                         mainContainerViewModel: MainContainerViewModel.preview(),
                         width: geometry.size.width,
                         height: geometry.size.height)
        }
    }
}
