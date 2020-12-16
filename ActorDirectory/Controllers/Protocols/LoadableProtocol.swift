//
//  LoadableProtocol.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import Foundation

/**
 A class that conforms to the `Loadable` protocol
 must implement the following methods marking the
 the start, end, and error states of loading data.
 */
protocol Loadable {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showErrorIndicator(error: Error)
}

