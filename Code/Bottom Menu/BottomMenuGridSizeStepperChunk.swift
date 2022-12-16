//
//  BottomMenuGridSizeStepperChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/5/22.
//

import SwiftUI

struct BottomMenuGridSizeStepperChunk: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let align: Int
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    var body: some View {
        HStack(spacing: 0) {
            
            if align > -1 {
                Spacer()
            }
            
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: paddingLeft)
                    
                    StepperLeft(width: leftHalfWidth(), height: height - (paddingTop + paddingBottom), enabled: mainContainerViewModel.isLeftGridSizeStepperEnabled()) {
                        mainContainerViewModel.clickLeftGridSizeStepper()
                    } content: {
                        if mainContainerViewModel.isLeftGridSizeStepperEnabled() {
                            if ApplicationController.isIpad() {
                                Image(systemName: "minus")
                                    .font(.system(size: 42))
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "minus")
                                    .font(.system(size: 34))
                                    .foregroundColor(.white)
                            }
                        } else {
                            if ApplicationController.isIpad() {
                                Image(systemName: "minus")
                                    .font(.system(size: 42))
                                    .foregroundColor(Color("limestone"))
                            } else {
                                Image(systemName: "minus")
                                    .font(.system(size: 34))
                                    .foregroundColor(Color("limestone"))
                            }
                        }
                    }
                    
                    StepperRight(width: leftHalfWidth(), height: height - (paddingTop + paddingBottom), enabled: mainContainerViewModel.isRightGridSizeStepperEnabled()) {
                        mainContainerViewModel.clickRightGridSizeStepper()
                    } content: {
                        if mainContainerViewModel.isRightGridSizeStepperEnabled() {
                            
                            if ApplicationController.isIpad() {
                                Image(systemName: "plus")
                                    .font(.system(size: 42))
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "plus")
                                    .font(.system(size: 34))
                                    .foregroundColor(.white)
                            }
                        } else {
                            if ApplicationController.isIpad() {
                                Image(systemName: "plus")
                                    .font(.system(size: 42))
                                    .foregroundColor(Color("limestone"))
                            } else {
                                Image(systemName: "plus")
                                    .font(.system(size: 34))
                                    .foregroundColor(Color("limestone"))
                            }
                        }
                    }
                    Spacer()
                        .frame(width: paddingRight)
                }
            }
            .frame(width: clippedWidth, height: height)
            if align < 1 {
                Spacer()
            }
        }
        .frame(width: width, height: height)
    }
    
    func maxWidth() -> CGFloat {
        if ApplicationController.isIpad() {
            return 200.0
        } else {
            return 140.0
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
        return CGFloat(Int(((clippedWidth - (paddingLeft + paddingRight)) * 0.5 + 0.5)))
    }
    
    
    func rightHalfWidth() -> CGFloat {
        return clippedWidth - (leftHalfWidth() + paddingLeft + paddingRight)
    }
}

struct BottomMenuGridSizeStepperChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                BottomMenuGridSizeStepperChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: 260,
                                               height: ApplicationController.toolbarHeight,
                                               align: -1)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                BottomMenuGridSizeStepperChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: 260,
                                               height: ApplicationController.toolbarHeight, align: 0)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                BottomMenuGridSizeStepperChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: 260,
                                               height: ApplicationController.toolbarHeight, align: 1)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        }
    }
}
