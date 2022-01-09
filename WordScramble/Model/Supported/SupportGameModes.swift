//
//  SupportGameModes.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation

//MARK: supported game modes
typealias GameModeType = Model.SupportedGameMode
extension Model {
    enum SupportedGameMode: String, CaseIterable, Codable {
        case single = "single",
             open = "open",
             secret = "secret",
             coop = "coop",
             turns = "turns"
    }
}
