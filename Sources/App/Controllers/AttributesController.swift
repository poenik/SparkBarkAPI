//
//  AttributesController.swift
//  App
//
//  Created by Nico Poenar on 24/04/2020.
//

import Foundation
import Vapor
import Fluent

struct AttributesController: RouteCollection {
// 2
func boot(router: Router) throws {
    // 3
    let AttributesRoute = router.grouped("api", "segments", "attributes") // 4
    AttributesRoute.post(Attribute.self, use: createHandler)
    AttributesRoute.get(use: getAllHandler)
    AttributesRoute.get(Attribute.parameter, use: getHandler)
    AttributesRoute.put(Attribute.parameter, use: updateHandler)
}
// 5
func createHandler(_ req: Request, Attribute: Attribute) throws -> Future<Attribute> { // 6
    return Attribute.save(on: req)
}

func updateHandler(_ req: Request) throws -> Future<Attribute> {
       return try flatMap(
           to: Attribute.self, req.parameters.next(Attribute.self), req.content.decode(Attribute.self)
       ) { Attribute, updatedAttribute in
           Attribute.segmentID = updatedAttribute.segmentID
           Attribute.frameSize = updatedAttribute.frameSize
           Attribute.text = updatedAttribute.text
           Attribute.hasShadow = updatedAttribute.hasShadow
           return Attribute.save(on: req)
       } }

   func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
       return try req
           .parameters
           .next(Attribute.self)
           .delete(on: req)
           .transform(to: HTTPStatus.noContent)
   }
// 7
func getAllHandler(
    _ req: Request
    ) throws -> Future<[Attribute]> { // 8
    return Attribute.query(on: req).all()
}
// 9
func getHandler(_ req: Request) throws -> Future<Attribute> { // 10
    return try req.parameters.next(Attribute.self) }
}
