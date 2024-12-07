//
//  Regions.swift
//  AirbnbSwiftUI
//
//  Created by 김정민 on 10/19/24.
//

import CoreLocation

extension CLLocationCoordinate2D {
    static var seoul = CLLocationCoordinate2D(
        latitude: 37.566535,
        longitude: 126.9779692
    )
    static var miami = CLLocationCoordinate2D(
        latitude: 25.7602,
        longitude: -80.1959
    )
    
    func regionForCity(_ name: String) -> CLLocationCoordinate2D {
        switch name {
        case "Seoul":
            return .seoul
        case "Miami":
            return .miami
        default:
            return .seoul
        }
    }
}
