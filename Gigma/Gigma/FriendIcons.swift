//
//  FriendIcons.swift
//  Gigma
//
//  Created by kup21 on 16/06/2023.
//

import Foundation

/* Different types of possibe friend icons */
enum FriendIcon : String, CaseIterable {
    //person
    case DEFAULT  = "person.fill"
    case CIRCLE   = "person.circle"
    case SQUARE   = "person.crop.square"
    
    // bullshit
    case GRADS    = "graduationcap.fill"
    case APPL     = "applelogo"
    case PLAYS    = "logo.playstation"
    
    //figure
    case FIGURE   = "figure.stand"
    case WAVE     = "figure.wave"
    case ARMS     = "figure.arms.open"
    case WALK     = "figure.walk"
    case FALL     = "figure.fall"
    case DANCE    = "figure.dance"
    case STRENGTH = "figure.strengthtraining.traditional"
    case VOLLEY   = "figure.volleyball"
    case YOGA     = "figure.yoga"
    case HANDBALL = "figure.handball"
    //star
    case STAR     = "star.fill"
    //animals
    case HARE     = "hare.fill"
    case TORT     = "tortoise.fill"
    case LIZARD   = "lizard.fill"
    case BIRD     = "bird.fill"
    case LADYBUG  = "ladybug.fill"
    case FISH     = "fish.fill"
    case LEAF     = "leaf.fill"
    
    case STACHE   = "mustache.fill"
    case EYEGLASS = "eyeglasses"
    case CARROT   = "carrot.fill"
    
    case ATOM     = "atom"
    
    case SMILEY   = "smiley"
    // numbers
    case ZERO     = "0.circle.fill"
    case ONE      = "1.circle.fill"
    case TWO      = "2.circle.fill"
    case THREE    = "3.circle.fill"
    case FOUR     = "4.circle.fill"
    case FIVE     = "5.circle.fill"
    case SIX      = "6.circle.fill"
    case SEVEN    = "7.circle.fill"
    case EIGHT    = "8.circle.fill"
    case NINE     = "9.circle.fill"
    //letters
    case A        = "a.circle.fill"
    case B        = "b.circle.fill"
    case C        = "c.circle.fill"
    case D        = "d.circle.fill"
    case E        = "e.circle.fill"
    case F        = "f.circle.fill"
    case G        = "g.circle.fill"
    case H        = "h.circle.fill"
    case I        = "i.circle.fill"
    case J        = "j.circle.fill"
    case K        = "k.circle.fill"
    case L        = "l.circle.fill"
    case M        = "m.circle.fill"
    case N        = "n.circle.fill"
    case O        = "o.circle.fill"
    case P        = "p.circle.fill"
    case Q        = "q.circle.fill"
    case R        = "r.circle.fill"
    case S        = "s.circle.fill"
    case T        = "t.circle.fill"
    case U        = "u.circle.fill"
    case V        = "v.circle.fill"
    case W        = "w.circle.fill"
    case X        = "x.circle.fill"
    case Y        = "y.circle.fill"
    case Z        = "z.circle.fill"
    

    case OTHER    = "person.fill.turn.right"
    //TODO: Add more options
}

@objc class FriendIcons : NSObject {
    
    @objc static func getDefault() -> String {
        return FriendIcon.DEFAULT.rawValue
    }
    
    static func getIcon(icon: FriendIcon) -> String {
        return icon.rawValue
    }
    
    @objc static func getAllList() -> [String] {
        return FriendIcon.allCases.map(getIcon)
    }
}
