//
//  PetSegmentPivot.swift
//  App
//
//  Created by Nico Poenar on 12/04/2020.
//

import FluentMySQL
import Foundation

// 1
final class PetSegmentPivot: MySQLUUIDPivot, ModifiablePivot {
    // 2
    var id: UUID?
    // 3
    var petID: Pet.ID
    var segmentID: Segment.ID
    // 4
    typealias Left = Pet
    typealias Right = Segment
    // 5
    static let leftIDKey: LeftIDKey = \.petID
    static let rightIDKey: RightIDKey = \.segmentID
    // 6
    init(_ pet: Pet, _ segment: Segment) throws {
        self.petID = try pet.requireID()
        self.segmentID = try segment.requireID()
    }
}
// 7
extension PetSegmentPivot: Migration {}

