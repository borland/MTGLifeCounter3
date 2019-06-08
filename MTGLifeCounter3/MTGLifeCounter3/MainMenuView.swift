//
//  MainMenuView.swift
//  MTGLifeCounter3
//
//  Created by Orion Edwards on 8/06/19.
//  Copyright © 2019 Orion Edwards. All rights reserved.
//

import SwiftUI

struct PlayerView : View {
    
    @State var fontSize: Length = 120
    
    @State var lifeTotal: Int = 20
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            HStack(spacing: 12) {
                Text("-")
                
                Text(String(lifeTotal))
                
                Text("+")
                
                }
                .font(.custom("Futura", size: fontSize))
                .tapAction(onTapped)
        }
    }
    
    func onTapped() {
        
    }
}

struct BackgroundView : View {
    @State var color1: Color = .red
    @State var color2: Color = .green
    
    var body: some View {
        Rectangle().fill(LinearGradient(
            gradient: .init(colors: [self.color1, self.color2]),
            startPoint: .init(x: 0.0, y: 0),
            endPoint: .init(x: 0.5, y: 0.6)
        ))
    }
}

struct MainMenuView : View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Games")) {
                    Text("Duel")
                    Text("Two-headed Giant")
                    Text("Three-player")
                    Text("Star")
                }
                Section(header: Text("Utilities")) {
                    Text("Roll D20")
                }
                }
                .listStyle(.grouped)
                .navigationBarTitle(Text("MTG Life Counter"))
        }
    }
}

struct DiceRollView : View {
    
    @State var number: Int = 12
    
    var body: some View {
        Text(String(number))
    }
}

#if DEBUG
struct MainMenuView_Previews : PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
#endif
