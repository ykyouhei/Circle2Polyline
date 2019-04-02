//
//  Circle.swift
//  Basic
//
//  Created by kyohei yamaguchi on 2019/04/02.
//

import Foundation
import CoreLocation
import Polyline

struct Circle {
    
    /// 中心座標
    let point: CLLocationCoordinate2D
    
    /// 半径(km)
    let radius: Int
    
    init(lat: Double, lng: Double, radius: Int) {
        self.point = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.radius = radius
    }

    /// Polylineを生成する
    ///
    /// - note: [参考URL](https://www.nanchatte.com/map/circle.html)
    ///
    /// - Parameter numberOfVertex: 描画する頂点数
    /// - Returns: エンコードされたPolyline
    func generatePolyline(numberOfVertex: Int) -> String {
        /// 赤道半径(m) (WGS-84)
        let equatorialRadius = 6378137.0
        
        /// 扁平率の逆数 : 1/f (WGS-84)
        let f = 298.257223
        
        /// 離心率の２乗
        let e = ((2 * f) - 1) / pow(f, 2)
        
        /// 赤道半径 × π
        let er = Double.pi * equatorialRadius
        
        /// 1 - e^2 sin^2 (θ)
        let tmp = 1 - e * pow(sin(point.latitude * Double.pi / 180), 2)

        /// 経度１度あたりの長さ(m)
        let arc_lat = (er * (1 - e)) / (180 * pow(tmp, 3 / 2))
        
        /// 緯度１度あたりの長さ(m)
        let arc_lng = (er * cos(point.longitude * Double.pi / 180)) / (180 * pow(tmp, 1 / 2))

        /// 半径をｍ単位に
        let r = Double(radius) * 1000
        
        let coordinates = (0..<numberOfVertex).map { index -> CLLocationCoordinate2D in
            let rad = (Double(index) / (Double(numberOfVertex) / 2)) * Double.pi
            let lat = (r / arc_lat) * sin(rad) + point.latitude
            let lng = (r / arc_lng) * cos(rad) + point.longitude
            return CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }

        return Polyline(coordinates: coordinates).encodedPolyline
    }
    
    
}

