//
//  utils.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 20/6/24.
//

import Foundation

func getIdFromUrl(_ url: String) -> Int {
    if let url = URL(string: url) {
           if let lastPathComponent = url.lastPathComponent.components(separatedBy: "/").last,
               let id = Int(lastPathComponent) {
               return id
           }
       }
    return 0
}

