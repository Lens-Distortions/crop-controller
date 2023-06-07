//
//  CropDimmingView.swift
//  Mantis
//
//  Created by Echo on 10/22/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

class CropDimmingView: UIView, CropMaskProtocol {
    var overLayerFillColor: CGColor = UIColor.black.cgColor
    var cropShapeType: CropShapeType = .rect
    
    convenience init(frame: CGRect, cropShapeType: CropShapeType = .rect) {
        self.init(frame: frame)
        self.cropShapeType = cropShapeType
    }
    
    func setMask(cropRatio: CGFloat) {
        backgroundColor = .black.withAlphaComponent(0.5)
        self.mask = MaskView(frame: self.bounds)
    }
}
