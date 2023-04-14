//
//  TopMenuGridSizeStepperChunk.swift
//  BitWizard
//
//  Created by Tiger Nixon on 4/14/23.
//

import SwiftUI

struct TopMenuGridSizeStepperChunk: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    var body: some View {
        HStack(spacing: 0) {
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
            .frame(width: width,
                   height: height)
        }
        .frame(width: width, height: height)
    }
    
    func leftHalfWidth() -> CGFloat {
        return CGFloat(Int(((width - (paddingLeft + paddingRight)) * 0.5 + 0.5)))
    }
    
    func rightHalfWidth() -> CGFloat {
        return width - (leftHalfWidth() + paddingLeft + paddingRight)
    }
}

struct TopMenuGridSizeStepperChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuGridSizeStepperChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                            width: 260,
                                            height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                TopMenuGridSizeStepperChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                            width: 260,
                                            height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                TopMenuGridSizeStepperChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                            width: 260,
                                            height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        }
    }
}
