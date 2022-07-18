//
//  CropDimmingView.swift
//  Mantis
//
//  Created by Echo on 10/22/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

class CropDimmingView: UIView, CropMaskProtocol {
    var cropShapeType: CropShapeType = .rect
    var imageRatio: CGFloat = 1.0
    
    convenience init(frame: CGRect, cropShapeType: CropShapeType = .rect, cropRatio: CGFloat = 1.0) {
        self.init(frame: frame)
        self.cropShapeType = cropShapeType
        initialize(cropRatio: cropRatio)
    }
    
    func setMask(cropRatio: CGFloat) {
        backgroundColor = .black.withAlphaComponent(0.5)
        self.mask = MaskView(frame: self.bounds)
    }
}
