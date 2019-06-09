//
//  MainMenuView.swift
//  MTGLifeCounter3
//
//  Created by Orion Edwards on 8/06/19.
//  Copyright © 2019 Orion Edwards. All rights reserved.
//

import SwiftUI
import Combine

struct MainMenuView : View {
    var body: some View {
        StarView()
    }
}

class Player : BindableObject {
    
    var lifeTotal: Int = 20
    var color: MtgColor = .redGreen
    
    let didChange = PassthroughSubject<Void, Never>()
}

func load(key: String, players: [Player]) {
    do {
        let settings = try DataStore.getWithKey(key)
        
        for (idx, p) in players.enumerated() {
            if let lt = (settings["player\(idx)"] as? NSNumber)?.intValue {
                p.lifeTotal = lt
            }
            if let c = (settings["player\(idx)color"] as? NSNumber)?.intValue, let mtgCol = MtgColor(rawValue: c) {
                p.color = mtgCol
            }
        }
    } catch {} // initial load, no biggie
}

struct DuelView : View {
    
    var player1 = Player()
    var player2 = Player()
    
    @Environment(\.verticalSizeClass)
    var verticalSizeClass
    
    @Environment(\.horizontalSizeClass)
    var horizontalSizeClass
    
    private let configKey = "duel"
    
    init() {
        load(key: configKey, players: [player1, player2])
    }
    
    // TODO save on deinit. Does SwiftUI even deinit?
    
    var body: some View {
        func landscapeView() -> AnyView {
            AnyView(HStack(alignment: .center, spacing: 0) {
                PlayerView(player: player1, orientation: .normal, buttonPosition: .aboveBelow)
                PlayerView(player: player2, orientation: .normal, buttonPosition: .aboveBelow)
            }.statusBar(hidden: true))
        }
        
        func portraitView() -> AnyView {
            AnyView(VStack(alignment: .center, spacing: 0) {
                PlayerView(player: player1, orientation: .upsideDown, buttonPosition: .leftRight)
                PlayerView(player: player2, orientation: .normal, buttonPosition: .leftRight)
            }.statusBar(hidden: true))
        }
        
        if let h = horizontalSizeClass, let v = verticalSizeClass {
            switch (h, v) {
            case (.compact, .compact): // phone landscape
                return landscapeView()
            default:
                return portraitView()
                
            }
        } else { // fallback
            return portraitView()
        }
    }
}

struct ThreePlayerView : View {
    
    var player1 = Player()
    var player2 = Player()
    var player3 = Player()
    
    @Environment(\.verticalSizeClass)
    var verticalSizeClass
    
    @Environment(\.horizontalSizeClass)
    var horizontalSizeClass
    
    private let configKey = "3player"
    
    init() {
        load(key: configKey, players: [player1, player2, player3])
    }
    
    // TODO save on deinit. Does SwiftUI even deinit?
    
    var body: some View {
        func landscapeView() -> AnyView {
            AnyView(HStack(alignment: .center, spacing: 0) {
                PlayerView(player: player1, orientation: .normal, buttonPosition: .aboveBelow)
                PlayerView(player: player2, orientation: .normal, buttonPosition: .aboveBelow)
                PlayerView(player: player3, orientation: .normal, buttonPosition: .aboveBelow)
                })
        }
        
        func portraitView() -> AnyView {
            AnyView(VStack(alignment: .center, spacing: 0) {
                PlayerView(player: player1, orientation: .normal, buttonPosition: .leftRight)
                PlayerView(player: player2, orientation: .normal, buttonPosition: .leftRight)
                PlayerView(player: player3, orientation: .normal, buttonPosition: .leftRight)
                })
        }
        
        if let h = horizontalSizeClass, let v = verticalSizeClass {
            switch (h, v) {
            case (.compact, .compact): // phone landscape
                return landscapeView()
            default:
                return portraitView()
                
            }
        } else { // fallback
            return portraitView()
        }
    }
}

struct StarView : View {
    
    var player1 = Player()
    var player2 = Player()
    var player3 = Player()
    var player4 = Player()
    var player5 = Player()
    
    @Environment(\.verticalSizeClass)
    var verticalSizeClass
    
    @Environment(\.horizontalSizeClass)
    var horizontalSizeClass
    
    private let configKey = "star"
    
    init() {
        load(key: configKey, players: [player1, player2, player3, player4, player5])
    }
    
    // TODO save on deinit. Does SwiftUI even deinit?
    
    var body: some View {
        func landscapeView() -> AnyView {
            AnyView(VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    PlayerView(player: player1, orientation: .upsideDown, buttonPosition: .leftRight)
                    PlayerView(player: player2, orientation: .upsideDown, buttonPosition: .leftRight)
                    PlayerView(player: player3, orientation: .upsideDown, buttonPosition: .leftRight)
                }
                HStack(alignment: .center, spacing: 0) {
                    PlayerView(player: player4, orientation: .normal, buttonPosition: .leftRight)
                    PlayerView(player: player5, orientation: .normal, buttonPosition: .leftRight)
                }
            })
        }
        
        func portraitView() -> AnyView {
            AnyView(VStack(alignment: .center, spacing: 0) {
                PlayerView(player: player1, orientation: .normal, buttonPosition: .aboveBelow)
                HStack(alignment: .center, spacing: 0) {
                    PlayerView(player: player2, orientation: .normal, buttonPosition: .aboveBelow)
                    PlayerView(player: player3, orientation: .normal, buttonPosition: .aboveBelow)
                }
                HStack(alignment: .center, spacing: 0) {
                    PlayerView(player: player4, orientation: .normal, buttonPosition: .aboveBelow)
                    PlayerView(player: player5, orientation: .normal, buttonPosition: .aboveBelow)
                }
            })
        }
        
        if let h = horizontalSizeClass, let v = verticalSizeClass {
            switch (h, v) {
            case (.compact, .compact): // phone landscape
                return landscapeView()
            default:
                return portraitView()
                
            }
        } else { // fallback
            return portraitView()
        }
    }
}

struct MainMenuView__ : View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Games")) {
                    NavigationButton(destination: DuelView()) {
                        Text("Duel")
                    }
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
