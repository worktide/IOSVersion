//
//  CLLocationCoordiante2DExtension.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-15.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//
import MapKit

extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
