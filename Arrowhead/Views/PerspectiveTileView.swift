//
//  PerspectiveTileView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 9/8/21.
//

import SwiftUI

struct PerspectiveTileView: View {
    var name: String
    var color: Color
    var image: String
    var number: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Image(systemName: image)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(color)
                Text(name)
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
            VStack {
                Text("\(number)")
                    .foregroundColor(.black)
                    .font(.title)
                    .bold()
                Spacer()
            }
        }
        .padding(8)
        .background(Color(.white))
        .cornerRadius(15.0)
    }
}

struct PerspectiveTileView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(red: 0.94509804, green: 0.94509804, blue: 0.96862745)
                .ignoresSafeArea()
            
            PerspectiveTileView(name: "Today", color: Color(UIColor.systemIndigo), image: "calendar.circle.fill", number: 2)
                .frame(width: 200, height: 100)
        }
    }
}
