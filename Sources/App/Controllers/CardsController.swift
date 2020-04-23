//
//  CardsController.swift
//  App
//
//  Created by Nico Poenar on 12/04/2020.
//

import Vapor

final class CardsController {
    
//    func list(_ req: Request) throws -> Future<Response> {
//        let allCards = Card.query(on: req).all()
//        return allCards.flatMap { cards in
//           return try cards.map { card in
//                card.pets.query(on: req).all(),
//                card.segments.query(on:req).all()
//                )
//            }
//        }
//    }
    
    func createHandler(_ req: Request, card: Card) throws -> Future<Card> {
        return card.save(on: req)
    }
    
    func update(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(Card.self).flatMap { user in
            return try req.content.decode(CardForm.self).flatMap { _ in
                return user.save(on: req).map { _ in
                    return req.redirect(to: "/cards")
                }
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<Response> {
           return try req.parameters.next(Card.self).flatMap { user in
               return try user.pets.query(on: req).delete().flatMap { _ in
                   return user.delete(on: req).map { _ in
                       return req.redirect(to: "/cards")
                   }
               }
           }
       }
}

struct CardForm: Content {
    //var username: String
}

struct CardView: Encodable {
    var card: Card
    var pets: Future<[Pet]>
    var segments: Future<[Segment]>
}
