//
//  FormUtilities.swift
//  Replay
//
//  Created by Aayush Bhagat on 7/27/22.
//

import Foundation


class FormUtilities{
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
