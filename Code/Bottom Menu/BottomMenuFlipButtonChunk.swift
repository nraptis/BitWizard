//
//  BottomMenuFlipButtonChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/5/22.
//

import SwiftUI

struct BottomMenuFlipButtonChunk: View {
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
                Button {
                    mainContainerViewModel.flipVIntent()
                } label: {
                    ZStack {
                        
                    }
                    .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                    .background(RoundedRectangle(cornerRadius: 12.0).fill().foregroundColor(Color("charcoal")))
                }
                
                ZStack {
                    ZStack {
                        
                    }
                    .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                    .background(RoundedRectangle(cornerRadius: 12.0).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(Color("limestone")))
                    
                    
                    if ApplicationController.isIpad() {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 38))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                }
                .allowsHitTesting(false)
            }
            .frame(width: height, height: height)
            Spacer()
                .frame(width: width - height)
        }
        .frame(width: width, height: height)
    }
}

struct BottomMenuFlipButtonChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                BottomMenuFlipButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                          width: ApplicationController.toolbarHeight + 40,
                                          height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        }
    }
}
