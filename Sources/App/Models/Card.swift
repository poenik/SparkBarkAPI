//
//  Card.swift
//  App
//
//  Created by Nico Poenar on 12/04/2020.
//

import FluentSQLite
import Vapor

final class Card: SQLiteModel {
    var id: Int?
    var username: String

    init(id: Int? = nil, username: String) {
        self.id = id
        self.username = username
    }
}

extension Card: Content {}
extension Card: Migration {}
extension Card: Parameter {}

extension Card {
    var pets: Children<Card, Pet> {
        return children(\.cardID)
    }
    var segments: Children<Card, Segment> {
        return children(\.cardID)
    }
}

struct CardAndPet: Content {
    let card: Card
    let pet: Pet
}

final class UserAndPets: Content {
    let card: Card
    var pets: [Pet] // class + mutable to make collecting pets easier

    init(card: Card, pets: [Pet]) {
        self.card = card
        self.pets = pets
    }
}

