//
//  Lottie.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    var animationFileName: String
    let loopMode: LottieLoopMode
    var completion: ((Bool) -> Void)? = nil

    func updateUIView(_ uiView: UIViewType, context: Context) {}

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        guard let animationPath = Bundle.main.path(forResource: animationFileName, ofType: "json") else {
                   print("Animation file not found: \(animationFileName)")
                   return view
               }
        let lottieAnimationView = LottieAnimationView(name: animationFileName)
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.loopMode = .playOnce
        //lottieAnimationView.play()
        lottieAnimationView.play { finished in
                    DispatchQueue.main.async {
                        self.completion?(finished)
                    }
                }
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lottieAnimationView)
        NSLayoutConstraint.activate([
            lottieAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lottieAnimationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
}
