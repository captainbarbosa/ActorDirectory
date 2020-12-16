//
//  NetworkingService.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import Foundation

// MARK: - Network service errors
enum NetworkServiceError: Error {
    // The network request failed.
    case networkRequestFailed(Error?)
    // Decoding the network response data failed.
    case decodingFailed(Error?)
}

extension NetworkServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkRequestFailed(let error as URLError) where error.code == URLError.notConnectedToInternet:
            return NSLocalizedString("Not connected to the internet.", comment: error.localizedDescription)
        case .networkRequestFailed(let error):
            return NSLocalizedString("The network request failed.", comment: error?.localizedDescription ?? "")
        case .decodingFailed(let error):
            return NSLocalizedString("Data was recieved, but could not be displayed.", comment: error?.localizedDescription ?? "")
        }
    }
}

// MARK: - Network endpoints
enum RoutingPath {
    // The production endpoint to use.
    case actorsProduction
    
    // The local testing endpoint to use.
    case actorsStaging
    /**
     A custom endpoint used for testing purposes.
     Helpful for testing error states.
     */
    case custom(String)
}

/**
 Conformers to the `Path` protocol must implement
 the `path` property.
 */
protocol Path {
    var path : String { get }
}

/**
 Extend the `RoutingPath` enumeration to conform to `Path`
 in order to return the string value associated with each case.
 */
extension RoutingPath: Path {
    var path: String {
        switch self {
        case .actorsProduction:
            return "https://gist.githubusercontent.com/captainbarbosa/292afcaab0791a7b7944756326cf906f/raw/33753e18fd94e2e62ac6d564f31bbc6d854b68dd/actor-directory.json"
        case .actorsStaging:
            return Bundle.main.path(forResource: "actors", ofType: "json")!
        case .custom(let pathString):
            return pathString
        }
    }
}

/**
 The `NetworkService` object is responsible for executing network
 requests and parsing responses.
 */
struct NetworkService {
    /**
     Makes a request to the specified API endpoint, executing a completion handler
     when finished.

     - Parameter path: The conforming `Path` type where the request should be sent to.
     - Parameter completion: The block that should be executed when the request succeeds or fails.
     */
    static func executeRequest(for route: RoutingPath, completion: @escaping (Result<Directory, NetworkServiceError>) -> Void) {
        
        // If the path is local, pull the JSON from
        // the app's bundle.
        if case RoutingPath.actorsStaging = route {

            let url = URL(fileURLWithPath: route.path)
            
            guard let json = try? Data(contentsOf: url) else {
                completion(.failure(.decodingFailed(nil)))
                return
            }
            
            switch parseResponse(data: json) {
            case .success(let directory):
                completion(.success(directory))
            case .failure(let error):
                completion(.failure(error))
            }
            
            return
        }

        /**
         If the URL couldn't be constructed from the input string, return
         an early error.
         */
        guard let url = URL(string: route.path) else {
            return completion(.failure(NetworkServiceError.networkRequestFailed(nil)))
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            // Return an error if the network request fails.
            if let error = error {
                completion(.failure(NetworkServiceError.networkRequestFailed(error)))
            }

            // Attempt to parse the resulting data, handling errors if necessary.
            if let data = data {
                switch parseResponse(data: data) {
                case .success(let directory):
                    completion(.success(directory))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    /**
     Parses the response from a successful network success.

     - Parameter data: The `Data` object that should be parsed.
     - Returns: A `Result` type containing the parsed data object if successful,
                otherwise returning a decoding error if the parsing failed.
     */
    static func parseResponse(data: Data) -> Result<Directory, NetworkServiceError> {
        do {
            let directory = try JSONDecoder().decode(Directory.self, from: data)
            return .success(directory)
        } catch (let error) {
            return .failure(NetworkServiceError.decodingFailed(error))
        }
    }
}
