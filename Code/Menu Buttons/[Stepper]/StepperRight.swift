//
//  StepperRight.swift
//  ToolInterface
//
//  Created by Tri Le on 12/5/22.
//

import SwiftUI

struct StepperRight<ItemView>: View where ItemView: View {
    let width: CGFloat
    let height: CGFloat
    let enabled: Bool
    let action: () -> Void
    @ViewBuilder let content: (() -> ItemView)
    var body: some View {
        VStack {
            ZStack {
                Button {
                    action()
                } label: {
                    ZStack {
                        if enabled {
                            RoundedCorner(radius: 12.0, corners: UIRectCorner.topRight.union(.bottomRight)).foregroundColor(Color("charcoal"))
                        } else {
                            RoundedCorner(radius: 12.0, corners: UIRectCorner.topRight.union(.bottomRight)).foregroundColor(Color("tin"))
                        }
                        content()
                    }
                }
                .disabled(!enabled)
                RoundedCorner(radius: 12.0, corners: UIRectCorner.topRight.union(.bottomRight)).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(Color("limestone"))
            }
        }
        .frame(width: width, height: height)
    }
}

struct StepperRight_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                StepperRight(width: 80, height: ApplicationController.toolbarHeight - 8, enabled: true, action: { }) {
                    Image(systemName: "minus.square.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 4)
                
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
            
            
            HStack {
                Spacer()
                StepperRight(width: 80, height: ApplicationController.toolbarHeight - 8, enabled: false, action: { }) {
                    Image(systemName: "plus.square.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 4)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 1.0), endPoint: UnitPoint(x: 0.5, y: 0.0)))
        }
    }
}
