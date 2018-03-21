//
//  UserPresenter.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 21/3/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import Foundation
import RxSwift

protocol UserVCP {
    func retrieveExistingTokens() -> Tokens
}

class UserVCPresenterImplementation: UserVCP {
    var userDTO:Variable<UserDTO>
    var userModel:UserModel
    
    init(withUserModel userModel:UserModel) {
        self.userModel = userModel
        userDTO = Variable<UserDTO>(UserDTO(with: "", email: "", firstname: "", lastname: ""))
    }
    
    func retrieveExistingTokens() -> Tokens{
        let tokens:Tokens = ("","")
        return tokens
    }
    
    func retrieveUserProfile(withAccessToken accessToken:String){
        
    }
    
    
}

// MARK: - Setup Observables
extension UserVCPresenterImplementation {
    func setupObservable() {
        
    }
    
    func updateUserProfile(with userDTO:UserDTO) {
        self.userDTO.value = userDTO
    }
}
