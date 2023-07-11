//
//  APICaller.swift
//  CombineIntro
//
//  Created by Seher Aytekin on 7/10/23.
//

import Foundation
import Combine

class APICaller {
    static let shared = APICaller()
    
    func fetchCompanies() -> Future<[String], Error> {
        return Future { promixe in
            promixe(.success(["Apple", "Google", "Microsoft", "Facebook"]))
        }
    }
}
