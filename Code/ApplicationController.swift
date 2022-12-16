//
//  ApplicationController.swift
//  BitWizard
//
//  Created by Nicky Taylor on 11/27/22.
//

import UIKit

enum AppMode {
    case collage
    case centralIdea
    case pairings
}

enum ShowHideMode {
    case showAll
    case hideSelectedUponShuffle
    case hideSelectedUponSelect
}

class ApplicationController {
    
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
        isIpad() ? 76 : 54
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
        print("App::handleMemoryWarning()")
    }
    
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
    
    //landscape: Bool
    
}
