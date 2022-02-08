//
//  FiguresList.swift
//  Blokudoku
//
//  Created by Владислава Гильде on 09.02.2022.
//

import Foundation

 let figuresLibrary: [[[CellState]]] = [

    // *
    [[.active]],
    
    // * *
    [[.active, .active]],
    
    // *
    // *
    [[.active],
     [.active]],
    
    // * * *
    [[.active, .active, .active]],
    
    // *
    // *
    // *
    [[.active],
     [.active],
     [.active]],
    
    // * * * *
    [[.active, .active, .active, .active]],
    
    // *
    // *
    // *
    // *
    [[.active],
     [.active],
     [.active],
     [.active]],
    
    // * * * * *
    [[.active, .active, .active, .active, .active]],
    
    // *
    // *
    // *
    // *
    // *
    [[.active],
     [.active],
     [.active],
     [.active],
     [.active]],
    
    // * *
    // * *
    [[.active, .active],
     [.active, .active]],
    
    // * *
    // *
    [[.active, .active],
     [.active, .unactive]],
    
    // * *
    //   *
    [[.active, .active],
     [.unactive, .active]],
    
    // *
    // * *
    [[.active, .unactive],
     [.active, .active]],
    
    //   *
    // * *
    [[.unactive, .active],
     [.active, .active]],
    
    // *
    //   *
    [[.active, .unactive],
     [.unactive, .active]],
    
    //   *
    // *
    [[.unactive, .active],
     [.active, .unactive]],
    
    // *
    // * * *
    [[.active, .unactive, .unactive],
     [.active, .active, .active]],
    
    //     *
    // * * *
    [[.unactive, .unactive, .active],
     [.active, .active, .active]],
    
    // * * *
    // *
    [[.active, .active, .active],
     [.active, .unactive, .unactive]],
    
    // * * *
    //     *
    [[.active, .active, .active],
     [.unactive, .unactive, .active]],
    
    // * *
    // *
    // *
    [[.active, .active],
     [.active, .unactive],
     [.active, .unactive]],
    
    // * *
    //   *
    //   *
    [[.active, .active],
     [.unactive, .active],
     [.unactive, .active]],
    
    // *
    // *
    // * *
    [[.active, .unactive],
     [.active, .unactive],
     [.active, .active]],
    
    //   *
    //   *
    // * *
    [[.unactive, .active],
     [.unactive, .active],
     [.active, .active]],
    
    //   *
    // * * *
    [[.unactive, .active, .unactive],
     [.active, .active, .active]],
    
    // * * *
    //   *
    [[.active, .active, .active],
     [.unactive, .active, .unactive]],

    // *
    // * *
    // *
    [[.active, .unactive],
     [.active, .active],
     [.active, .unactive]],
    
    //   *
    // * *
    //   *
    [[.unactive, .active],
     [.active, .active],
     [.unactive, .active]],
    
    // * * *
    // *
    // *
    [[.active, .active, .active],
     [.active, .unactive, .unactive],
     [.active, .unactive, .unactive]],
    
    
    // * * *
    //     *
    //     *
    [[.active, .active, .active],
     [.unactive, .unactive, .active],
     [.unactive, .unactive, .active]],
    
    // *
    // *
    // * * *
    [[.active, .unactive, .unactive],
     [.active, .unactive, .unactive],
     [.active, .active, .active]],
    
    //     *
    //     *
    // * * *
    [[.unactive, .unactive, .active],
     [.unactive, .unactive, .active],
     [.active, .active, .active]],
    
    //   *
    // * * *
    //   *
    [[.unactive, .active, .unactive],
     [.active, .active, .active],
     [.unactive, .active, .unactive]],
    
    //   *
    //   *
    // * * *
    [[.unactive, .active, .unactive],
     [.unactive, .active, .unactive],
     [.active, .active, .active]],
    
    // * * *
    //   *
    //   *
    [[.active, .active, .active],
     [.unactive, .active, .unactive],
     [.unactive, .active, .unactive]],
    
    // *
    // * * *
    // *
    [[.active, .unactive, .unactive],
     [.active, .active, .active],
     [.active, .unactive, .unactive]],
    
    //     *
    // * * *
    //     *
    [[.unactive, .unactive, .active],
     [.active, .active, .active],
     [.unactive, .unactive, .active]],
    
    // *
    //   *
    //     *
    [[.active, .unactive, .unactive],
     [.unactive, .active, .unactive],
     [.unactive, .unactive, .active]],
    
    //     *
    //   *
    // *
    [[.unactive, .unactive, .active],
     [.unactive, .active, .unactive],
     [.active, .unactive, .unactive]],
    
    // * * *
    // *   *
    [[.active, .active, .active],
     [.active, .unactive, .active]],
    
    // *   *
    // * * *
    [[.active, .unactive, .active],
     [.active, .active, .active]],
    
    // * *
    // *
    // * *
    [[.active, .active],
     [.active, .unactive],
     [.active, .active]],
    
    // * *
    //   *
    // * *
    [[.active, .active],
     [.unactive, .active],
     [.active, .active]],
]
