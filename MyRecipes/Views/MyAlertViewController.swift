//
//  MyAlertViewController.swift
//  MyRecipes
//
//  Created by Noha Fahad on 10/12/2021.
//

import Foundation
import CleanyModal
class MyAlertViewController: CleanyAlertViewController {
    init(title: String?, message: String?, imageName: String? = nil, preferredStyle: CleanyAlertViewController.Style = .alert) {
        let styleSettings = CleanyAlertConfig.getDefaultStyleSettings()
        styleSettings[.tintColor] = UIColor(red: 133.0/255.0, green: 187.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        styleSettings[.destructiveColor] = .systemPink
        styleSettings[.textColor] = UIColor(red: 96.0/255.0, green: 71.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        super.init(title: title, message: message, imageName: imageName, preferredStyle: preferredStyle, styleSettings: styleSettings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
