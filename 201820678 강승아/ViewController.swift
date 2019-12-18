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
    var myadData = [adData]()
    
    var dlat = ""
    var dlng = ""
    var dtitle = ""
    
    // 현재의 tag를 저장
    var currentElement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var pin = [MKAnnotation]()
        
        // optional binding nil check
        if let path = Bundle.main.url(forResource: "data1", withExtension: "xml") {
            // 파싱 시작
            if let myParser = XMLParser(contentsOf: path) {
                // delegate를 ViewController와 연결
                myParser.delegate = self
                
                if myParser.parse() {
                    print("파싱 성공")
                    
                    for i in 0 ..< myadData.count {
                        let pins = MKPointAnnotation()
                        pins.coordinate.latitude = Double(myadData[i].lat)!
                        pins.coordinate.longitude = Double(myadData[i].lat)!
                        pins.title = myadData[i].title
                        pin.append(pins)
                        
                        //문제 1
                        print("lat : " + myadData[i].lat, "lng : " + myadData[i].lng, "title : " + myadData[i].title )
                    }
                    myMap.showAnnotations(pin, animated: true)
                } else {
                    print("파싱 실패")
                }
                
            } else {
                print("파싱 오류 발생")
            }
            
        } else {
            print("xml file not found")
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
            case "lat" : dlat = data
            case "lng" : dlng = data
            case "title" : dtitle = data
            default : break
            }
        }
    }
    
    //3. tag가 끝날때 실행(/tag)
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = adData()
            myItem.lat = dlat
            myItem.lng = dlng
            myItem.title = dtitle
            myadData.append(myItem)
        }
    }
    
    
    
}
