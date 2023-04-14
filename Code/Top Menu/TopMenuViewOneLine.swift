//
//  TopMenuViewOneLine.swift
//  ToolInterface
//
//  Created by Tri Le on 11/30/22.
//

import SwiftUI

struct TopMenuViewOneLine: View {
    
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    TopMenuUndoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isUndoEnabled())
                    
                    TopMenuRedoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isRedoEnabled())
                    
                    HStack(spacing: 0) {
                        Spacer()
                        TopMenuGridSizeStepperChunk(mainContainerViewModel: mainContainerViewModel,
                                                    width: ApplicationController.toolbarHeight + ApplicationController.toolbarHeight,
                                                    height: ApplicationController.toolbarHeight)
                        Spacer()
                    }
                }
                .frame(height: ApplicationController.toolbarHeight)
                
                TopMenuShuffleChunk(mainContainerViewModel: mainContainerViewModel,
                                    width: centerWidth(),
                                    height: ApplicationController.toolbarHeight)
                
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
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
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(width: ApplicationController.toolbarHeight)
                    TopMenuFlipButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                           width: ApplicationController.toolbarHeight,
                                           height: ApplicationController.toolbarHeight)
                }
                .frame(height: ApplicationController.toolbarHeight)
            }
            .frame(width: width, height: ApplicationController.toolbarHeight)
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            HStack {
                Spacer()
            }
            .frame(width: width, height: ApplicationController.toolbarEdgeSeparatorHeight)
            .background(Color.white)
        }
        .frame(width: width)
    }
    
    func leftHalfWidth() -> CGFloat {
        return ApplicationController.toolbarHeight +
        ApplicationController.toolbarHeight +
        ApplicationController.toolbarHeight +
        ApplicationController.toolbarHeight
    }
    
    func centerWidth() -> CGFloat {
        var result = width - leftHalfWidth() - rightHalfWidth()
        if result > 220.0 {
            result = 220.0
        }
        return result
    }
    
    func rightHalfWidth() -> CGFloat {
        return ApplicationController.toolbarHeight +
        ApplicationController.toolbarHeight +
        ApplicationController.toolbarHeight +
        ApplicationController.toolbarHeight
    }
}

struct TopMenuViewOneLine_Previews: PreviewProvider {
    static var previews: some View {
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        
        return VStack {
            GeometryReader { geometry in
                TopMenuViewOneLine(mainContainerViewModel: mainContainerViewModel,
                                   width: geometry.size.width)
            }
        }
    }
}
