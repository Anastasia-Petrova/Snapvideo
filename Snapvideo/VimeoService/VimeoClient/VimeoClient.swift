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
    clientIdentifier: "", //Add your Vimeo Client Identifier
    clientSecret: "", //Add your Vimeo Client Secret
    scopes: [.Public, .Private, .Edit, .Upload],
    keychainService: "KeychainServiceVimeo"
)

let vimeoClient = VimeoClient(appConfiguration: appConfiguration, configureSessionManagerBlock: nil)

let authenticationController = AuthenticationController(
    client: vimeoClient,
    appConfiguration: appConfiguration,
    configureSessionManagerBlock: nil
)

