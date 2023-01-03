//
//  HistoryController.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/15/22.
//

import Foundation

class HistoryController {
    
    static let maxHistoryCount = 256
    
    var historyStack = [HistoryState]()
    var historyIndex: Int = 0
    var lastActionWasAdd = false
    
    let mainContainerViewModel: MainContainerViewModel
    init(mainContainerViewModel: MainContainerViewModel) {
        self.mainContainerViewModel = mainContainerViewModel
    }
    
    func historyAdd(state: HistoryState) -> Void {
        var newHistoryStack = [HistoryState]()
        var index = 0
        if lastActionWasAdd {
            if (historyIndex == historyStack.count) && (historyStack.count == Self.maxHistoryCount) {
                index = 1
            }
        } else {
            if (historyIndex == (historyStack.count - 1)) && (historyStack.count == Self.maxHistoryCount) {
                index = 1
            }
        }
        while index <= historyIndex {
            if (index >= 0) && (index < historyStack.count) {
                newHistoryStack.append(historyStack[index])
            }
            index += 1
        }
        newHistoryStack.append(state)
        historyIndex = newHistoryStack.count
        historyStack = newHistoryStack
        lastActionWasAdd = true
    }
    
    func canUndo() -> Bool {
        if historyStack.count > 0 {
            if lastActionWasAdd {
                if historyIndex > 1 {
                    return true
                }
            } else {
                if historyIndex > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func canRedo() -> Bool {
        if historyStack.count > 0 {
            if historyIndex < (historyStack.count - 1) {
                return true
            }
        }
        return false
    }
    
    func undo() {
        if canUndo() {
            var index = historyIndex - 1
            if lastActionWasAdd {
                index -= 1
            }
            let state = historyStack[index]
            mainContainerViewModel.applyHistoryState(state)
            historyIndex = index
            lastActionWasAdd = false
        }
    }
    
    func redo() {
        if canRedo() {
            let index = historyIndex + 1
            let state = historyStack[index]
            mainContainerViewModel.applyHistoryState(state)
            historyIndex = index
            lastActionWasAdd = false
        }
    }
}
