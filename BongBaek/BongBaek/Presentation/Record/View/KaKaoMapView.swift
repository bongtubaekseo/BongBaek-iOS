//
//  KaKaoMapView.swift
//  BongBaek
//
//  Created by 임재현 on 7/9/25.
//

import SwiftUI
import KakaoMapsSDK

final class KakaoMapCoordinator: NSObject, MapControllerDelegate {
    
    var controller: KMController?
    var first: Bool = true
    
    var userMapPoint: MapPoint? = MapPoint(longitude: 128.8784972, latitude:  37.74913611)
    
    override init() {
        super.init()
    }
    
    func createController(_ view: KMViewContainer) {
        controller = KMController(viewContainer: view)
        controller?.delegate = self
    }
    
    func addViews() {
        let mapviewInfo: MapviewInfo = MapviewInfo(
            viewName: "mapview",
            viewInfoName: "map",
            defaultPosition: self.userMapPoint,
            defaultLevel: 16
        )
        
        guard let controller else {
            return
        }
        

        controller.addView(mapviewInfo)
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {

        
        guard let mapView = controller?.getView(viewName) as? KakaoMap else {

            return
        }
        
        mapView.setGestureEnable(type: .doubleTapZoomIn, enable: false)      // 더블탭 줌인
        mapView.setGestureEnable(type: .twoFingerTapZoomOut, enable: false)  // 투핑거 싱글탭 줌아웃
        mapView.setGestureEnable(type: .pan, enable: false)                  // 패닝 (드래그 이동)
        mapView.setGestureEnable(type: .rotate, enable: false)               // 회전
        mapView.setGestureEnable(type: .zoom, enable: false)                 // 줌
        mapView.setGestureEnable(type: .tilt, enable: false)                 // 틸트
        mapView.setGestureEnable(type: .longTapAndDrag, enable: false)       // 롱탭 후 드래그
        mapView.setGestureEnable(type: .rotateZoom, enable: false)           // 동시 회전 및 줌
        mapView.setGestureEnable(type: .oneFingerZoom, enable: false)
        
        
        createLabelLayer()
        createPois()
    }
    
    func addViewFailed(_ viewName: String, viewInfoName: String) {

    }
    
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
        if first,
           let userMapPoint = userMapPoint {
            let cameraUpdate: CameraUpdate = CameraUpdate.make(
                target: userMapPoint,
                zoomLevel: 50, mapView: mapView!
            )
            mapView?.moveCamera(cameraUpdate)
            first = false
        }
    }
    
    func createLabelLayer() {
        let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
        let manager = mapView?.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        let _ = manager?.addLabelLayer(option: layerOption)
    }
    
    // Poi 표시 스타일 생성
      func createPoiStyle() {
          let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
          let manager = mapView?.getLabelManager()
          
          // PoiBadge는 스타일에도 추가될 수 있다. 이렇게 추가된 Badge는 해당 스타일이 적용될 때 함께 그려진다.
          let noti1 = PoiBadge(badgeID: "badge1", image: UIImage(named: "noti.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
          let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [noti1])
          let noti2 = PoiBadge(badgeID: "badge2", image: UIImage(named: "noti2.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
          let iconStyle2 = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [noti2])
      
          // 5~11, 12~21 에 표출될 스타일을 지정한다.
          let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
              PerLevelPoiStyle(iconStyle: iconStyle1, level: 5),
              PerLevelPoiStyle(iconStyle: iconStyle2, level: 12)
          ])
          manager?.addPoiStyle(poiStyle)
      }

    
    func createPois() {
        guard let mapView = controller?.getView("mapview") as? KakaoMap else {
            return
        }
        
        let manager = mapView.getLabelManager()
        
        // 1. 먼저 레이어 생성
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let layer = manager.addLabelLayer(option: layerOption)
        
        // 2. 그 다음 스타일 생성 및 등록
        guard let originalImage = UIImage(named: "icon_flag"),
              let pngData = originalImage.pngData(),
              let safeImage = UIImage(data: pngData) else {
            print("이미지 로드 실패")
            return
        }
        
        let resizedImage = safeImage.resized(to: CGSize(width: 100, height: 100))
        let tintedImage = resizedImage?.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        if let finalImage = tintedImage {
            let iconStyle = PoiIconStyle(symbol: finalImage, anchorPoint: CGPoint(x: 0.5, y: 1.0))
            let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
                PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
            ])
            manager.addPoiStyle(poiStyle)
            
            // 3. 마지막에 POI 생성
            let poiOption = PoiOptions(styleID: "PerLevelStyle")
            let poi1 = layer?.addPoi(option: poiOption, at: userMapPoint!)
            poi1?.show()
        }
    }
    
}


struct KakaoMapView: UIViewRepresentable {
    
    @Binding var draw: Bool
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)
        context.coordinator.controller?.prepareEngine()
        
        return view
    }
    
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                context.coordinator.controller?.activateEngine()
                context.coordinator.controller?.prepareEngine()
            }
        } else {
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator()
    }
    
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
}


struct MapView: View {
    
    @State var draw: Bool = true
    var body: some View {
        VStack {
            KakaoMapView(draw: $draw)
            .onAppear {
                self.draw = true
            }.onDisappear {
                self.draw = false
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

