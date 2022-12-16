//
//  SegmentSecondaryRight.swift
//  ToolInterface
//
//  Created by Tri Le on 12/2/22.
//

import SwiftUI

struct SegmentSecondaryRight<ItemView>: View where ItemView: View {
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
                            RoundedCorner(radius: 12.0, corners: UIRectCorner.topRight.union(.bottomRight)).foregroundColor(Color("iguana"))
                        } else {
                            RoundedCorner(radius: 12.0, corners: UIRectCorner.topRight.union(.bottomRight)).foregroundColor(Color("charcoal"))
                        }
                        content()
                    }
                }
                RoundedCorner(radius: 12.0, corners: UIRectCorner.topRight.union(.bottomRight)).stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(Color("limestone"))
            }
        }
        .frame(width: width, height: height)
    }
}

struct SegmentSecondaryRight_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                SegmentSecondaryRight(width: 80, height: ApplicationController.toolbarHeight - 8, selected: true, action: { }) {
                    Image(systemName: "shuffle")
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 4)
                
                Spacer()
            }
            .background(LinearGradient(colors: [Color("toolbar_dark_1"), Color("toolbar_dark_2")], startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0)))
            
            
            HStack {
                Spacer()
                SegmentSecondaryRight(width: 80, height: ApplicationController.toolbarHeight - 8, selected: false, action: { }) {
                    Image(systemName: "gear")
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
