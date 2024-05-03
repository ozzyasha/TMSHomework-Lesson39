//
//  MapView.swift
//  TMSHomework-Lesson39
//
//  Created by Наталья Мазур on 3.05.24.
//

import UIKit
import YandexMapsMobile

class MapView: UIView {
    
    var mapView: YMKMapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let vc = ViewController()
    
    func setupMapView() {
        mapView = YMKMapView(frame: bounds, vulkanPreferred: MapView.isM1Simulator())
        
        mapView!.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: 53.907478, longitude: 27.558638),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        
//        mapView?.mapWindow.map.addInputListener(with: self)
    }
    
    static func isM1Simulator() -> Bool {
        return (TARGET_IPHONE_SIMULATOR & TARGET_CPU_ARM64) != 0
    }
    
    
}




