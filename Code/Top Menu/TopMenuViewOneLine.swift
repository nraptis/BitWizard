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
                    TopMenuOptionsButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                              width: ApplicationController.toolbarHeight,
                                              height: ApplicationController.toolbarHeight)
                    
                    HStack(spacing: 0) {
                        TopMenuShowButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                               width: ApplicationController.toolbarHeight,
                                               height: ApplicationController.toolbarHeight,
                                               align: 0,
                                               enabled: mainContainerViewModel.isSelectAllEnabled())
                        TopMenuHideButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                               width: ApplicationController.toolbarHeight,
                                               height: ApplicationController.toolbarHeight,
                                               align: 0,
                                               enabled: mainContainerViewModel.isDeselectAllEnabled())
                    }
                    .frame(width: leftHalfWidth() - ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight)
                }
                .frame(width: leftHalfWidth(), height: ApplicationController.toolbarHeight)
                
                TopMenuModeSegmentChunk(mainContainerViewModel: mainContainerViewModel, width: centerWidth(), height: ApplicationController.toolbarHeight)
                
                TopMenuShowHideSegmentChunkRightAligned(mainContainerViewModel: mainContainerViewModel, width: rightHalfWidth(), height: ApplicationController.toolbarHeight)
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
        return CGFloat(Int((width - centerWidth()) * 0.5 + 0.5))
    }
    
    func centerWidth() -> CGFloat {
        var result = round(width * 0.4)
        if result > 220.0 {
            result = 220.0
        }
        return result
    }
    
    func rightHalfWidth() -> CGFloat {
        return CGFloat(Int(width - (centerWidth() + leftHalfWidth())))
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
