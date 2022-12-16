//
//  BottomMenuView.swift
//  ToolInterface
//
//  Created by Tri Le on 12/4/22.
//

import SwiftUI

struct BottomMenuView: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let configuration: ToolMenuConfiguration
    var body: some View {
        VStack(spacing: 0) {
            switch configuration {
            case .oneLine:
                BottomMenuViewOneLine(mainContainerViewModel: mainContainerViewModel, width: width)
            case .twoLine:
                BottomMenuViewTwoLine(mainContainerViewModel: mainContainerViewModel, width: width)
            }
        }
    }
}

struct BottomMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        return VStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    BottomMenuView(mainContainerViewModel: mainContainerViewModel,
                                   width: geometry.size.width,
                                   configuration: ApplicationController.toolMenuConfiguration(landscape: geometry.size.width > geometry.size.height))
                }
            }
        }
    }
}
