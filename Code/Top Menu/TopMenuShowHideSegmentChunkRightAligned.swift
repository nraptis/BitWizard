//
//  TopMenuShowHideChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/6/22.
//

import SwiftUI

struct TopMenuShowHideSegmentChunkRightAligned: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                TopMenuShowHideSegment(mainContainerViewModel: mainContainerViewModel,
                                       width: width,
                                       height: height)
            }
            .padding(.trailing, paddingRight)
            .frame(width: width, height: height, alignment: Alignment(horizontal: .trailing, vertical: .center))
        }
        .frame(width: width, height: height)
    }
    
    func maxWidth() -> CGFloat {
        if ApplicationController.isIpad() {
            return 300.0
        } else {
            return 210.0
        }
    }
    
    private var clippedWidth: CGFloat {
        if width <= maxWidth() {
            return width
        } else {
            return maxWidth()
        }
    }
    
    func leftHalfWidth() -> CGFloat {
        return CGFloat(Int(((clippedWidth - (paddingLeft + paddingRight)) * 0.33333333 + 0.5)))
    }
    
    func centerWidth() -> CGFloat {
        return clippedWidth - (leftHalfWidth() + rightHalfWidth() + paddingLeft + paddingRight)
    }
    
    func rightHalfWidth() -> CGFloat {
        return CGFloat(Int(((clippedWidth - (paddingLeft + paddingRight)) * 0.33333333 + 0.5)))
    }
}

struct TopMenuShowHideSegmentChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuShowHideSegmentChunkRightAligned(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
        }
    }
}
