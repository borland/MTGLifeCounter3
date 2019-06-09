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
        ThreePlayerView()
    }
}

enum PlayerViewOrientation {
    case normal, upsideDown, left, right
    
    func toAngle() -> Angle {
        switch self {
        case .normal: return Angle(degrees: 0)
        case .upsideDown: return Angle(degrees: 180)
        case .left: return Angle(degrees: 90)
        case .right: return Angle(degrees: 270)
        }
    }
}

enum PlusMinusButtonPosition { // use nil for auto
    case rightLeft, // + on the right, - on the left
    leftRight,
    aboveBelow, // + above, - below
    belowAbove
}

struct MinusButton : View {
    var body: some View {
        Image(systemName: "minus").scaleEffect(0.5)
    }
}

struct PlusButton : View {
    var body: some View {
        Image(systemName: "plus").scaleEffect(0.5)
    }
}

struct PlayerForegroundView : View {
    @State var lifeTotal: Int // TODO propagating life total changes through from the player view
    let buttonPosition: PlusMinusButtonPosition
    
    var body: some View {
        switch buttonPosition {
        case .leftRight:
            return AnyView(HStack(alignment: .center, spacing: 12) {
                MinusButton()
                Text(String(lifeTotal))
                PlusButton()
            })
        case .rightLeft:
            return AnyView(HStack(alignment: .center, spacing: 12) {
                PlusButton()
                Text(String(lifeTotal))
                MinusButton()
            })
        case .aboveBelow:
            return AnyView(VStack(alignment: .center, spacing: 0) {
                PlusButton()
                Text(String(lifeTotal))
                MinusButton()
            })
        case .belowAbove:
            return AnyView(VStack(alignment: .center, spacing: 0) {
                MinusButton()
                Text(String(lifeTotal))
                PlusButton()
            })
        }
    }
}

struct PlayerBackgroundView : View {
    @State var color1: Color = .red
    @State var color2: Color = .green
    
    var body: some View {
        GeometryReader { (geometry) -> ShapeView<Rectangle, RadialGradient> in
            let endRadius = max(geometry.size.width, geometry.size.height) * 1.3
            
            return Rectangle().fill(RadialGradient(
                gradient: .init(colors: [self.color1, self.color2]),
                center: .init(x: 0, y: 0),
                startRadius: 0,
                endRadius: endRadius))
        }
    }
}


struct PlayerView : View {
    
    @State var fontSize: Length = 120
    
    @ObjectBinding var player: Player
    
    let orientation: PlayerViewOrientation
    let buttonPosition: PlusMinusButtonPosition
    
    init(player: Player, orientation: PlayerViewOrientation, buttonPosition: PlusMinusButtonPosition) {
        self.player = player
        self.orientation = orientation
        self.buttonPosition = buttonPosition
    }
    
    var body: some View {
        ZStack {
            PlayerBackgroundView()
            PlayerForegroundView(lifeTotal: player.lifeTotal, buttonPosition: buttonPosition)
        }
        .font(.custom("Futura", size: fontSize))
        .rotationEffect(orientation.toAngle())
        .tapAction(onTapped)
    }
    
    func onTapped() {
        print("tapped")
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

struct StarPlayerView : View {
    
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
            AnyView(HStack(alignment: .center, spacing: 0) {
                PlayerView(player: player1, orientation: .normal, buttonPosition: .leftRight)
            })
        }
        
        func portraitView() -> AnyView {
            AnyView(VStack(alignment: .center, spacing: 0) {
                PlayerView(player: player1, orientation: .normal, buttonPosition: .leftRight)
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
