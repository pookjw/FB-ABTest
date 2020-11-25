//
//  EventTestObject.swift
//  FB-ABTest
//
//  Created by Jinwoo Kim on 11/26/20.
//

import Foundation
import ObjectMapper

class EventTestObject: Mappable {
    var value: String?
    
    required init?(map: Map) { }
    
    init(value: String) {
        self.value = value
    }
    
    func mapping(map: Map) {
        value <- map["value"]
    }
}
