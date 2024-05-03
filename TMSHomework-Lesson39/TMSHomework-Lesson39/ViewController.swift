//
//  ViewController.swift
//  TMSHomework-Lesson39
//
//  Created by Наталья Мазур on 30.04.24.
//

import UIKit
import YandexMapsMobile

class ViewController: UIViewController {

    lazy var mapView = YMKMapView(frame: CGRect(x: view.frame.minX, y: view.safeAreaLayoutGuide.layoutFrame.minY, width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.height), vulkanPreferred: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
    }
    
    func addMapView() {
        mapView!.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: 59.935493, longitude: 30.327392),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        
        view.addSubview(mapView!)
        mapView?.mapWindow.map.addInputListener(with: self)
    }
    
    func addPlacemarkOnMap(latitude: Double, longitude: Double) {
       // Задание координат точки
        let point = YMKPoint(latitude: latitude, longitude: longitude)
        let viewPlacemark: YMKPlacemarkMapObject = (mapView?.mapWindow.map.mapObjects.addPlacemark(/*with: point*/))!
        viewPlacemark.geometry = point
      // Настройка и добавление иконки
        let pinImage = UIImage(systemName: "mappin.circle.fill")?.withTintColor(.systemRed)
        viewPlacemark.setIconWith(
            pinImage!, // Убедитесь, что у вас есть иконка для точки
            style: YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 0,
                flat: true,
                visible: true,
                scale: 1.5,
                tappableArea: nil
            )
        )
        viewPlacemark.setTextWithText("My pin", style: YMKTextStyle(
            size: 10.0,
            color: .black, 
            outlineWidth: 5.0,
            outlineColor: .white,
            placement: .bottom,
            offset: 0.0,
            offsetFromIcon: true,
            textOptional: false
        ))

        viewPlacemark.addTapListener(with: self)
    }


}

extension ViewController: YMKMapInputListener {
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        
        addPlacemarkOnMap(latitude: point.latitude, longitude: point.longitude)
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        addPlacemarkOnMap(latitude: point.latitude, longitude: point.longitude)
    }
    
    
}

extension ViewController: YMKMapObjectTapListener {
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else {
            return false
        }
        
        self.focusOnPlacemark(placemark)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.mapView?.mapWindow.map.mapObjects.remove(with: placemark)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        let editButton = UIAlertAction(title: "Edit", style: .default) { action in
            
            let editAlert = UIAlertController(title: "Enter pin name", message: nil, preferredStyle: .alert)
            editAlert.addTextField { textField in
                textField.placeholder = "New name for the pin"
            }
            
            let okAction = UIAlertAction(title: "Edit", style: .default) { action in
                placemark.setTextWithText(editAlert.textFields?[0].text ?? "My pin", style: YMKTextStyle(
                    size: 10.0,
                    color: .black,
                    outlineWidth: 5.0,
                    outlineColor: .white,
                    placement: .bottom,
                    offset: 0.0,
                    offsetFromIcon: true,
                    textOptional: false
                ))
            }
            
            editAlert.addAction(okAction)
            editAlert.addAction(cancelButton)
            
            self.present(editAlert, animated: true)
        }
        
        AlertPresenter.present(
            from: self,
            with: "Tapped point",
            message: "\((point.latitude, point.longitude))",
            actions: [editButton, deleteButton, cancelButton],
            style: .actionSheet
        )
        
        
        return true
    }

    func focusOnPlacemark(_ placemark: YMKPlacemarkMapObject) {
        mapView?.mapWindow.map.move(
            with: YMKCameraPosition(target: placemark.geometry, zoom: 16, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
            cameraCallback: nil
        )
    }
    
    
}
