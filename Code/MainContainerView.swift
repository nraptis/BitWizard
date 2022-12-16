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
            /*
            BottomToolbarView(bottomToolbarViewModel: mainContainerViewModel.app.bottomToolbarViewModel)
            */
        }
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
                switch mainContainerViewModel.appMode {
                case .collage:
                    EmptyView()
                case .centralIdea:
                    if let viewModel = mainContainerViewModel.centralConceptViewModel {
                        centralConceptView(centralConceptViewModel: viewModel, geometry: geometry, mainContentHeight: mainContentHeight)
                    }
                case .pairings:
                    EmptyView()
                }
            }
            .frame(width: geometry.size.width, height: mainContentHeight)
            .background(Color.black)
            
            BottomMenuView(mainContainerViewModel: mainContainerViewModel,
                           width: geometry.size.width,
                           configuration: toolMenuConfiguration)
        }
    }
    
    func centralConceptView(centralConceptViewModel: CentralConceptViewModel, geometry: GeometryProxy, mainContentHeight: CGFloat) -> some View {
        centralConceptViewModel.register(layoutWidth: geometry.size.width, layoutHeight: mainContentHeight)
        return CentralConceptView(centralConceptViewModel: centralConceptViewModel,
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
    
    func bottomMenuHeight(configuration: ToolMenuConfiguration) -> CGFloat {
        topMenuHeight(configuration: configuration)
    }
    
    func mainContentHeight(configuration: ToolMenuConfiguration, geometryHeight: CGFloat) -> CGFloat {
        geometryHeight
        - topMenuHeight(configuration: configuration)
        - bottomMenuHeight(configuration: configuration)
    }
    
}

struct MainContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        return MainContainerView(mainContainerViewModel: mainContainerViewModel)
    }
}
