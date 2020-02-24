//
//  UserRepository.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 19/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol UserRepository {
    func createUser(name: String,
                    email: String,
                    password: String) -> Observable<UserModel>
    func validateUser(_ user: UserModel) -> Observable<UserModel>
    func login(email: String, password: String) -> Observable<UserModel>
    func login(appleIdentifier: String, jwt: String, fullName: String) -> Observable<UserModel>
    func login(facebookToken: String) -> Observable<UserModel>
    
    func updateUser(_ name: String, new_password: String?) -> Observable<UserModel>
    
    func setAuthorizedUser(_ user: DataRepositoryAuthorizationEntity?)
}

extension DataRepository: UserRepository {
    
    func setAuthorizedUser(_ user: DataRepositoryAuthorizationEntity?) {
        self.authorizationEntity = user
    }
    
    func updateUser(_ name: String, new_password: String?) -> Observable<UserModel> {
        var params: [String: Any] = [:]
        params["name"] = name
        
        if new_password != nil {
            params["new_password"] = new_password!
        }
        
        let request = DataRepositoryRequest<UserModel>(method: .patch,
                                                       endpoint: "app-memberships",
                                                       params: ["user": params],
                                                       authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (users) -> Observable<UserModel> in
            return Observable<UserModel>.of(users.first!)
        }
    }
    
    func updateAvatar(_ newImage: UIImage) -> Observable<UserModel> {
        
        let scaledImage = newImage.sd_resizedImage(with: CGSize(width: 800, height: 600), scaleMode: .aspectFill)
        
        let multipartData = Alamofire.MultipartFormData()
        multipartData.append(scaledImage!.pngData()!, withName: "user[avatar]", fileName: "image.png")
        
        let request = DataRepositoryRequest<UserModel>(method: .patch,
                                                       endpoint: "app-memberships",
                                                       params: nil,
                                                       authorizationNeeded: true,
                                                       multipartData: multipartData)
        
        return self.performRequest(request).flatMap { (users) -> Observable<UserModel> in
            return Observable<UserModel>.of(users.first!)
        }
    }
    
    func createUser(name: String, email: String, password: String) -> Observable<UserModel> {
        
        var params: [String: Any] = [:]
        params["name"] = name
        params["email"] = email
        params["password"] = password
        
        let request = DataRepositoryRequest<UserModel>(method: .post,
                                                       endpoint: "app-memberships",
                                                       params: ["user": params])
        
        return self.performRequest(request).flatMap { (users) -> Observable<UserModel> in
            return Observable<UserModel>.of(users.first!)
        }
    }
    
    func validateUser(_ user: UserModel) -> Observable<UserModel> {
        
        let request = DataRepositoryRequest<UserModel>(method: .post,
                                                       endpoint: "app-memberships/validate",
                                                       params: nil,
                                                       authorizationNeeded: true)

        return self.performRequest(request).flatMap { (users) -> Observable<UserModel> in
            return Observable<UserModel>.of(users.first!)
        }
    }
    
    func login(email: String, password: String) -> Observable<UserModel> {
      
        var params: [String: Any] = [:]
        params["email"] = email
        params["password"] = password
        
        let request = DataRepositoryRequest<UserModel>(method: .post,
                                                       endpoint: "app-memberships/authenticate/basic",
                                                       params: ["user": params])
        
        return self.performRequest(request).flatMap { (users) -> Observable<UserModel> in
            return Observable<UserModel>.of(users.first!)
        }
    }
    
    func login(appleIdentifier: String, jwt: String, fullName: String) -> Observable<UserModel> {
        var params: [String: Any] = [:]
        params["userIdentity"] = appleIdentifier
        params["jwt"] = jwt
        params["name"] = fullName
        
        let request = DataRepositoryRequest<UserModel>(method: .post,
                                                       endpoint: "app-memberships/authenticate/apple",
                                                       params: ["apple": params])
        
        return self.performRequest(request).flatMap { (users) -> Observable<UserModel> in
            return Observable<UserModel>.of(users.first!)
        }
    }
    
    func login(facebookToken: String) -> Observable<UserModel> {
        var params: [String: Any] = [:]
        params["access_token"] = facebookToken
        
        let request = DataRepositoryRequest<UserModel>(method: .post,
                                                       endpoint: "app-memberships/authenticate/facebook",
                                                       params: ["facebook": params])
        
        return self.performRequest(request).flatMap { (users) -> Observable<UserModel> in
            return Observable<UserModel>.of(users.first!)
        }
    }
    
    func mockedUserCall() -> Observable<UserModel> {
        return createUser(name: "Rasmus", email: "styrken@gmail.com", password: "specail+")
    }
    
    
}
