//
//  NetworkingServiceTests.swift
//  ActorDirectoryTests
//
//  Created by Nadia Barbosa on 12/15/20.
//

import XCTest
@testable import ActorDirectory

class NetworkingServiceTests: XCTestCase {

    func testRequestExecutionWithInvalidPath() {
        let expectation = XCTestExpectation(description: "Execute request with invalid URL string.")

        var expectedResult: Result<Directory, NetworkServiceError>?

        let invalidPath = RoutingPath.custom("")

        NetworkService.executeRequest(for: invalidPath) { ( result ) in
            expectedResult = result
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)

        guard let result = expectedResult else {
            XCTFail("Expected result from request execution.")
            return
        }

        switch result {
        case .success(_):
            XCTFail("Request should not succeed with bad URL.")
        case .failure(let error):
            guard case NetworkServiceError.networkRequestFailed(_) = error else {
                XCTFail("Route construction error not returned.")
                return
            }
        }
    }

    func testRequestExecutionWithInvalidURL() {
        let expectation = XCTestExpectation(description: "Execute request with invalid URL string.")

        var expectedResult: Result<Directory, NetworkServiceError>?

        let invalidPath = RoutingPath.custom("httpz://")

        NetworkService.executeRequest(for: invalidPath) { ( result ) in
            expectedResult = result
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

        guard let result = expectedResult else {
            XCTFail("Expected result from request execution.")
            return
        }

        switch result {
        case .success(_):
            XCTFail("Request should not succeed.")
        case .failure(let error):
            guard case NetworkServiceError.networkRequestFailed = error else {
                XCTFail("Network request error was not returned.")
                return
            }
        }
    }

    func testParseInvalidJSON() {
        let url = loadFixtureData(fileName: "actors_malformed")

        let json = try! Data(contentsOf: url)

        XCTAssertThrowsError(try NetworkService.parseResponse(data: json).get(), "parsing should fail") { (error) in
            guard case NetworkServiceError.decodingFailed = error else {
                XCTFail("Network request error was not returned.")
                return
            }
        }
    }

    func testParseValidJSON() {
        let url = loadFixtureData(fileName: "actors")

        let json = try! Data(contentsOf: url)

        guard let directory = try? NetworkService.parseResponse(data: json).get() else {
            XCTFail("Should succeed")
            return
        }

        guard let actor = directory.actors.first else {
            XCTFail("No actors found in fixture data.")
            return
        }

        let expectedIdentifier = UUID(uuidString: "AC76485E-DD85-427E-BB82-538340548FEC")
        let expectedName = "Abbi Jacobson"
        let expectedPhone = "123-456-8991"
        let expectedEmail = "abbi@jacobson.com"
        let expectedPhoto = URL(string: "https://upload.wikimedia.org/wikipedia/commons/7/76/Abbi_Jacobson_at_2015_PaleyFest.jpg")
        let expectedKnownFor = "Broad City"


        XCTAssertEqual(expectedIdentifier, actor.identifier)
        XCTAssertEqual(expectedName, actor.fullName)
        XCTAssertEqual(expectedPhone, actor.phoneNumber)
        XCTAssertEqual(expectedEmail, actor.email)
        XCTAssertEqual(expectedPhoto, actor.photo)
        XCTAssertEqual(expectedKnownFor, actor.knownFor)
    }

    func testParseOptionalFields() {
        let url = loadFixtureData(fileName: "actors_optional_fields")
        let json = try! Data(contentsOf: url)

        guard let directory = try? NetworkService.parseResponse(data: json).get() else {
            XCTFail("Should succeed")
            return
        }

        guard let actor = directory.actors.first else {
            XCTFail("No actors found in fixture data.")
            return
        }

        XCTAssertNil(actor.phoneNumber)
        XCTAssertNil(actor.photo)
    }
}

extension NetworkingServiceTests {
    func loadFixtureData(fileName: String) -> URL {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            preconditionFailure("Missing fixture: \(fileName)")
        }

        return url
    }
}

