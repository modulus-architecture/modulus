//
//  Fabricator.swift
//  ScaffBuilder
//
//  Created by Justin Smith on 7/24/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import Foundation



struct ProductionShop
{
    var grid: [ScaffMember]
    {
        willSet {
            
            let scaffSet = Changeset.editDistance(source: grid, target: newValue)
            for edit in scaffSet {
                handle (edit: edit)
            }
        }
    }
   
    private var site: Context  // maybe should change to forman, and manage counts
    private var scaff: [Element3D]
    
    init (grid: [ScaffMember], site:Context)
    {
      self.site = site
      self.grid = grid
      scaff = []
      scaff = (grid).map(self.element(from:)) // 17 x slowdown
      
      self.build() // 57 x slowdown
    }
    
    private mutating func handle(edit: Edit<ScaffMember>)
    {
        switch edit.operation
        {
            case .deletion:
                
                
                //print("HANDLE: Deletion \(edit.value.type)")
                let matchingElements = scaff.filter(
                    { (el: Element3D) -> Bool in
                    return el.isDerivedFrom(edit.value)
                })
                
                if matchingElements.count == 0 {
                    //print("now we're in trouble")
                    
                    for el in scaff{
                        if el.isRelatedTo(edit.value) {
                            
//                            print (el.isRelatedTo(edit.value))
//                            print (el.isDerivedFrom(edit.value))
                        }
                    }
                }
            
                self.removeElements(elements: matchingElements)

        case .insertion:
            
//            print("HANDLE: Insertion \(edit.value.type)")
            self.addElements(elements: [element(from: edit.value)])
        
        case .move(_):
            return
            
        case .substitution:
//            print("HANDLE: Substittusion \(edit.value.type)")
            // a little computational
            let member = grid[edit.destination]
            
            let matchingElements = scaff.filter(
                { (el: Element3D) -> Bool in
                    return el.isDerivedFrom(member)
            })
            
            self.removeElements(elements: matchingElements)
            self.addElements(elements: [element(from: edit.value)])

        }
    }
  
    private mutating func addElements(elements: [Element3D])
    {
        self.scaff += elements
        site.add(elements: elements )
    }
    private mutating func removeElements(elements: [Element3D])
    {
//        print(" starting cou :  \(scaff.count)")
//        print(" TO REMOVEEEE :  \(elements.count)")
        self.scaff = elements.reduce(self.scaff, {
            (lessScaff:[Element3D], newCheck:Element3D) -> [Element3D] in
            
            let indexOf = lessScaff.index(where: { (el) -> Bool in
                return el == newCheck
            })
            
            guard let index = indexOf else {
                return lessScaff
            }
            
            var newScaff = lessScaff
            newScaff.remove(at: index)
            return newScaff
        
        
        })
        site.remove(elements: elements)
    }
  
    
    private func build() {
        // Add heads
        //addHeads()
        // Add Ledgers
        //addLedgers()
        site.add(elements: scaff)

        // Create Grid
        //createGrid()
    }
    
    private func element(from s: ScaffMember) -> Element3D
    {
      return s.element3D
    }
    
    
    // add aperiodic uses Higher Level now like UIKit, createGrid uses lower level details (nodes) etc, like .layer in UIKit (Could be used similarly) 
    
    private func createGrid()
    {
        let squareSize = 500.0.mm // in mm
        let gridSize = 4000.0.mm
        let lines : Int = Int( gridSize.converted(to: .meters).value / squareSize.converted(to: .meters).value )
        
        let offset  = (x: (-500).mm, y:3000.mm)
        
        
        let geom = Tube(innerRadius: 0.mm, outerRadius: 4.mm, height: gridSize)
        
        // Horizonatl Bars
        var tubeNode = MakeNode(withGeometry: geom)
        tubeNode.location.y = offset.y
        tubeNode.location.x = offset.x
        tubeNode.eulerAngles.z = Degree(90).toRadians
        
        for i in -lines/2 ... lines/2
        {
            var n = tubeNode.clone()
            n.location.y +=  squareSize * Double(i)
            //print(i); print( Float(i) * squareSize)
            site.add(node: n)
        }
        
        // Vertical Bars
        tubeNode = MakeNode(withGeometry: geom)
        tubeNode.location.y = offset.y
        tubeNode.location.x = offset.x
        
        for i in -lines/2 ... lines/2
        {
            var n = tubeNode.clone()
            n.location.x +=  squareSize * Double(i )
            site.add(node: n)
        }
        
    }
}
