//
//  Actor.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import Foundation

/**
 Since the JSON has a root object, we need to decode it to get all of its associated entries.
 */
struct Directory: Decodable {
    var actors: [Actor]
}

struct Actor: Decodable {

    enum CodingKeys: String, CodingKey {
        case identifier = "uuid"
        case fullName = "full_name"
        case phoneNumber = "agent_phone_number"
        case email = "agent_email_address"
        case photo = "photo_url"
        case knownFor = "known_for"
    }

    // The unique identifier for the actor.
    var identifier: UUID

    // The full name of the actor.
    var fullName: String

    // (Optional) The phone number of the actor's agent.
    var phoneNumber: String?

    // The email address of the actor's agent.
    var email: String

    // (Optional) The URL of the actor's photo.
    var photo: URL?

    // A famous show the actor is known for.
    var knownFor: String

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try values.decode(UUID.self, forKey: .identifier)
        self.fullName = try values.decode(String.self, forKey: .fullName)
        self.phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.email = try values.decode(String.self, forKey: .email)
        self.photo = try values.decodeIfPresent(URL.self, forKey: .photo)
        self.knownFor = try values.decode(String.self, forKey: .knownFor)
    }
}

