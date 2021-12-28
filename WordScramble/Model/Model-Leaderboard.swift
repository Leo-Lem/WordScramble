//
//  Leaderboard.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import Foundation

//TODO: add a synchronized leaderboard
extension Model {
    class Leaderboard: ObservableObject {
        var entries = [Entry]() {
            willSet { objectWillChange.send() }
            didSet { entries.sort() }
        }
        
        init() { load() }
        
        private let path = FileManager.documentsDirectory.appendingPathComponent("leaderboard.json")
    }
}

//MARK: the Rank struct (single entry on the leaderboard)
extension Model.Leaderboard {
    struct Entry: Comparable, Codable, Hashable {
        let name: String, word: String, score: Int, time: Double?, usedWords: [String], timestamp: Date
        
        static let example = Entry(name: "Leo", word: "silkworm", score: 9, time: 100, usedWords: ["silk", "worms"], timestamp: Date())
        
        static func <(lhs: Entry, rhs: Entry) -> Bool { lhs.score > rhs.score }
    }
}

//MARK: saving an entry to the leaderboard
extension Model.Leaderboard {
    func addEntry(game: Model.Game) {
        guard !game.user.name.isEmpty else { return }
            
        let rank = Entry(name: game.user.name, word: game.root, score: game.score,
                        time: game.user.timer ? game.time : nil,
                        usedWords: game.used, timestamp: Date())
        
        entries.append(rank)
    }
}

//MARK: loading and saving the leaderboard
//TODO: Implement proper error handling
extension Model.Leaderboard: PersistentStorage {
    func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: self.path)
        } catch {
            print("saving the leaderboard failed...")
        }
    }
    func load() {
        do {
            let data = try Data(contentsOf: self.path)
            let decoded = try JSONDecoder().decode([Entry].self, from: data)
            
            self.entries = decoded
        } catch {
            print("loading the leaderboard failed...")
        }
    }
}

//MARK: a description for easy access to the properties when debugging
extension Model.Leaderboard: CustomStringConvertible {
    var description: String {
        """
        ---------------
        Leaderboard
            Saved to: \(self.path)
        
            Entries: \(self.entries)
        ---------------
        """
    }
}