//
//  LoadingIndicator.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 21/6/24.
//

import UIKit

public protocol LoadingIndicatorPresenter {
    var activityIndicator: UIActivityIndicatorView { get }
    var overlayView: UIView { get }
    func showActivityIndicator()
    func hideActivityIndicator()
}

public extension LoadingIndicatorPresenter where Self: UIViewController {
    
    var overlayView: UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    var activityIndicator: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    func showActivityIndicator() {
            DispatchQueue.main.async {
                let overlay = self.overlayView
                self.view.addSubview(overlay)
                overlay.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                overlay.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                overlay.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
                self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
                overlay.addSubview(self.activityIndicator)
                
                NSLayoutConstraint.activate([
                    self.activityIndicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                    self.activityIndicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
                ])
                
                overlay.isHidden = false
                self.activityIndicator.startAnimating()
            }
        }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            
            if let overlay = self.view.subviews.first(where: { $0.backgroundColor == UIColor.black.withAlphaComponent(0.6) }) {
                overlay.removeFromSuperview()
            }
        }
    }
}
