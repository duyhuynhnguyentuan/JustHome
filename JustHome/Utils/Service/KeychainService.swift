//
//  KeychainService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 3/10/24.
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    
    func save(token: String, forKey key: String) {
        let data = token.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Remove any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("DEBUG: Successfully saved token for key: \(key)")
        } else {
            print("DEBUG: Failed to save token for key: \(key). Error: \(status)")
        }
    }
    
    func retrieveToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("DEBUG: Failed to retrieve token for key: \(key). Error: \(status)")
        }
        return nil
    }
    
    func deleteToken(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
    func clearAllKeys() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("DEBUG: Successfully cleared all keys from the Keychain.")
        } else {
            print("DEBUG: Failed to clear keys. Error: \(status)")
        }
    }
}
