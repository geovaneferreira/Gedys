//
//  ViewsColors.swift
//  Tracker
//
//  Created by Geovane Ferreira on 22/10/2017.
//  Copyright © 2017 Geovane Ferreira. All rights reserved.
//

import Foundation
import UIKit

class ViewsColor{
    
    static let sharedInstance = ViewsColor()
    var mode: Int = 3//UserConfigs.sharedInstance.themeid
    
    func change(modenew: Int){
       mode = modenew
       //UserConfigs.sharedInstance.setThemeId(user: modenew)
    }
    
    func getcolor(type: String) -> UIColor{
        switch mode {
        //Default color
        case 0:
            switch type{
            case "fundo2":
                return #colorLiteral(red: 0.3882747889, green: 0.3881644011, blue: 0.3924960494, alpha: 1);
            case "fundo1":
                return #colorLiteral(red: 0.3176162839, green: 0.3176667392, blue: 0.3176051378, alpha: 1);
            case "separador":
                return #colorLiteral(red: 0.9458052516, green: 0.4870610833, blue: 0.07835755497, alpha: 1);
            case "text1":
                return .white;
            case "text2":
                return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
                
            case "textomenu":
                return #colorLiteral(red: 0.9096733928, green: 0.4457026124, blue: 0, alpha: 1);
                
            case "menu":
                return #colorLiteral(red: 0.3882747889, green: 0.3881644011, blue: 0.3924960494, alpha: 1);
            case "titlemenu":
                return .white;
                
            case "badgeColor":
                return #colorLiteral(red: 0.9096733928, green: 0.4457026124, blue: 0, alpha: 1);
            case "badgeTextColor":
                return .black;
            default:
                break;
            }
        //blue
        case 1:
            switch type{
            case "fundo2":
                return #colorLiteral(red: 0.1224921271, green: 0.1643250883, blue: 0.228900373, alpha: 1);
            case "fundo1":
                return #colorLiteral(red: 0.08658476919, green: 0.1293463707, blue: 0.1808739305, alpha: 1);
            case "separador":
                return #colorLiteral(red: 0.07609579712, green: 0.4320496917, blue: 0.6448690891, alpha: 1);
            case "text1":
                return .white;
            case "text2":
                return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
                
            case "textomenu":
                return #colorLiteral(red: 0.09049583226, green: 0.4395091832, blue: 0.6652674079, alpha: 1);
         
            case "menu":
                return #colorLiteral(red: 0.1224921271, green: 0.1643250883, blue: 0.228900373, alpha: 1);
            case "titlemenu":
                return .white;
                
            case "badgeColor":
                return .red;
            case "badgeTextColor":
                return .white;
            default:
                break;
            }
            break;
        //pink
        case 2:
            switch type{
            case "fundo2":
                return #colorLiteral(red: 0.9249024987, green: 0.7779514194, blue: 0.8291663527, alpha: 1);
            case "fundo1":
                return #colorLiteral(red: 0.9249024987, green: 0.7779514194, blue: 0.8291663527, alpha: 1);
            case "separador":
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
            case "text1":
                return #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1);
            case "text2":
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
                
            case "textomenu":
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
                
            case "menu":
                return #colorLiteral(red: 0.8169220686, green: 0.2557370961, blue: 0.5497131944, alpha: 1);
            case "titlemenu":
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
                
            case "badgeColor":
                return #colorLiteral(red: 0.9679922462, green: 0.7987403274, blue: 0.03926862776, alpha: 1);
            case "badgeTextColor":
                return .white;
            default:
                break;
            }
            break;
        //dark red
        case 3:
            switch type{
            case "fundo2":
                return .black;
            case "fundo1":
                return #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1);
            case "separador":
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1);
            case "text1":
                return .white;
            case "text2":
                return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
                
            case "textomenu":
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
                
            case "menu":
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1);
            case "titlemenu":
                return .white;
                
            case "badgeColor":
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
            case "badgeTextColor":
                return .black;
            case "line-map":
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
            default:
                break;
            }
            break;
        default:
            break;
            
        }
        return UIColor(red: 0.1256652176, green: 0.1885133684, blue: 0.2484753728, alpha: 1);
    }
}
