//
//  ViewController.swift
//  TMSHomework-Lesson39
//
//  Created by Наталья Мазур on 30.04.24.
//

import UIKit
import YandexMapsMobile

protocol ViewDelegate: AnyObject {
    func receiveView(view: UIView)
}

class ViewController: UIViewController {
  
    lazy var mapView: YMKMapView = MapView().mapView
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        setupMapViewConstraints()
        mapView.mapWindow.map.addInputListener(with: self)
    }
    
    private func setupMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func addPlacemarkOnMap(latitude: Double, longitude: Double) {
       
        let point = YMKPoint(latitude: latitude, longitude: longitude)
        let viewPlacemark: YMKPlacemarkMapObject = (mapView.mapWindow.map.mapObjects.addPlacemark())
        viewPlacemark.geometry = point
      
        let pinImage = UIImage(systemName: "mappin.circle.fill")

        viewPlacemark.setIconWith(
            pinImage!,
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
        createPin(on: point)
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        createPin(on: point)
    }
    
    private func createPin(on point: YMKPoint) {
        let okButton = UIAlertAction(title: "Create", style: .default) { action in
            self.addPlacemarkOnMap(latitude: point.latitude, longitude: point.longitude)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        AlertPresenter.present(
            from: self,
            with: "Create new point?",
            message: "\((point.latitude, point.longitude))",
            actions: [okButton, cancelButton],
            style: .actionSheet
        )
    }
    
}

extension ViewController: YMKMapObjectTapListener {
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else {
            return false
        }
        
        self.focusOnPlacemark(placemark)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.mapView.mapWindow.map.mapObjects.remove(with: placemark)
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

    private func focusOnPlacemark(_ placemark: YMKPlacemarkMapObject) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: placemark.geometry, zoom: 18, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
            cameraCallback: nil
        )
    }
    
    
}





