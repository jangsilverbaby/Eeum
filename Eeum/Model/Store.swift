//
//  Store.swift
//  Eeum
//
//  Created by eunae on 2022/10/14.
//

struct Store {
    var category: Category
    var locality: Locality
    var discount: String
    var cashback: Bool
    var name: String
    var address: String
    var longitude: Double
    var latitude: Double
}

enum Category {
    case cafe
    case restorant
    case tour
    case sports
}

enum Locality {
    case junggu
    case donggu
    case seogu
}
