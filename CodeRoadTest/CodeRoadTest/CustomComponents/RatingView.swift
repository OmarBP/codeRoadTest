//
//  RatingView.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

import UIKit

class RatingView: UIView {
    fileprivate var currentProgressColor = UIColor.green
    fileprivate var currentTrackColor = UIColor.darkGray
    fileprivate var clockwise = true
    fileprivate var currentProgress = Double.zero
    fileprivate let trackLayer = CAShapeLayer()
    fileprivate let shapeLayer = CAShapeLayer()
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var progressLabelTopSpacing: NSLayoutConstraint!
    
    @IBInspectable var progressColor: UIColor {
        get {
            return currentProgressColor
        }
        set {
            currentProgressColor = newValue
        }
    }
    @IBInspectable var trackColor: UIColor {
        get {
            return currentTrackColor
        }
        set {
            currentTrackColor = newValue
        }
    }
    @IBInspectable var progress: CGFloat {
        get {
            return currentProgress
        }
        set {
            currentProgress = newValue
        }
    }
    @IBInspectable var isClockwise: Bool {
        get {
            return clockwise
        }
        set {
            clockwise = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initView()
        setProgress(42)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewHeight = superview?.bounds.height ?? 0
        let topSpacing = 0.5 * (viewHeight - sourceLabel.bounds.height)
        progressLabelTopSpacing.constant = topSpacing
        let startAngle = clockwise ? Double(-225).degToRad() : Double(45).degToRad()
        let endAngle = clockwise ? Double(45).degToRad() : Double(-225).degToRad()
        let radius = frame.width / 2.5
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        setTrackLayer(path)
        layer.addSublayer(trackLayer)
        setShapeLayer(path)
        layer.addSublayer(shapeLayer)
    }
    
    fileprivate func initView() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        let nib = UINib(nibName: "RatingView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let leftAnchor = view.leftAnchor.constraint(equalTo: leftAnchor)
        let rightAnchor = view.rightAnchor.constraint(equalTo: rightAnchor)
        let topAnchor = view.topAnchor.constraint(equalTo: topAnchor)
        let bottomAnchor = view.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftAnchor, rightAnchor, topAnchor, bottomAnchor])
    }
    
    fileprivate func setTrackLayer(_ path: UIBezierPath) {
        trackLayer.path = path.cgPath
        trackLayer.strokeColor = currentTrackColor.cgColor
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 4
    }
    
    fileprivate func setShapeLayer(_ path: UIBezierPath) {
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = currentProgressColor.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
    }
    
    func setProgress(_ newProgress: Double) {
        let progressToSet = min(max(0, newProgress), 1)
        guard progressToSet != currentProgress else { return }
        switch progressToSet {
            case let x where x <= 0.33:
                progressColor = UIColor(named: "LowProgressColor") ?? .red
                trackColor = UIColor(named: "LowTrackColor") ?? .red
            case let x where x >= 0.67:
                progressColor = UIColor(named: "ProgressColor") ?? .green
                trackColor = UIColor(named: "TrackColor") ?? .green
            default:
                progressColor = UIColor(named: "MidProgressColor") ?? .yellow
                trackColor = UIColor(named: "MidTrackColor") ?? .yellow
        }
        trackLayer.strokeColor = currentTrackColor.cgColor
        shapeLayer.strokeColor = currentProgressColor.cgColor
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fillMode = progressToSet < currentProgress ? .backwards : .forwards
        animation.fromValue = currentProgress
        animation.toValue = progressToSet
        animation.duration = CFTimeInterval(progress * 4)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapeLayer.strokeEnd = progressToSet
        shapeLayer.add(animation, forKey: "progress")
        progress = progressToSet
    }
}
