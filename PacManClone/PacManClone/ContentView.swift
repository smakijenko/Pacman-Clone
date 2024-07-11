//
//  ContentView.swift
//  PacManClone
//
//  Created by Stanisław Makijenko on 24/06/2024.
//

import SwiftUI

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = GameScene()

    var body: some View {
        ZStack{
            Rectangle()
                .fill(.gray)
                .ignoresSafeArea()
            VStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView()
}

