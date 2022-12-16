//
//  TopMenuHideButtonChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/8/22.
//

import SwiftUI

struct TopMenuHideButtonChunk: View {
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
            
            ZStack {
                Button {
                    
                } label: {
                    ZStack {
                        
                    }
                    .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                    .background(RoundedRectangle(cornerRadius: 12.0).fill().foregroundColor(Color("charcoal")))
                }
                
                ZStack {
                    
                }
                .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                .background(RoundedRectangle(cornerRadius: 12.0).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(Color("limestone")))

                if ApplicationController.isIpad() {
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                        .font(.system(size: 38))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            .frame(width: height, height: height)
            if align < 1 {
                Spacer()
            }
        }
        .frame(width: width, height: height)
    }
}

struct TopMenuHideButtonChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuHideButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight, align: -1)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
                TopMenuHideButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight, align: 0)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
                TopMenuHideButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight, align: 1)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            
            HStack {
                Spacer()
                TopMenuHideButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight, align: -1)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
                TopMenuHideButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight, align: 0)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
                TopMenuHideButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(), width: 260, height: ApplicationController.toolbarHeight, align: 1)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
        }
    }
}
