import Vapor
import VaporPostgreSQL


let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Acronym.self

(drop.view as? LeafRenderer)?.stem.cache = nil


let basic = BasicAcronym()
let til = TILControler()

til.addRoutes(drop: drop)
basic.addRoutes(drop: drop)

let acronymsResource = AcronymsController()
drop.resource("acronyms", acronymsResource)

drop.get("version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return "No db connection"
    }
}

drop.get("model") { request in
    let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
    return try acronym.makeJSON()
}

//TEMPLATING ROUTES
drop.get("template", String.self) { request, name in
    return try drop.view.make("hello", Node(node: ["name" : name]))
}

drop.get("template2") { request in
    let users = try [
        ["name" : "Taylor", "email" : "phdlove42@gmail.com"].makeNode(),
        ["name" : "Clif", "email" : "phdlove42@gmail.com"].makeNode(),
        ["name" : "Shauna", "email" : "phdlove42@gmail.com"].makeNode(),
        ["name" : "Tim", "email" : "phdlove42@gmail.com"].makeNode()
        ].makeNode()
    return try drop.view.make("hello2", Node(node: ["users" : users]))
}

//DEMO ROUTES
drop.get { request in
    //return "Hello Vapor!!"
    return try JSON(node: [
        "message" : "Hello Vapor!"
        ])
}

drop.get("hello") { request in
    return try JSON(node: [
        "message" : "Hello Again!!"
        ])
}

drop.get("hello", "there") { request in
    return try JSON(node: [
        "message" : "What are you deaf?"
        ])
}

drop.get("beers", Int.self) { request, beers in
    return try JSON(node: [
        "message" : "Take one down, pass it around, \(beers - 1) bottles of beer on the wall..."
        ])
}

drop.post("post") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    
    return try JSON(node: [
        "message" : "Hello \(name) from the land of Posts!"
        ])
}

drop.run()
