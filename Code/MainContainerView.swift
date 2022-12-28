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
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        let landscape = geometry.size.width > geometry.size.height
        let toolMenuConfiguration = ApplicationController.toolMenuConfiguration(landscape: landscape)
        
        let mainContentHeight = mainContentHeight(configuration: toolMenuConfiguration, geometryHeight: geometry.size.height)
        let showHideMode = mainContainerViewModel.showHideMode
        
        return VStack(spacing: 0) {
            TopMenuView(mainContainerViewModel: mainContainerViewModel,
                        width: geometry.size.width,
                        configuration: toolMenuConfiguration)
            ZStack {
                switch mainContainerViewModel.appMode {
                case .grid:
                    if let viewModel = mainContainerViewModel.gridViewModel {
                        gridView(gridViewModel: viewModel,
                                 geometry: geometry,
                                 mainContentHeight: mainContentHeight,
                                 showHideMode: showHideMode)
                    }
                case .centralIdea:
                    if let viewModel = mainContainerViewModel.centralConceptViewModel {
                        centralConceptView(centralConceptViewModel: viewModel,
                                           geometry: geometry,
                                           mainContentHeight: mainContentHeight,
                                           showHideMode: showHideMode)
                    }
                case .pairings:
                    if let viewModel = mainContainerViewModel.pairingsViewModel {
                        pairingsView(pairingsViewModel: viewModel,
                                     geometry: geometry,
                                     mainContentHeight: mainContentHeight,
                                     showHideMode: showHideMode)
                    }
                }
            }
            .frame(width: geometry.size.width, height: mainContentHeight)
            .background(Color.black)
            
            BottomMenuView(mainContainerViewModel: mainContainerViewModel,
                           width: geometry.size.width,
                           configuration: toolMenuConfiguration)
        }
    }
    
    func gridView(gridViewModel: GridViewModel,
                  geometry: GeometryProxy,
                  mainContentHeight: CGFloat,
                  showHideMode: ShowHideMode) -> some View {
        if geometry.size.width > geometry.size.height {
            gridViewModel.register(layoutWidth: geometry.size.width,
                                   layoutHeight: mainContentHeight,
                                   gridWidth: mainContainerViewModel.gridWidth + 2,
                                   showHideMode: showHideMode)
        } else {
            gridViewModel.register(layoutWidth: geometry.size.width,
                                   layoutHeight: mainContentHeight,
                                   gridWidth: mainContainerViewModel.gridWidth,
                                   showHideMode: showHideMode)
        }
        return GridView(gridViewModel: gridViewModel,
                        mainContainerViewModel: mainContainerViewModel,
                        width: geometry.size.width,
                        height: mainContentHeight)
    }
    
    func centralConceptView(centralConceptViewModel: CentralConceptViewModel,
                            geometry: GeometryProxy,
                            mainContentHeight: CGFloat,
                            showHideMode: ShowHideMode) -> some View {
        if geometry.size.width > geometry.size.height {
            centralConceptViewModel.register(layoutWidth: geometry.size.width,
                                             layoutHeight: mainContentHeight,
                                             gridWidth: mainContainerViewModel.gridWidth + 2,
                                             showHideMode: showHideMode)
        } else {
            centralConceptViewModel.register(layoutWidth: geometry.size.width,
                                             layoutHeight: mainContentHeight,
                                             gridWidth: mainContainerViewModel.gridWidth,
                                             showHideMode: showHideMode)
        }
        return CentralConceptView(centralConceptViewModel: centralConceptViewModel,
                                  mainContainerViewModel: mainContainerViewModel,
                                  width: geometry.size.width,
                                  height: mainContentHeight)
    }
    
    func pairingsView(pairingsViewModel: PairingsViewModel,
                      geometry: GeometryProxy,
                      mainContentHeight: CGFloat,
                      showHideMode: ShowHideMode) -> some View {
        if geometry.size.width > geometry.size.height {
            pairingsViewModel.register(layoutWidth: geometry.size.width,
                                       layoutHeight: mainContentHeight,
                                       gridWidth: mainContainerViewModel.gridWidth + 2,
                                       showHideMode: showHideMode)
        } else {
            pairingsViewModel.register(layoutWidth: geometry.size.width,
                                       layoutHeight: mainContentHeight,
                                       gridWidth: mainContainerViewModel.gridWidth,
                                       showHideMode: showHideMode)
        }
        return PairingsView(pairingsViewModel: pairingsViewModel,
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
