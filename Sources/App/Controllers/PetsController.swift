import Vapor
import Fluent

struct PetsController: RouteCollection {

    func boot(router: Router) throws {
        let petsRoutes = router.grouped("api", "pets")

        petsRoutes.get(use: getAllHandler)
        // 1
        petsRoutes.post(Pet.self, use: createHandler)
        // 2
        petsRoutes.get(Pet.parameter, use: getHandler)
        // 3
        petsRoutes.put(Pet.parameter, use: updateHandler) // 4
        petsRoutes.delete(Pet.parameter, use: deleteHandler)
        // 5
        petsRoutes.get("search", use: searchHandler) // 6
        petsRoutes.get("first", use: getFirstHandler) // 7
        petsRoutes.get("sorted", use: sortedHandler)
        petsRoutes.post(Pet.parameter, "segments", Segment.parameter, use: addSegmentsHandler)
        petsRoutes.get("segments", use: getSegmentsHandler)
    }

    func getAllHandler(_ req: Request) throws -> Future<[Pet]> {
        return Pet.query(on: req).all()
    }

    // 1
    func addSegmentsHandler(_ req: Request) throws -> Future<HTTPStatus> { // 2
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Pet.self), req.parameters.next(Segment.self)) { pet, segment in
            // 3
            return pet.segments.attach(segment, on: req) .transform(to: .created)
        }
    }

    func createHandler(_ req: Request, pet: Pet) throws -> Future<Pet> {
        return pet.save(on: req)
    }


    func getHandler(_ req: Request) throws -> Future<Pet> {
        return try req.parameters.next(Pet.self) }

//    // 1
    func getSegmentsHandler(_ req: Request) throws -> Future<[PetAndSegment]> { // 2
        let usersWithCats = Pet.query(on: req)
            .join(\Segment.cardID, to: \Pet.id)
            //.filter(\Pet.name == "Chiri")
            .alsoDecode(Segment.self).all()
            .map { results in
                results.map { PetAndSegment(pet: $0.0, segment: $0.1) }
        }
        return usersWithCats
    }

    func updateHandler(_ req: Request) throws -> Future<Pet> {
        return try flatMap(
            to: Pet.self, req.parameters.next(Pet.self), req.content.decode(Pet.self)
        ) { Pet, updatedPet in
            Pet.name = updatedPet.name
            Pet.age = updatedPet.age
            Pet.cardID = updatedPet.cardID
            return Pet.save(on: req)
        } }

    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req
            .parameters
            .next(Pet.self)
            .delete(on: req)
            .transform(to: HTTPStatus.noContent)
    }
    func searchHandler(_ req: Request) throws -> Future<[Pet]> { guard let searchTerm = req
        .query[String.self, at: "term"] else { throw Abort(.badRequest)
        }
        return Pet.query(on: req).group(.or) { or in
            or.filter(\.name == searchTerm)
            or.filter(\.gender == searchTerm) }.all()
    }
    func getFirstHandler(_ req: Request) throws -> Future<Pet> { return Pet.query(on: req)
        .first()
        .map(to: Pet.self) { Pet in guard let Pet = Pet else {
            throw Abort(.notFound) }
            return Pet
        }
    }
    func sortedHandler(_ req: Request) throws -> Future<[Pet]> {
        return Pet.query(on: req).sort(\.name, .ascending).all()
    }

}
