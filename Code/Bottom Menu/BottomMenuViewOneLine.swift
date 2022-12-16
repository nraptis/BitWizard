//
//  BottomMenuViewOneLine.swift
//  ToolInterface
//
//  Created by Tri Le on 12/4/22.
//

import SwiftUI

struct BottomMenuViewOneLine: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
            }
            .frame(width: width, height: ApplicationController.toolbarEdgeSeparatorHeight)
            .background(Color.white)
            
            HStack(spacing: 0) {
                leftChunk()
                BottomMenuShuffleChunk(mainContainerViewModel: mainContainerViewModel,
                                       width: centerWidth(),
                                       height: ApplicationController.toolbarHeight)
                HStack(spacing: 0) {
                    
                    Spacer()
                    BottomMenuUndoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isUndoEnabled())
                    
                    BottomMenuRedoButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight, enabled: mainContainerViewModel.isRedoEnabled())
                }
                .frame(width: rightHalfWidth(), height: ApplicationController.toolbarHeight)
                
            }
            .frame(width: width, height: ApplicationController.toolbarHeight)
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        }
        .frame(width: width)
    }
    
    func leftChunk() -> some View {
        
        let width = leftHalfWidth()
        
        return HStack(spacing: 0) {
            BottomMenuFlipButtonChunk(mainContainerViewModel: mainContainerViewModel, width: ApplicationController.toolbarHeight, height: ApplicationController.toolbarHeight)
            
            BottomMenuGridSizeStepperChunk(mainContainerViewModel: mainContainerViewModel, width: (width - ApplicationController.toolbarHeight), height: ApplicationController.toolbarHeight, align: 0)
            
        }
        .frame(width: width, height: ApplicationController.toolbarHeight)
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

struct BottomMenuViewOneLine_Previews: PreviewProvider {
    static var previews: some View {
        let app = ApplicationController.preview()
        let mainContainerViewModel = app.mainContainerViewModel
        return VStack {
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    BottomMenuViewOneLine(mainContainerViewModel: mainContainerViewModel,
                                          width: geometry.size.width)
                }
            }
        }
    }
}
