//
//  MainContainer.swift
//  BitWizard
//
//  Created by Nicky Taylor on 11/27/22.
//

import SwiftUI

struct MainContainerView: View {
    
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    
    var body: some View {
        VStack {
            GeometryReader { containerGeometry in
                makeView(geometry: containerGeometry)
            }
        }
        .scaleEffect(CGSize(width: mainContainerViewModel.flippedV ? -1.0 : 1.0, height: mainContainerViewModel.flippedV ? -1.0 : 1.0))
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        let landscape = geometry.size.width > geometry.size.height
        let toolMenuConfiguration = ApplicationController.toolMenuConfiguration(landscape: landscape)
        
        let mainContentHeight = mainContentHeight(configuration: toolMenuConfiguration, geometryHeight: geometry.size.height)
        
        return VStack(spacing: 0) {
            TopMenuView(mainContainerViewModel: mainContainerViewModel,
                        width: geometry.size.width,
                        configuration: toolMenuConfiguration)
            ZStack {
                gridView(gridViewModel: mainContainerViewModel.gridViewModel,
                         geometry: geometry,
                         mainContentHeight: mainContentHeight)
            }
            .frame(width: geometry.size.width - 2, height: mainContentHeight - 2)
        }
    }
    
    func gridView(gridViewModel: GridViewModel,
                  geometry: GeometryProxy,
                  mainContentHeight: CGFloat) -> some View {
        if geometry.size.width > geometry.size.height {
            gridViewModel.register(layoutWidth: geometry.size.width,
                                   layoutHeight: mainContentHeight,
                                   gridWidth: mainContainerViewModel.gridWidth + 2)
        } else {
            gridViewModel.register(layoutWidth: geometry.size.width,
                                   layoutHeight: mainContentHeight,
                                   gridWidth: mainContainerViewModel.gridWidth)
        }
        return GridView(gridViewModel: gridViewModel,
                        mainContainerViewModel: mainContainerViewModel,
                        width: geometry.size.width,
                        height: mainContentHeight)
    }
    
    func topMenuHeight(configuration: ToolMenuConfiguration) -> CGFloat {
        switch configuration {
        case .oneLine:
            return (ApplicationController.toolbarHeight +
            ApplicationController.toolbarEdgeSeparatorHeight)
        case .twoLine:
            return (ApplicationController.toolbarHeight +
            ApplicationController.toolbarMiddleSeparatorHeight +
            ApplicationController.toolbarHeight +
            ApplicationController.toolbarEdgeSeparatorHeight)
        }
    }
    
    func mainContentHeight(configuration: ToolMenuConfiguration, geometryHeight: CGFloat) -> CGFloat {
        geometryHeight - topMenuHeight(configuration: configuration)
    }
}

struct MainContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        return MainContainerView(mainContainerViewModel: mainContainerViewModel)
    }
}
