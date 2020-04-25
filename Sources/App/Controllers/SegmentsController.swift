//
//  SegmentsController.swift
//  App
//
//  Created by Nico Poenar on 12/04/2020.
//

import Vapor
// 1
struct SegmentsController: RouteCollection {
    // 2
    func boot(router: Router) throws {
        // 3
        let segmentsRoute = router.grouped("api", "segments") // 4
        segmentsRoute.post(Segment.self, use: createHandler)
        segmentsRoute.get(use: getAllHandler)
        segmentsRoute.get(Segment.parameter, use: getHandler)
        segmentsRoute.put(Segment.parameter, use: updateHandler) // 4
    }
    // 5
    func createHandler(_ req: Request, segment: Segment) throws -> Future<Segment> { // 6
        return segment.save(on: req)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Segment> {
           return try flatMap(
               to: Segment.self, req.parameters.next(Segment.self), req.content.decode(Segment.self)
           ) { Segment, updatedSegment in
            Segment.cardID = updatedSegment.cardID
            return Segment.save(on: req)
        } }

       func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
           return try req
               .parameters
               .next(Segment.self)
               .delete(on: req)
               .transform(to: HTTPStatus.noContent)
       }
    // 7
    func getAllHandler(
        _ req: Request
        ) throws -> Future<[Segment]> { // 8
        return Segment.query(on: req).all()
    }
    // 9
    func getHandler(_ req: Request) throws -> Future<Segment> { // 10
        return try req.parameters.next(Segment.self) }
}
