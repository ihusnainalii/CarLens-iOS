//
//  FullOvalProgressView.swift
//  CarRecognition
//


import UIKit
import Lottie

internal final class FullOvalProgressView: View, ViewSetupable {
    
    private lazy var animationView = LOTAnimationView(name: "full_oval_progress").layoutable()
    
    private lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.font = .gliscorGothicFont(ofSize: 20)
        view.textColor = .crFontDark
        view.numberOfLines = 1
        view.textAlignment = .center
        return view.layoutable()
    }()
    
    private var currentNumber: Int
    
    private var maximumNumber: Int
    
    /// Initializes the view with given parameters
    ///
    /// - Parameters:
    ///   - currentNumber: Currently achieved number
    ///   - maximumNumber: Maximum available number
    ///   - invalidateChartInstantly: Chart will be updated instantly without animation if this value indicates false.
    ///                               When passing false, remember to use method `invalidatChart(animated:)` also
    init(currentNumber: Int, maximumNumber: Int, invalidateChartInstantly: Bool) {
        self.currentNumber = currentNumber
        self.maximumNumber = maximumNumber
        super.init()
        setup(currentNumber: currentNumber, maximumNumber: maximumNumber, invalidateChartInstantly: invalidateChartInstantly)
    }
    
    /// Setups the view with given parameters. Use only inside reusable views.
    ///
    /// - Parameters:
    ///   - currentNumber: Currently achieved number
    ///   - maximumNumber: Maximum available number
    ///   - invalidateChartInstantly: Chart will be updated instantly without animation if this value indicates false.
    ///                               When passing false, remember to use method `invalidatChart(animated:)` also
    func setup(currentNumber: Int, maximumNumber: Int, invalidateChartInstantly: Bool) {
        animationView.set(progress: 0, animated: false)
        self.currentNumber = currentNumber
        self.maximumNumber = maximumNumber
        
        let valueText = "\(currentNumber)/\(maximumNumber)"
        valueLabel.attributedText = NSAttributedStringFactory.trackingApplied(valueText, font: valueLabel.font, tracking: 0.6)
        if invalidateChartInstantly {
            invalidateChart(animated: false)
        }
    }
    
    /// Invalidates the progress shown on the chart
    ///
    /// - Parameter animated: Indicating if invalidation should be animated
    func invalidateChart(animated: Bool) {
        let progress = Double(currentNumber) / Double(maximumNumber)
        animationView.set(progress: CGFloat(progress), animated: animated)
    }
    
    /// Clear the progress shown on the chart
    ///
    /// - Parameter animated: Indicating if progress change should be animated
    func clearChart(animated: Bool) {
        animationView.set(progress: 0, animated: animated)
    }
            
    /// - SeeAlso: ViewSetupable
    func setupViewHierarchy() {
        [animationView, valueLabel].forEach(addSubview)
    }
    
    /// - SeeAlso: ViewSetupable
    func setupConstraints() {
        animationView.constraintToSuperviewEdges()
        valueLabel.constraintToSuperviewEdges(excludingAnchors: [.top, .bottom], withInsets: .init(top: 0, left: 8, bottom: 0, right: 8))
        NSLayoutConstraint.activate([
            valueLabel.centerYAnchor.constraint(equalTo: animationView.centerYAnchor)
        ])
    }
}