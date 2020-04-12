import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", "vapor") { req -> String in
      return "Hello Vapor!"
    }
    
    // 1
    router.post(Pet.self, at: "petInfo") { req, data -> InfoResponse in
        // 2
        return InfoResponse(request: data)
    }
    
    // 1
    router.get("hello", String.parameter) { req -> String in
        // 2
        let name = try req.parameters.next(String.self)
        // 3
        return "Hello, \(name)!"
    }
    
//    // 1
//    router.get("api", "pets") { req -> Future<[Pet]> in // 2
//        return Pet.query(on: req).all()
//    }
//    
//    // 1
//    router.get("api", "pets", Pet.parameter) { req -> Future<Pet> in
//        // 2
//        return try req.parameters.next(Pet.self)
//    }
//    
//    // 1
//    router.put("api", "pets", Pet.parameter) { req -> Future<Pet> in
//        // 2
//        return try flatMap(to: Pet.self,
//                           req.parameters.next(Pet.self),
//                           req.content.decode(Pet.self)) { pet, updatedPet in
//                            // 3
//                            pet.name = updatedPet.name
//                            pet.age = updatedPet.age
//                            // 4
//                            return pet.save(on: req)
//        }
//    }
//    // 1
//    router.delete("api", "pets", Pet.parameter) { req -> Future<HTTPStatus> in
//        // 2
//        return try req.parameters.next(Pet.self)
//            // 3
//            .delete(on: req)
//            // 4
//            .transform(to: HTTPStatus.noContent)
//    }

    // 1
    let petController = PetsController()
    // 2
    try router.register(collection: petController)
    
    // 1
    let segmentsController = SegmentsController()
    // 2
    try router.register(collection: segmentsController)
}


struct InfoResponse: Content {
    let request: Pet
}
