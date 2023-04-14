//
//  ApplicationController.swift
//  BitWizard
//
//  Created by Nicky Taylor on 11/27/22.
//

import UIKit

class ApplicationController {
    
    static let averageWidthWords: CGFloat = 800.0
    static let averageHeightWords: CGFloat = 385.0
    static let averageRatioWords: CGFloat = 2.0
    
    static let averageWidthIdeas: CGFloat = 790.0
    static let averageHeightIdeas: CGFloat = 638.0
    static let averageRatioIdeas: CGFloat = 1.25
    
    static let averageWidth: CGFloat = 795.0
    static let averageHeight: CGFloat = 412.0
    static let averageRatio: CGFloat = 1.94
    
    
    static func preview() -> ApplicationController {
        ApplicationController()
    }
    
    lazy var persistenceManager: PersistenceManager = {
        PersistenceManager(app: self)
    }()
    
    lazy var mainContainerViewModel: MainContainerViewModel = {
        MainContainerViewModel(app: self)
    }()
    
    static func isIpad() -> Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var toolbarHeight: CGFloat {
        isIpad() ? 76 : 50
    }
    
    static var toolbarMiddleSeparatorHeight: CGFloat {
        isIpad() ? 2 : 1
    }
    
    static var toolbarEdgeSeparatorHeight: CGFloat {
        isIpad() ? 2 : 1
    }
    
    lazy var documentsDir: String = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "/"
    }()
    
    lazy var bundleDir: String = {
        (Bundle.main.resourcePath ?? "NULL") + "/"
    }()
    
    func handleMemoryWarning() {
        mainContainerViewModel.handleMemoryWarning()
    }
    
    lazy var plusImage: UIImage = {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 512, weight: .bold, scale: .large)
        if let result = UIImage(systemName: "plus", withConfiguration: symbolConfig) {
            return result.withRenderingMode(.alwaysTemplate)
        }
        return UIImage()
    }()
    
    //ToolMenuConfiguration
    static func toolMenuConfiguration(landscape: Bool) -> ToolMenuConfiguration {
        if isIpad() {
            return .oneLine
        } else {
            if landscape {
                return .oneLine
            } else {
                return .twoLine
            }
        }
    }
    
    static func topMenuHeight(configuration: ToolMenuConfiguration) -> CGFloat {
        switch configuration {
        case .oneLine:
            return toolbarHeight + toolbarEdgeSeparatorHeight
        case .twoLine:
            return toolbarHeight + toolbarMiddleSeparatorHeight + toolbarHeight + toolbarEdgeSeparatorHeight
        }
    }
    
    static func topMenuHeight(landscape: Bool) -> CGFloat {
        switch toolMenuConfiguration(landscape: landscape) {
        case .oneLine:
            return toolbarHeight + toolbarEdgeSeparatorHeight
        case .twoLine:
            return toolbarHeight + toolbarMiddleSeparatorHeight + toolbarHeight + toolbarEdgeSeparatorHeight
        }
    }
}
