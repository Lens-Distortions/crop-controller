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

    lazy private var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.layer.minificationFilter = .trilinear
        imageView.accessibilityIgnoresInvertColors = true
        imageView.contentMode = .scaleAspectFit

        addSubview(imageView)

        return imageView
    }()

    var image: UIImage? {
        didSet {
            imageView.frame = bounds
            imageView.image = image

            imageView.isUserInteractionEnabled = true
        }
    }

    lazy private var videoView: LDVideoView = {
        let videoView = LDVideoView(frame: bounds)
        insertSubview(videoView, aboveSubview: imageView)
        return videoView
    }()

    public var player: AVPlayer?
    private var videoLooper: AVPlayerLooper?

    var video: URL? {
        didSet {
            if let video {
                // set up looping video player
                let item = AVPlayerItem(url: video)
                let player = AVQueuePlayer(playerItem: item)
                videoLooper = AVPlayerLooper(player: player, templateItem: item)
                videoView.player = player
                videoView.playerLayer.videoGravity = .resizeAspect
                self.player = player
            } else {
                videoView.player?.rate = 0
                videoView.player = nil
                videoLooper = nil
                videoView.removeFromSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds

        if video != nil {
            videoView.frame = bounds
        }
    }
    
    func contains(rect: CGRect, fromView view: UIView, tolerance: CGFloat = 1e-6) -> Bool {
        let newRect = view.convert(rect, to: self)
        
        let point1 = newRect.origin
        let point2 = CGPoint(x: newRect.maxX, y: newRect.maxY)
        
        let refBounds = bounds.insetBy(dx: -tolerance, dy: -tolerance)
        
        return refBounds.contains(point1) && refBounds.contains(point2)
    }
}
