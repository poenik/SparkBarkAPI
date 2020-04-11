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
    
    // 1
    router.post("api", "pets") { req -> Future<Pet> in // 2
        return try req.content.decode(Pet.self).flatMap(to: Pet.self) { pet in // 3
            return pet.save(on: req)
        }
    }

//    // Example of configuring a controller
//    let todoController = TodoController()
//    router.get("todos", use: todoController.index)
//    router.post("todos", use: todoController.create)
//    router.delete("todos", Todo.parameter, use: todoController.delete)
}


struct InfoResponse: Content {
    let request: Pet
}
