//
//  Pet.swift
//  SparkAPI
//
//  Created by Nico on 26/01/2020.
//

import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Pet: Codable {
    /// The unique identifier for this `Pet`.
    var id: Int?
    var cardID: Int
    /// Details about what this `Pet` entails.
    var name: String
    var age: Int
    var gender: String
    var segments: Siblings<Pet, Segment, PetSegmentPivot> {
        // 2
        return siblings()
    }
    /// Creates a new `Pet`.
    init(id: Int? = nil, name: String, age: Int, gender: String, cardID: Int) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.cardID = cardID
    }
}

extension Pet: SQLiteModel {}
extension Pet: Migration {}
extension Pet: Content {}
extension Pet: Parameter {}

extension Pet {
    var card: Parent<Pet, Card> {
        return parent(\.cardID)
    }
}

struct PetAndSegment: Content {
    let pet: Pet
    let segment: Segment
}

