//
//  DataRepositoryFactory.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 19/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation

/// Repository factory
///
/// Creates a repository with either staging or production configuration
class DataRepositoryFactory {
    
    /// Returns the production repository
    private lazy var production: DataRepository = {
        return DataRepository(baseUrl: "https://staging.appcms.dk/api", apiKey: "BKgGGLEUrC-Iek_Z-1dJ6A")
    }()
    
    /// Returns the production repository
    private lazy var staging: DataRepository = {
        return DataRepository(baseUrl: "https://staging.appcms.dk/api", apiKey: "BKgGGLEUrC-Iek_Z-1dJ6A")
    }()
    
    //// Returns the localhost repository
    private lazy var localhost: DataRepository = {
        return DataRepository(baseUrl: "http://localhost:3000/api", apiKey: "GGGuVnFkVRaEZ-TbdoSAYw")
    }()
    
    /// Returns repository depending on build type
    func repository() -> DataRepository {
        #if DEBUG
        #if targetEnvironment(simulator)
        return self.localhost
        #else
        return self.staging
        #endif
        #else
        return self.production
        #endif
    }
}
