//
//  UserDefaultsStored.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 4.12.2023.
//

import Foundation

struct MFUserDefaults {
    
    @UserDefaultsStoredObject<[Article]>(key: .article)
    static var article: [Article]?
}
extension MFUserDefaults {
    @propertyWrapper
    struct UserDefaultsStoredObject<Value: Codable> {
        fileprivate enum UserDefaultsKey: String {
            case article
        }

        fileprivate let key: UserDefaultsKey

        var wrappedValue: Value? {
            get {
                do {
                    if let data = UserDefaults.standard.data(forKey: key.rawValue) {
                        return try JSONDecoder().decode(Value.self, from: data)
                    }

                    return nil
                } catch {
                    return nil
                }
            }
            set {
                do {
                    if let newValue = newValue {
                        let data = try JSONEncoder().encode(newValue)
                        UserDefaults.standard.set(data, forKey: key.rawValue)
                    } else {
                        UserDefaults.standard.removeObject(forKey: key.rawValue)
                    }
                } catch {
                    UserDefaults.standard.removeObject(forKey: key.rawValue)
                }
            }
        }
    }
}


//UserDefaults.standard.set(value: Any?, forKey: String)

