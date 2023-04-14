//
//  TopMenuViewTwoLine.swift
//  ToolInterface
//
//  Created by Tri Le on 11/30/22.
//

import SwiftUI

struct TopMenuViewTwoLine: View {
    
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                /*
                TopMenuOptionsButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                          width: topLeftHalfWidth(),
                                          height: ApplicationController.toolbarHeight)
                */
                TopMenuUndoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isUndoEnabled())
                
                TopMenuRedoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isRedoEnabled())
                
                TopMenuShuffleChunk(mainContainerViewModel: mainContainerViewModel,
                                    width: topCenterWidth(),
                                    height: ApplicationController.toolbarHeight)
                
                Spacer()
                    .frame(width: ApplicationController.toolbarHeight)
                TopMenuFlipButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: ApplicationController.toolbarHeight,
                                       height: ApplicationController.toolbarHeight)
            }
            .frame(width: width, height: ApplicationController.toolbarHeight)
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
            }
            .frame(width: width, height: ApplicationController.toolbarMiddleSeparatorHeight)
            .background(Color.black)
            
            HStack(spacing: 0) {
                
                TopMenuGridSizeStepperChunk(mainContainerViewModel: mainContainerViewModel,
                                            width: ApplicationController.toolbarHeight + ApplicationController.toolbarHeight,
                                            height: ApplicationController.toolbarHeight)
                
                Spacer()
                
                TopMenuShowButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: ApplicationController.toolbarHeight,
                                       height: ApplicationController.toolbarHeight,
                                       align: 1,
                                       enabled: mainContainerViewModel.isSelectAllEnabled())
                
                TopMenuHideButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: ApplicationController.toolbarHeight,
                                       height: ApplicationController.toolbarHeight,
                                       align: 1,
                                       enabled: mainContainerViewModel.isDeselectAllEnabled())
                
                /*
                TopMenuShowHideSegmentChunkCenterAligned(mainContainerViewModel: mainContainerViewModel, width: topCenterWidth(), height: ApplicationController.toolbarHeight)
                */
                
                /*
                TopMenuHideButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: topRightHalfWidth(),
                                       height: ApplicationController.toolbarHeight,
                                       align: 1,
                                       enabled: mainContainerViewModel.isDeselectAllEnabled())
                */
                
            }
            .frame(width: width, height: ApplicationController.toolbarHeight)
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
            }
            .frame(width: width, height: ApplicationController.toolbarEdgeSeparatorHeight)
            .background(Color.black)
            
        }
        .frame(width: width)
    }
    
    func topLeftHalfWidth() -> CGFloat {
        return ApplicationController.toolbarHeight + ApplicationController.toolbarHeight
    }
    
    func topCenterWidth() -> CGFloat {
        var result = width - topLeftHalfWidth() - topRightHalfWidth()
        if result > 220.0 {
            result = 220.0
        }
        return result
    }
    
    func topRightHalfWidth() -> CGFloat {
        return ApplicationController.toolbarHeight + ApplicationController.toolbarHeight
    }
}

struct TopMenuViewTwoLine_Previews: PreviewProvider {
    static var previews: some View {
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        return VStack {
            GeometryReader { geometry in
                TopMenuViewTwoLine(mainContainerViewModel: mainContainerViewModel,
                                   width: geometry.size.width)
            }
        }
    }
}
