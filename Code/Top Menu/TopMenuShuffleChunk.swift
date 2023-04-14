//
//  TopMenuShuffleChunk.swift
//  BitWizard
//
//  Created by Tiger Nixon on 4/14/23.
//

import SwiftUI

struct TopMenuShuffleChunk: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    var body: some View {
        ZStack {
            Button {
                mainContainerViewModel.shuffle()
            } label: {
                ZStack {
                    
                }
                .frame(width: width - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                .background(RoundedRectangle(cornerRadius: 12.0).fill().foregroundColor(Color("yarn")))
            }
            
            ZStack {
                ZStack {
                    
                }
                .frame(width: width - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                .background(RoundedRectangle(cornerRadius: 12.0).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(.white))
                
                
                if ApplicationController.isIpad() {
                    Image(systemName: "shuffle")
                        .font(.system(size: 42))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "shuffle")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
            }
            .allowsHitTesting(false)
        }
        .frame(width: width, height: height)
    }
}

struct TopMenuShuffleChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                TopMenuShuffleChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                       width: ApplicationController.toolbarHeight + ApplicationController.toolbarHeight + ApplicationController.toolbarHeight,
                                       height: ApplicationController.toolbarHeight)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        }
    }
}
