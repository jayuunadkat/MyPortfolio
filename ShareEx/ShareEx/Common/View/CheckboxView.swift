//
//  CheckboxView.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit

protocol CheckboxViewDelegate: AnyObject {
    func checkboxView(_ checkboxView: CheckboxView, didChangeState isChecked: Bool)
}

final class CheckboxView: UIView {

    weak var delegate: CheckboxViewDelegate?

    private let checkmarkImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let imageView = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: config))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private var isChecked: Bool = false {
        didSet {
            UIView.transition(with: checkmarkImageView, duration: 0.2, options: .transitionCrossDissolve) {
                self.checkmarkImageView.isHidden = !self.isChecked
            }

            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.isChecked ? .systemTeal : .clear
                self.layer.borderColor = self.isChecked ? UIColor.systemTeal.cgColor : UIColor.systemTeal.withAlphaComponent(0.8).cgColor
            }
            
            delegate?.checkboxView(self, didChangeState: isChecked)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 24, height: 24)
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.8).cgColor
        layer.borderWidth = 2
        clipsToBounds = true

        addSubview(checkmarkImageView)
        NSLayoutConstraint.activate([
            checkmarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            checkmarkImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
        ])

//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
//        addGestureRecognizer(tap)
//        isUserInteractionEnabled = true
    }

    func configure(isChecked: Bool, borderColor: UIColor = .systemTeal) {
        self.isChecked = isChecked
        layer.borderColor = borderColor.cgColor
    }

    @objc private func didTapCheckbox() {
        isChecked.toggle()
    }

    func toggle() {
        isChecked.toggle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}

/**
class CheckboxView: UIControl {

    private let checkmarkLayer = CAShapeLayer()
    private let boxLayer = CAShapeLayer()

    var isChecked: Bool = false {
        didSet {
            updateCheckmarkVisibility()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))
        setupView()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleChecked)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.addSublayer(boxLayer)
        layer.addSublayer(checkmarkLayer)

        boxLayer.fillColor = UIColor.clear.cgColor
        boxLayer.strokeColor = UIColor.systemTeal.cgColor
        boxLayer.lineWidth = 2

        checkmarkLayer.strokeColor = UIColor.systemTeal.cgColor
        checkmarkLayer.lineWidth = 2
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round

        updateCheckmarkVisibility()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let diameter = min(bounds.width, bounds.height)
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        boxLayer.path = circlePath.cgPath

        /// Draw checkmark
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: diameter * 0.3, y: diameter * 0.5))
        checkmarkPath.addLine(to: CGPoint(x: diameter * 0.45, y: diameter * 0.7))
        checkmarkPath.addLine(to: CGPoint(x: diameter * 0.75, y: diameter * 0.3))
        checkmarkLayer.path = checkmarkPath.cgPath
    }

    private func updateCheckmarkVisibility() {
        checkmarkLayer.isHidden = !isChecked
    }

    @objc private func toggleChecked() {
        isChecked.toggle()
        sendActions(for: .valueChanged)
    }
}

 final class CheckboxView: UIView {

 private let circleLayer = CAShapeLayer()
 private let checkmarkLayer = CAShapeLayer()

 var isChecked: Bool = false {
 didSet {
 updateCheckmarkVisibility()
 }
 }

 override init(frame: CGRect) {
 super.init(frame: frame)
 setupView()
 }

 required init?(coder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }

 private func setupView() {
 let size: CGFloat = 25
 self.translatesAutoresizingMaskIntoConstraints = false
 self.widthAnchor.constraint(equalToConstant: size).isActive = true
 self.heightAnchor.constraint(equalToConstant: size).isActive = true

 let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size))

 circleLayer.path = circlePath.cgPath
 circleLayer.strokeColor = UIColor.systemTeal.withAlphaComponent(0.8).cgColor
 circleLayer.fillColor = UIColor.clear.cgColor
 circleLayer.lineWidth = 2
 layer.addSublayer(circleLayer)

 checkmarkLayer.path = checkmarkPath().cgPath
 checkmarkLayer.strokeColor = UIColor.systemTeal.cgColor
 checkmarkLayer.fillColor = UIColor.clear.cgColor
 checkmarkLayer.lineWidth = 2
 checkmarkLayer.lineCap = .round
 checkmarkLayer.lineJoin = .round
 checkmarkLayer.isHidden = true
 layer.addSublayer(checkmarkLayer)
 }

 private func updateCheckmarkVisibility() {
 checkmarkLayer.isHidden = !isChecked
 }

 private func checkmarkPath() -> UIBezierPath {
 let path = UIBezierPath()
 path.move(to: CGPoint(x: 6, y: 13))
 path.addLine(to: CGPoint(x: 11, y: 18))
 path.addLine(to: CGPoint(x: 19, y: 7))
 return path
 }

 func toggle() {
 isChecked.toggle()
 }
 }

*/

/**let imageVwProfile: UIImageView = {
 let imageVw: UIImageView = UIImageView()
 imageVw.translatesAutoresizingMaskIntoConstraints = false
 imageVw.layer.cornerRadius = 20
 imageVw.clipsToBounds = true
 imageVw.contentMode = .scaleAspectFit
 imageVw.widthAnchor.constraint(equalToConstant: 40).isActive = true
 imageVw.heightAnchor.constraint(equalToConstant: 40).isActive = true

 imageVw.backgroundColor = .black
 return imageVw
 }()*/
