//
//  TopMenuModeSegmentChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/2/22.
//

import SwiftUI

struct TopMenuModeSegmentChunk: View {
    
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: paddingLeft)
            SegmentLeft(width: leftHalfWidth(), height: height - (paddingTop + paddingBottom), selected: mainContainerViewModel.isLeftModeSegmentSelected()) {
                mainContainerViewModel.selectLeftModeSegment()
            } content: {
                if ApplicationController.isIpad() {
                    Image(systemName: "square.grid.3x3")
                        .font(.system(size: 42))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "square.grid.3x3")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
            }
            
            SegmentMiddle(width: leftHalfWidth(), height: height - (paddingTop + paddingBottom), selected: mainContainerViewModel.isMiddleModeSegmentSelected()) {
                mainContainerViewModel.selectMiddleModeSegment()
            } content: {
                if ApplicationController.isIpad() {
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.system(size: 42))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
            }
            
            SegmentRight(width: leftHalfWidth(), height: height - (paddingTop + paddingBottom), selected: mainContainerViewModel.isRightModeSegmentSelected()) {
                mainContainerViewModel.selectRightModeSegment()
            } content: {
                if ApplicationController.isIpad() {
                    Image(systemName: "rectangle.split.2x1.fill")
                        .font(.system(size: 42))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "rectangle.split.2x1.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
            }
            Spacer()
                .frame(width: paddingRight)
        }
        .frame(width: width, height: height)
    }
    
    func leftHalfWidth() -> CGFloat {
        return CGFloat(Int(((width - (paddingLeft + paddingRight)) * 0.33333333 + 0.5)))
    }
    
    func centerWidth() -> CGFloat {
        return width - (leftHalfWidth() + rightHalfWidth() + paddingLeft + paddingRight)
    }
    
    func rightHalfWidth() -> CGFloat {
        return CGFloat(Int(((width - (paddingLeft + paddingRight)) * 0.33333333 + 0.5)))
    }
    
}

struct TopMenuModeSegmentChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuModeSegmentChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                        width: 200,
                                        height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
        }
        
        
    }
}
