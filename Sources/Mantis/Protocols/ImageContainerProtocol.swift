//
//  ImageContainerProtocol.swift
//  Mantis
//
//  Created by yingtguo on 12/15/22.
//

import UIKit
import AVFoundation

protocol ImageContainerProtocol: UIView {
    var video: AVAsset? { get set }
    var player: AVPlayer? { get set }
    
    func contains(rect: CGRect, fromView view: UIView, tolerance: CGFloat) -> Bool
    func getCropRegion(withCropBoxFrame cropBoxFrame: CGRect, cropView: UIView) -> CropRegion
}
