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
                
                TopMenuOptionsButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                          width: topLeftHalfWidth(),
                                          height: ApplicationController.toolbarHeight)
                
                TopMenuModeSegmentChunk(mainContainerViewModel: mainContainerViewModel,
                                        width: topCenterWidth(),
                                        height: ApplicationController.toolbarHeight)
                
                TopMenuShowButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: topRightHalfWidth(), height: ApplicationController.toolbarHeight, align: 1)
                
                
            }
            .frame(width: width, height: ApplicationController.toolbarHeight)
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
            }
            .frame(width: width, height: ApplicationController.toolbarMiddleSeparatorHeight)
            .background(Color.black)
            
            HStack(spacing: 0) {
                VStack {
                    
                }
                .frame(width: topLeftHalfWidth(), height: ApplicationController.toolbarHeight)
                
                TopMenuShowHideSegmentChunkCenterAligned(mainContainerViewModel: mainContainerViewModel, width: topCenterWidth(), height: ApplicationController.toolbarHeight)
                
                
                TopMenuHideButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: topRightHalfWidth(), height: ApplicationController.toolbarHeight, align: 1)
                
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
        return CGFloat(Int((width - topCenterWidth()) * 0.5 + 0.5))
    }
    
    func topCenterWidth() -> CGFloat {
        var result = round(width * 0.6)
        
        if result > 210.0 {
            result = 210.0
        }
        return result
    }
    
    func topRightHalfWidth() -> CGFloat {
        return CGFloat(Int(width - (topCenterWidth() + topLeftHalfWidth())))
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
