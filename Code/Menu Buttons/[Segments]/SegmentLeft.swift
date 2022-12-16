//
//  SegmentLeft.swift
//  ToolInterface
//
//  Created by Tri Le on 12/2/22.
//

import SwiftUI

struct SegmentLeft<ItemView>: View where ItemView: View {
    let width: CGFloat
    let height: CGFloat
    let selected: Bool
    let action: () -> Void
    @ViewBuilder let content: (() -> ItemView)
    var body: some View {
        VStack {
            ZStack {
                Button {
                    action()
                } label: {
                    ZStack {
                        if selected {
                            RoundedCorner(radius: 12.0, corners: UIRectCorner.topLeft.union(.bottomLeft)).foregroundColor(Color("ocean"))
                        } else {
                            RoundedCorner(radius: 12.0, corners: UIRectCorner.topLeft.union(.bottomLeft)).foregroundColor(Color("charcoal"))
                        }
                        content()
                    }
                }
                RoundedCorner(radius: 12.0, corners: UIRectCorner.topLeft.union(.bottomLeft)).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(.white)
            }
        }
        .frame(width: width, height: height)
    }
}

struct SegmentLeft_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                SegmentLeft(width: 80, height: ApplicationController.toolbarHeight - 8, selected: true, action: { }) {
                    Image(systemName: "square.grid.3x3")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 4)
                
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            
            HStack {
                Spacer()
                SegmentLeft(width: 80, height: ApplicationController.toolbarHeight - 8, selected: false, action: { }) {
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 4)
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
        }
    }
}
