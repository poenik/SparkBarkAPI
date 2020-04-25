//
//  Card.swift
//  App
//
//  Created by Nico Poenar on 12/04/2020.
//

import FluentSQLite
import Vapor

final class Card: Codable {
    var id: Int?
    var title: String?
    var subtitle: String?
    var body: String?
    var imageURL: String?

    init(id: Int? = nil, title: String?, subtitle: String?, body: String?, imageURL: String?) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.imageURL = imageURL
    }
}

extension Card: SQLiteModel {}
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

