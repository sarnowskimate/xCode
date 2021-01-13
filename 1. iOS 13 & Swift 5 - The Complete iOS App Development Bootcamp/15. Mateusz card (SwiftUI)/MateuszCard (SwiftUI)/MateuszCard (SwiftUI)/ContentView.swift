//
//  ContentView.swift
//  MateuszCard (SwiftUI)
//
//  Created by Mateusz Sarnowski on 23/04/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.63, blue: 0.52)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("mateusz")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150.0)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                Text("Mateusz Sarnowski")
                    .font(.custom("Pacifico-Regular", size: 40))
                    .bold()
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                Text("Junior iOS Developer")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                Divider()
                    .frame(height: 60.0)
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .frame(height: 50.0)
                    .overlay(
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
            
                            Text("+48 726 874 071")
                        }
                )
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
