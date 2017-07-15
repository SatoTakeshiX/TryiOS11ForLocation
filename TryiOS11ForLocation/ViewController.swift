//
//  ViewController.swift
//  TryiOS11ForLocation
//
//  Created by satoutakeshi on 2017/07/13.
//  Copyright © 2017年 takeshi sato. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    let locationManager = CLLocationManager.init()
    
    var statusString : String = "状態" {
        didSet {
            self.statusLabel.text = statusString
        }
    }
    var resultString : String = "" {
        didSet {
            self.textView.text = resultString
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionForWhenInUse(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func actionForAlways(_ sender: UIButton) {
        locationManager.requestAlwaysAuthorization()
    }
    @IBAction func startLocation(_ sender: UIButton) {
        
        //現状の認証を確認する
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            //認証は常に許可
            if !CLLocationManager.locationServicesEnabled() {
                //使えるかをこのメソッドでも確認してから実行
                return
            }
            self.start()
            break
        case .authorizedWhenInUse:
            //認証は一時許可
            //常に許可をユーザーに問い合わせる
            self.locationManager.requestAlwaysAuthorization()
            break
        case .denied:
            //ユーザーから許可されていない。
            break
        case .notDetermined:
            //一度も認証を問われていない
            //一時許可をユーザーに問い合わせる
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //ペアレントコントロールなどで制限されている
            print("エラー:restricted")
            break
            
        }
        
    }

    @IBAction func stopLocation(_ sender: UIButton) {
        
        stop()
    }
    
    func start(){
        self.locationManager.allowsBackgroundLocationUpdates = true //バックグラウンドでも更新が続くようにする
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //精度は最強
        self.locationManager.startUpdatingLocation() //開始
    }
    
    func stop(){
        self.textView.text = ""
        self.locationManager.stopUpdatingHeading()
    }
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            self.statusString = "Always"
            break
        case .authorizedWhenInUse:
            self.statusString = "When in Use"
            break
        case .denied:
            self.statusString = "Denied"
            break
        case .notDetermined:
            self.statusString = "not Determined"
            break
        case .restricted:
            self.statusString = "restricted"
            break
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("やっほー \(locations.count)")
        if let location = locations.first {
            
            if self.resultString.isEmpty {
                self.resultString = "緯度:\(String(location.coordinate.latitude)),経度:\(String(location.coordinate.longitude))"
            } else {
                self.resultString = self.resultString +  "\n緯度:\(String(location.coordinate.latitude)),経度:\(String(location.coordinate.longitude))"
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.resultString = error.localizedDescription
    }
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        if let error = error {
            self.resultString = error.localizedDescription
        }
    }
    
}

