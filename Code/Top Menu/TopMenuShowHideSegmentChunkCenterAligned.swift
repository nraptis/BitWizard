//
//  TopMenuShowHideChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/6/22.
//

import SwiftUI

struct TopMenuShowHideSegmentChunkCenterAligned: View {
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
            HStack(spacing: 0) {
                TopMenuShowHideSegment(mainContainerViewModel: mainContainerViewModel,
                                       width: width,
                                       height: height)
            }
            .frame(width: clippedWidth, height: height)
            Spacer()
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
}

struct TopMenuShowHideSegmentChunkCenterAligned_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuShowHideSegmentChunkCenterAligned(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
        }
    }
}
