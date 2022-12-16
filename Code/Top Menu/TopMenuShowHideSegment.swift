//
//  TopMenuShowHideSegment.swift
//  ToolInterface
//
//  Created by Tri Le on 12/9/22.
//

import SwiftUI

struct TopMenuShowHideSegment: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    var body: some View {
        HStack(spacing: 0) {
            SegmentSecondaryLeft(width: leftHalfWidth(), height: height - (paddingTop + paddingBottom), selected: mainContainerViewModel.isLeftShowHideSegmentSelected()) {
                mainContainerViewModel.selectLeftShowHideSegment()
            } content: {
                
                
                if ApplicationController.isIpad() {
                    Image(systemName: "eye")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "eye")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                
                
            }
            
            SegmentSecondaryMiddle(width: centerWidth(), height: height - (paddingTop + paddingBottom), selected: mainContainerViewModel.isMiddleShowHideSegmentSelected()) {
                mainContainerViewModel.selectMiddleShowHideSegment()
            } content: {
                
                if ApplicationController.isIpad() {
                    Image(systemName: "eye.trianglebadge.exclamationmark")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "eye.trianglebadge.exclamationmark")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                
            }
            
            SegmentSecondaryRight(width: leftHalfWidth(), height: height - (paddingTop + paddingBottom), selected: mainContainerViewModel.isRightShowHideSegmentSelected()) {
                mainContainerViewModel.selectRightShowHideSegment()
            } content: {

                if ApplicationController.isIpad() {
                    Image(systemName: "eye.slash")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "eye.slash")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                
                    
            }
        }
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

struct TopMenuShowHideSegment_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuShowHideSegment(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
        }
    }
}
