//
//  VimeoClient.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 18/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import VimeoNetworking

private let appConfiguration = AppConfiguration(
    clientIdentifier: "feaa04ff48eedc3e6474cf36515591cab2e4f84e",
    clientSecret: "crpqthfLxViJGIMLICoxaShxm68uEWjHsyApn5UpsKvAef/QStz1cC7lC5OIHZXzXdgNQ7OpdkMjKFwd8fAGRr4+hIg8v3FvgJXG3wRKIoMBEfYzdyzdHFVlrqMjGu1I",
    scopes: [.Public, .Upload, .Private],
    keychainService: "KeychainServiceVimeo"
)

let vimeoClient = VimeoClient(appConfiguration: appConfiguration, configureSessionManagerBlock: nil)

let authenticationController = AuthenticationController(
    client: vimeoClient,
    appConfiguration: appConfiguration,
    configureSessionManagerBlock: nil
)

