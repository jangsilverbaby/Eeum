//
//  Store.swift
//  Eeum
//
//  Created by eunae on 2022/10/14.
//

struct Store {
    var category: Category
    var district: District
    var discount: String
    var cashback: Bool
    var name: String
    var address: String
    var longtitude: Double
    var latitude: Double
}

enum Category {
    case cafe
    case restorant
    case beauty
    case tour
    case sports
}

enum District {
    case junggu
    case donggu
    case seogu
}
