//
//  Pet.swift
//  SparkAPI
//
//  Created by Nico on 26/01/2020.
//

import FluentMySQL
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
//    var segments: Siblings<Pet, Segment, PetSegmentPivot> {
//        // 2
//        return siblings()
//    }
    /// Creates a new `Pet`.
    init(id: Int? = nil, name: String, age: Int, gender: String, cardID: Int) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.cardID = cardID
    }
}

extension Pet: MySQLModel {}
extension Pet: Migration {}
extension Pet: Content {}
extension Pet: Parameter {}

extension Pet {
    var card: Parent<Pet, Card> {
        return parent(\.cardID)
    }
}

extension Pet {
    var segments: Children<Pet, Segment> {
        return children(\.cardID)
    }
}

struct PetAndSegment: Content {
    
    let id: Int?
    /// Details about what this `Pet` entails.
    let name: String
    let age: Int
    let gender: String
    let segments: [Segment]
    init(pet: Pet, segments: [Segment]) {
        self.id = pet.id
        self.name = pet.name
        self.age = pet.age
        self.gender = pet.gender
        self.segments = segments
    }
}

