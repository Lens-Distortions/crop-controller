//
// Created by Allen Gilbert on 7/18/22.
//

import UIKit

extension CAPropertyAnimation {
    /// Creates a copy of the receiver with the `keyPath` set to the given value.
    /// - Parameter keyPath: The value of the returned animation's `keyPath`.
    /// - Returns An animation identical to the receiver with the given `keyPath`.
    func copy(withKeyPath keyPath: String) -> Self {
        guard let copy = self.copy() as? Self else {
            fatalError("copy(withKeyPath:) failed to copy self")
        }
        copy.keyPath = keyPath
        return copy
    }
}

class MaskView: UIView {
    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    var oldShapeLayerPath: CGPath?

    var cropRect: CGRect = .zero {
        didSet {
            guard let shapeLayer = layer as? CAShapeLayer else { return }
            let newPath = getPath(cropRect: cropRect)
            shapeLayer.path = newPath
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        UIColor.clear.setFill()
        // the insets here are arbitrary: path will be properly configured when cropRect is set
        let path = getPath(cropRect: frame.insetBy(dx: 10, dy: 10))

        guard let shapeLayer = layer as? CAShapeLayer else {
            fatalError("layer is not a CAShapeLayer")
        }
        shapeLayer.path = path
        shapeLayer.fillRule = .evenOdd
        // any opaque color works here
        shapeLayer.fillColor = UIColor.white.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // TODO: reimplement support for non-rectangular paths
    private func getPath(cropRect: CGRect) -> CGPath {
        let path = UIBezierPath(rect: cropRect)
        path.append(UIBezierPath(rect: bounds))
        path.usesEvenOddFillRule = true
        return path.cgPath
    }

    func prepareForAnimatedCropRectChange() {
        guard let shapeLayer = layer as? CAShapeLayer else { return }
        oldShapeLayerPath = shapeLayer.path
    }

    func animateToNewCropRect() {
        guard let oldShapeLayerPath, let shapeLayer = layer as? CAShapeLayer else { return }
        let newPath = getPath(cropRect: cropRect)

        // implicit animations can be retrieved via one of many standard, longstanding view property keys
        if let currentAnimation = action(for: layer, forKey: "backgroundColor") as? CABasicAnimation {
            let pathAnimation = currentAnimation.copy(withKeyPath: "path")
            pathAnimation.fromValue = oldShapeLayerPath
            pathAnimation.toValue = newPath
            layer.add(pathAnimation, forKey: "pathAnimation")
        }

        shapeLayer.path = newPath
    }
}
