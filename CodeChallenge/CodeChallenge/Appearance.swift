//
//  Appearance.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/30/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import Foundation
import UIKit

struct Appearance {
    
    struct Colors {
        
        static let first = UIColor(red: 0/255.0, green: 212.0/255.0, blue: 116.0/255.0, alpha: 1.0)
        static let second = UIColor(red: 8.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        static let third = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        static let empty = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    @available(iOS 8.2, *)
    struct Fonts {
        
        static let h1 = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.heavy)
        static let h2 = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
        static let h3 = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        static let h4 = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.medium)
        static let text = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        static let detailText = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.light)
    }
    
}

func globalAppearance() {
    
    let navigationBarAppearace = UINavigationBar.appearance()
    navigationBarAppearace.tintColor = Appearance.Colors.first
    if #available(iOS 8.2, *) {
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Appearance.Colors.first,
                                                      NSAttributedStringKey.font: Appearance.Fonts.h1]
    } else {
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Appearance.Colors.first]
    }
}
