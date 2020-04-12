//
//  Body.swift
//  App
//
//  Created by Nico Poenar on 12/04/2020.
//

import FluentSQLite
import Vapor

enum Size: Int, Codable {
    case small
    case medium
    case large
}

enum Aligment: Int, Codable {
    case center
    case left
    case right
    case bottom
}

/// A single entry of a Todo list.
final class Body: Codable {
    /// The unique identifier for this `Pet`.
    var id: Int?
    var size: Size?

    /// Details about what this `Pet` entails.
    var aligment: Aligment?
    var axis: String?
    

    /// Creates a new `Pet`.
    init(id: Int? = nil, size: Size?, aligment: Aligment?, axis: String?) {
        self.id = id
        self.size = size
        self.aligment = aligment
        self.axis = axis
    }
}

extension Body: SQLiteModel {}
extension Body: Migration {}
extension Body: Content {}
extension Body: Parameter {}

