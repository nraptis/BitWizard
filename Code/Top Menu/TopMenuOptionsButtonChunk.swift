//
//  TopMenuOptionsButtonChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/3/22.
//

import SwiftUI

struct TopMenuOptionsButtonChunk: View {
    
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ZStack {
                    Button {
                        
                    } label: {
                        ZStack {
                            
                        }
                        .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                        .background(RoundedRectangle(cornerRadius: 12.0).fill().foregroundColor(Color("yarn")))
                    }
                    
                    if ApplicationController.isIpad() {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 42))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 34))
                            .foregroundColor(.white)
                    }
                    
                     ZStack {
                     
                     }
                     .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                     .background(RoundedRectangle(cornerRadius: 12.0).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(.white))
                }
                .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
            }
            .padding(.leading, paddingLeft)
        }
        .frame(width: width, height: height, alignment: Alignment(horizontal: .leading, vertical: .center))
    }
}

struct TopMenuOptionsButtonChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuOptionsButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                          width: ApplicationController.toolbarHeight,
                                          height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            HStack {
                Spacer()
                TopMenuOptionsButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                          width: ApplicationController.toolbarHeight + ApplicationController.toolbarHeight,
                                          height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
        }
    }
}
