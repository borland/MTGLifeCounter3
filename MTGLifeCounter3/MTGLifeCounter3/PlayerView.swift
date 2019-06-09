//
//  PlayerView.swift
//  MTGLifeCounter3
//
//  Created by Orion Edwards on 9/06/19.
//  Copyright © 2019 Orion Edwards. All rights reserved.
//

import SwiftUI


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
        Image(systemName: "minus").scaleEffect(0.4)
    }
}

struct PlusButton : View {
    var body: some View {
        Image(systemName: "plus").scaleEffect(0.4)
    }
}

struct PlayerForegroundView : View {
    @State var lifeTotal: Int // TODO propagating life total changes through from the player view
    let buttonPosition: PlusMinusButtonPosition
    
    var body: some View {
        GeometryReader { geometry -> AnyView in
            let fsize = min(geometry.size.width, geometry.size.height) / 2.5
            
            switch self.buttonPosition {
            case .leftRight:
                return AnyView(HStack(alignment: .center, spacing: 12) {
                    MinusButton()
                    Text(String(self.lifeTotal))
                    PlusButton()
                }.font(.custom("Futura", size: fsize)))
            case .rightLeft:
                return AnyView(HStack(alignment: .center, spacing: 12) {
                    PlusButton()
                    Text(String(self.lifeTotal))
                    MinusButton()
                }.font(.custom("Futura", size: fsize)))
            case .aboveBelow:
                return AnyView(VStack(alignment: .center, spacing: 0) {
                    PlusButton()
                    Text(String(self.lifeTotal))
                    MinusButton()
                }.font(.custom("Futura", size: fsize)))
            case .belowAbove:
                return AnyView(VStack(alignment: .center, spacing: 0) {
                    MinusButton()
                    Text(String(self.lifeTotal))
                    PlusButton()
                }.font(.custom("Futura", size: fsize)))
            }
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
            .rotationEffect(orientation.toAngle())
            .tapAction(onTapped)
    }
    
    func onTapped() {
        print("tapped")
    }
}
