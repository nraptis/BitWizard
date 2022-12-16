//
//  BottomMenuViewTwoLine.swift
//  ToolInterface
//
//  Created by Tri Le on 12/4/22.
//

import SwiftUI

struct BottomMenuViewTwoLine: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
            }
            .frame(width: width, height: ApplicationController.toolbarEdgeSeparatorHeight)
            .background(Color.black)
            
            HStack(spacing: 0) {
                BottomMenuGridSizeStepperChunk(mainContainerViewModel: mainContainerViewModel, width: topLeftHalfWidth(), height: ApplicationController.toolbarHeight, align: -1)
                HStack(spacing: 0) {
                    
                    Spacer()
                    BottomMenuUndoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isUndoEnabled())
                    
                    BottomMenuRedoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isRedoEnabled())
                }
                .frame(width: topRightHalfWidth(), height: ApplicationController.toolbarHeight)
                
            }
            .frame(width: width, height: ApplicationController.toolbarHeight)
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
            }
            .frame(width: width, height: ApplicationController.toolbarMiddleSeparatorHeight)
            .background(Color.black)
            
            HStack(spacing: 0) {
                
                
                BottomMenuFlipButtonChunk(mainContainerViewModel: mainContainerViewModel,
                                          width: bottomLeftHalfWidth(),
                                          height: ApplicationController.toolbarHeight)
                
                BottomMenuShuffleChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: bottomCenterWidth(),
                                       height: ApplicationController.toolbarHeight)
                
                HStack {
                    
                    
                }
                .frame(width: bottomRightHalfWidth(), height: ApplicationController.toolbarHeight)
                
            }
            .frame(width: width, height: ApplicationController.toolbarHeight)
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        }
        .frame(width: width)
    }
    
    func bottomLeftHalfWidth() -> CGFloat {
        return CGFloat(Int((width - bottomCenterWidth()) * 0.5 + 0.5))
    }
    
    func bottomCenterWidth() -> CGFloat {
        var result = round(width * 0.6)
        if result > 220.0 {
            result = 220.0
        }
        return result
    }
    
    func bottomRightHalfWidth() -> CGFloat {
        return CGFloat(Int(width - (bottomCenterWidth() + bottomLeftHalfWidth())))
    }
    
    
    
    func topLeftHalfWidth() -> CGFloat {
        return CGFloat(Int((width) * 0.5 + 0.5))
    }
    
    func topRightHalfWidth() -> CGFloat {
        return CGFloat(Int(width - (topLeftHalfWidth())))
    }
}

struct BottomMenuViewTwoLine_Previews: PreviewProvider {
    static var previews: some View {
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        return VStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    BottomMenuViewTwoLine(mainContainerViewModel: mainContainerViewModel,
                                          width: geometry.size.width)
                }
            }
        }
    }
}
