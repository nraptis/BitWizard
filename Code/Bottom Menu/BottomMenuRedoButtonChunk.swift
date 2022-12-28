//
//  BottomMenuRedoButtonChunk.swift
//  ToolInterface
//
//  Created by Tri Le on 12/8/22.
//

import SwiftUI

struct BottomMenuRedoButtonChunk: View {
    @ObservedObject var mainContainerViewModel: MainContainerViewModel
    let width: CGFloat
    let height: CGFloat
    let enabled: Bool
    let paddingLeft: CGFloat = 4.0
    let paddingRight: CGFloat = 4.0
    let paddingTop: CGFloat = 4.0
    let paddingBottom: CGFloat = 4.0
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ZStack {
                    Button {
                        mainContainerViewModel.redoIntent()
                    } label: {
                        
                        if enabled {
                            ZStack {
                                
                            }
                            .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                            .background(RoundedRectangle(cornerRadius: 12.0).fill().foregroundColor(Color("charcoal")))
                        } else {
                            ZStack {
                                
                            }
                            .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                            .background(RoundedRectangle(cornerRadius: 12.0).fill().foregroundColor(Color("tin")))
                        }
                    }
                    .disabled(!enabled)
                    
                    ZStack {
                        if enabled {
                            if ApplicationController.isIpad() {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 42))
                                    .foregroundColor(.white)
                                
                            } else {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 34))
                                    .foregroundColor(.white)
                            }
                        } else {
                            if ApplicationController.isIpad() {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 42))
                                    .foregroundColor(Color("limestone"))
                                
                            } else {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 34))
                                    .foregroundColor(Color("limestone"))
                                
                            }
                        }
                    }
                    .allowsHitTesting(false)
                    
                     ZStack {
                     
                     }
                     .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
                     .background(RoundedRectangle(cornerRadius: 12.0).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(Color("limestone")))
                     .allowsHitTesting(false)
                    
                }
                .frame(width: height - (paddingLeft + paddingRight), height: height - (paddingTop + paddingBottom))
            }
            .padding(.trailing, paddingRight)
        }
        .frame(width: width, height: height, alignment: Alignment(horizontal: .trailing, vertical: .center))
    }
}

struct BottomMenuRedoButtonChunk_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                BottomMenuRedoButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: 260,
                                          height: ApplicationController.toolbarHeight, enabled: true)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                BottomMenuRedoButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: 260,
                                               height: ApplicationController.toolbarHeight, enabled: false)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                BottomMenuRedoButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: 260,
                                               height: ApplicationController.toolbarHeight, enabled: true)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                BottomMenuRedoButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: ApplicationController.toolbarHeight,
                                          height: ApplicationController.toolbarHeight, enabled: false)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                BottomMenuRedoButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: ApplicationController.toolbarHeight,
                                               height: ApplicationController.toolbarHeight, enabled: false)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            HStack {
                Spacer()
                BottomMenuRedoButtonChunk(mainContainerViewModel: MainContainerViewModel.preview(),
                                               width: ApplicationController.toolbarHeight,
                                               height: ApplicationController.toolbarHeight, enabled: true)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_light_1"), Color("toolbar_light_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        
        }
    }
}
