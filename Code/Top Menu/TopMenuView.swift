//
//  TopToolbarView.swift
//  ToolInterface
//
//  Created by Tri Le on 11/30/22.
//

import SwiftUI

struct TopMenuView: View {
    
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let configuration: ToolMenuConfiguration
    
    var body: some View {
        VStack(spacing: 0) {
            switch configuration {
            case .oneLine:
                TopMenuViewOneLine(mainContainerViewModel: mainContainerViewModel, width: width)
            case .twoLine:
                TopMenuViewTwoLine(mainContainerViewModel: mainContainerViewModel, width: width)
            }
        }
    }
}

struct TopMenuView_Previews: PreviewProvider {
    static var previews: some View {
        
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        
        return VStack {
            GeometryReader { geometry in
                TopMenuView(mainContainerViewModel: mainContainerViewModel,
                            width: geometry.size.width,
                            configuration: ApplicationController.toolMenuConfiguration(landscape: geometry.size.width > geometry.size.height))
            }
        }
    }
}
