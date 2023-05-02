//
//  EmailValidator.swift
//  EmailValidator
//
//  Created by JeongminKim on 2023/05/02.
//

import Foundation

public class EmailValidator {
    public static func isValidEmail(email: String) -> Bool {
        return NSPredicate(
            format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        ).evaluate(with: email)
    }
}
