//
//  ImageContainer.swift
//  Mantis
//
//  Created by Echo on 10/29/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit
import AVFoundation

private class LDVideoView: UIView {

    override static var layerClass: AnyClass { AVPlayerLayer.self }

    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

class ImageContainer: UIView {

//    lazy private var imageView: UIImageView = {
//        let imageView = UIImageView(frame: bounds)
//        imageView.layer.minificationFilter = .trilinear
//        imageView.accessibilityIgnoresInvertColors = true
//        imageView.contentMode = .scaleAspectFit
//
////        addSubview(imageView)
//
//        return imageView
//    }()

    lazy private var videoView: LDVideoView = {
        let videoView = LDVideoView(frame: bounds)
        addSubview(videoView)
        return videoView
    }()

    var image: UIImage? {
        didSet {
//            imageView.frame = bounds
//            imageView.image = image
//
//            imageView.isUserInteractionEnabled = true
        }
    }

    var video: URL? {
        didSet {
            if let video {
                let player = AVPlayer(url: video)
                player.isMuted = true // TODO: set per current user preference
                player.actionAtItemEnd = .none
                videoView.player = player
            } else {
                videoView.player?.rate = 0
                videoView.player = nil
                // TODO: tear down other things?
                videoView.removeFromSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        imageView.frame = bounds
        videoView.frame = bounds
    }
    
    func contains(rect: CGRect, fromView view: UIView, tolerance: CGFloat = 1e-6) -> Bool {
        let newRect = view.convert(rect, to: self)
        
        let point1 = newRect.origin
        let point2 = CGPoint(x: newRect.maxX, y: newRect.maxY)
        
        let refBounds = bounds.insetBy(dx: -tolerance, dy: -tolerance)
        
        return refBounds.contains(point1) && refBounds.contains(point2)
    }
}
