//
//  CentralConceptLayout.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/3/22.
//

import UIKit

class CentralConceptLayout: ConceptLayout {
    
    required init(imageBucket: ImageBucket) {
        super.init(imageBucket: imageBucket)
        print("CentralConceptLayout.init()")
    }
    
    deinit {
        print("CentralConceptLayout.deinit()")
    }
    
    func build(gridWidth: Int) -> ConceptLayoutBuildResponse {
        
        var result = ConceptLayoutBuildResponse()
        
        concepts.removeAll(keepingCapacity: true)
        rects.removeAll(keepingCapacity: true)
        
        beginFreshBuild()
        
        //addCenterPiece(gridWidth: gridWidth)
        
        
        var tileWidth: CGFloat = layoutWidth * 0.5
        if tileWidth > 100 { tileWidth = 100 }
        
        
        var tw: CGFloat = layoutWidth * 0.333333
        for __x in 0..<3 {
            
            var y: CGFloat = 0
            var __keepGoing = true
            while __keepGoing {
                __keepGoing = false
                
                if let node = dequeueAny() {
                    
                    if Bool.random() {
                        reenqueue(node: node)
                        __keepGoing = true
                    } else {
                        
                        let nodeSize = node.size
                        
                        let fitSize = CGSize(width: tw, height: 1024.0)
                        
                        let frame = fitSize.getAspectFit(nodeSize)
                        
                        if (y + frame.height) > layoutHeight {
                            reenqueue(node: node)
                        } else {
                            __keepGoing = true
                            
                            let x = CGFloat(__x) * tw
                            
                            let concept = ConceptModel(id: baseID, x: x, y: y, width: frame.width, height: frame.height, image: node.image, node: node)
                            
                            concepts.append(concept)
                            
                            y += frame.height
                            
                        }
                    }
                }
            }
        }
        
        
        
        for concept in concepts {
            result.add(node: concept.node)
        }
        
        
        /*
        for i in 0..<1 {
            if i >= 0 && i < imageBucket.ideas.count {
                
                let node = imageBucket.ideas[i]
                let nodeSize = node.size
                
                let fitSize = CGSize(width: tileWidth, height: 66.0)
                
                let frame = fitSize.getAspectFit(nodeSize)
                
                let concept = ConceptModel(id: baseID, x: centerX - frame.width * 0.5, y: y, width: frame.width, height: frame.height, image: node.image, node: node)
                
                incrementBaseID()
                
                result.usedIdeas.append(node)
                concepts.append(concept)
                
                y += frame.height + 10.0
            }
        }
        */
        
        /*
        var upperCap = 8
        if layoutWidth > layoutHeight {
            upperCap = 2
        }
        
        var y: CGFloat = layoutHeight * 0.05
        for i in 0..<upperCap {
            if i >= 0 && i < imageBucket.words.count {
                
                let node = imageBucket.words[i]
                let nodeSize = node.size
                
                let fitSize = CGSize(width: tileWidth, height: 66.0)
                
                let frame = fitSize.getAspectFit(nodeSize)
                
                let concept = ConceptModel(id: baseID, x: centerX - frame.width * 0.5 - layoutWidth * 0.25, y: y, width: frame.width, height: frame.height, image: node.image, node: node)
                
                incrementBaseID()
                
                result.usedWords.append(node)
                concepts.append(concept)
                
                
                rects.append(RectModel(id: baseID, x: 5, y: y, width: frame.width, height: frame.height, color: UIColor.red.withAlphaComponent(0.5)))
                
                y += frame.height + 10.0
                
                
            }
        }
        
        y = layoutHeight * 0.05
        for i in 0..<upperCap {
            if i >= 0 && i < imageBucket.words.count {
                
                let node = imageBucket.words[i + upperCap]
                let nodeSize = node.size
                
                let fitSize = CGSize(width: tileWidth, height: 66.0)
                
                let frame = fitSize.getAspectFit(nodeSize)
                
                let concept = ConceptModel(id: baseID, x: centerX - frame.width * 0.5 + layoutWidth * 0.25, y: y, width: frame.width, height: frame.height, image: node.image, node: node)
                
                incrementBaseID()
                
                result.usedWords.append(node)
                concepts.append(concept)
                
                rects.append(RectModel(id: baseID, x: layoutWidth - frame.width - 5, y: y, width: frame.width, height: frame.height, color: UIColor.blue.withAlphaComponent(0.5)))
                
                y += frame.height + 10.0
            }
        }
        */
        
        return result
        
        /*
        let nodes = ideaCollection.fetch(3000)
        //print("nodes = \(nodes)")
        
        if nodes.count > 0 {
            
            let node = nodes.randomElement()!
            
            let minDimension = min(layoutWidth, layoutHeight)
            let fitDimension: CGFloat = round(minDimension * 0.33)
            let fitSize = CGSize(width: fitDimension, height: fitDimension)
            
            let frame = fitSize.getAspectFit(node.size).size
            let x: CGFloat = centerX - frame.width * 0.5
            let y: CGFloat = centerY - frame.height * 0.5
            let width = frame.width
            let height = frame.height
            
            print("id: \(baseID) layout dims x: \(x) y: \(y) width: \(width) height: \(height)")
            
            let concept = ConceptModel(id: baseID, x: x, y: y, width: width, height: height, image: node.image, node: node)
            incrementBaseID()
            
            result.usedWords.append(node)
            
            concepts.append(concept)
            
            //baseID += 1
            
        }
        
        let werds = wordCollection.fetch(150)
        guard werds.count > 0 else { return }
        
        for i in 1..<werds.count {
            
            var placed = false
            var fudge = 0
            
            while !placed && fudge < 200 {
                fudge += 1
                
                let node = werds[i]
                
                let scale = CGFloat.random(in: 0.125...0.25)
                let width = node.width * scale
                let height = node.height * scale
                let xMax = layoutWidth - width
                let yMax = layoutHeight - height
                
                if xMax > 1.0 && yMax > 1.0 {
                    
                    let x = CGFloat.random(in: 0...xMax)
                    let y = CGFloat.random(in: 0...yMax)
                    
                    let rect = CGRect(x: x, y: y, width: width, height: height)
                    if !collidesWithAnyOtherConcept(rect: rect, padding: 6.0) {
                        
                        let concept = ConceptModel(id: baseID, x: x, y: y, width: width, height: height, image: node.image, node: node)
                        incrementBaseID()
                        
                        result.usedWords.append(node)
                        
                        concepts.append(concept)
                        
                        placed = true
                    }
                    
                    
                }
            }
            
            
        }
        */
        
    }
    
    private func addCenterPiece(gridWidth: Int) -> CGRect {
        
        var fitBox = CGRect(x: centerX - 64.0, y: centerY - 64.0, width: 128.0, height: 128.0)
        
        var _picked: ImageCollectionNode?
        if let idea = dequeueIdea() {
            _picked = idea
        } else {
            if let word = dequeueWord() {
                _picked = word
            }
        }
        guard let picked = _picked else {
            return fitBox
        }
        
        
        
        
        if gridWidth <= 1 {
        
            let big = findLargestAppropriateColumnWidthForSizeOne()
            
        }
        
        
        
        
        return fitBox
    }
    
    
}
