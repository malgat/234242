//
//  ViewController.swift
//  201820678 강승아
//
//  Created by D7703_16 on 2019. 12. 18..
//  Copyright © 2019년 D7703_16. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, XMLParserDelegate, MKMapViewDelegate {
    @IBOutlet weak var myMap: MKMapView!
    
    // 데이터 클래스 객체 배열
    var myadData = [data2]()
    
    var dlat = ""
    var daddr = ""
    var dtitle = ""
    
    // 현재의 tag를 저장
    var currentElement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var pin = [MKAnnotation]()
        
        // optional binding nil check
        if let path = Bundle.main.url(forResource: "data2", withExtension: "xml") {
            // 파싱 시작
            if let myParser = XMLParser(contentsOf: path) {
                // delegate를 ViewController와 연결
                myParser.delegate = self
                myMap.delegate = self
                
                if myParser.parse() {
                    print("파싱 성공")
                    
                    for i in 0 ..< myadData.count {
                                let address = myadData[i].addr
                                let title = myadData[i].title
                                let geoCoder = CLGeocoder()

                        geoCoder.geocodeAddressString(address , completionHandler: { placemarks, error in
                                    if error != nil {
                                        print(error!)
                                        return
                                    }
                                    
                                    if let myPlacemarks = placemarks {
                                        let myPlacemark = myPlacemarks[0]
                                        
                                        let anno = MKPointAnnotation()
                                        anno.title = title
                                        
                                        if let myLocation = myPlacemark.location {
                                            anno.coordinate = myLocation.coordinate
                                            pin.append(anno)
                                        }
                                
                                    }
                                    
                                    self.myMap.showAnnotations(pin, animated: true)
                                    self.myMap.addAnnotations(pin)
                                } )
                            }
                            
                        } else {
                            print("dContents의 값은 nil")
                        }
                        
                    }
                    else {
                    print("파싱 실패")
                }
                
            } else {
                print("파싱 오류 발생")
            }
        
    }

    // XML Parser delegate 메소드
    // 1. tag(element)를 만나면 실행
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    //2. tag 다음에 문자열을 만날때 실행
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 공백 등 제거
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            switch currentElement {
            case "addr" : daddr = data
            case "title" : dtitle = data
            default : break
            }
        }
    }
    
    //3. tag가 끝날때 실행(/tag)
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = data2()
            myItem.addr = daddr
            myItem.title = dtitle
            myadData.append(myItem)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // pin의 재활용
        let identifier = "RE"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        // 재활용할 pin이 없으면 pin 생성
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            //annotationView?.pinTintColor = UIColor.blue   // pin 색깔 변경
            annotationView?.animatesDrop = true
            
            // 오른쪽 : 상세정보 버튼
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView!.annotation = annotation
        }
        
        // pin색깔 변경
        if annotation.title! == "동의과학대학교"  {
            annotationView?.pinTintColor = UIColor.red
        } else if annotation.title! == "부산시민공원" {
            annotationView?.pinTintColor = UIColor.green
        }

        else {
            annotationView?.pinTintColor = UIColor.yellow
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // 알림창 객체 생성
        let alert = UIAlertController(title: ((view.annotation?.title)!), message: ((view.annotation?.subtitle)!), preferredStyle: .alert)
        // 확인 버튼
        let ok = UIAlertAction(title:"확인", style: .default)
        // 버튼을 컨트롤러에 등록
        alert.addAction(ok)
        // 알림창 실행
        self.present(alert, animated: false)
        
    }
}
    
    

