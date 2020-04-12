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
    }
    // 5
    func createHandler(_ req: Request, segment: Segment) throws -> Future<Segment> { // 6
        return segment.save(on: req)
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
