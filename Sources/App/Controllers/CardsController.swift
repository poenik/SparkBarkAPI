//
//  CardsController.swift
//  App
//
//  Created by Nico Poenar on 12/04/2020.
//

import Vapor

final class CardsController: RouteCollection {
    
    // 2
    func boot(router: Router) throws {
        // 3
        let cardsRoute = router.grouped("api", "cards") // 4
        cardsRoute.post(Card.self, use: createHandler)
        cardsRoute.get(use: getAllHandler)
        cardsRoute.get("segments", use: getSegmentsHandler)
        cardsRoute.put(Card.parameter, use: updateHandler) // 4
    }
    // 5
    
    private func createHandler(_ req: Request, card: Card) throws -> Future<Card> {
        return card.save(on: req)
    }
    
    private func getAllHandler(_ req: Request) throws -> Future<[Card]> {
        return Card.query(on: req).all()
    }
    
    func getSegmentsHandler(_ req: Request) throws -> Future<[CardAndSegments]> {
        return Card.query(on: req).all().flatMap { cards in
            let segmentsResponseFutures = try cards.map { card in
                try card.segments.query(on: req).all().map { segments in
                    return CardAndSegments(card: card, segments: segments)
                }
            }
            return segmentsResponseFutures.flatten(on: req)
        }
    }
    
    func updateHandler(_ req: Request) throws -> Future<Card> {
        return try flatMap(
            to: Card.self, req.parameters.next(Card.self), req.content.decode(Card.self)
        ) { card, updatedCard in
            card.title = updatedCard.title
            card.subtitle = updatedCard.subtitle
            card.imageURL = updatedCard.imageURL
            card.body = updatedCard.body
            return card.save(on: req)
        } }
    
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

struct CardAndSegments: Content {
    var card: Card
    var segments: [Segment]
}
