//
//  UIViewExtension.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

extension UIView {
    enum BorderType { case top, left, right, bottom }
    func addBorder(at type: BorderType, color: UIColor, width: CGFloat, topInset: CGFloat = 0, leftInset: CGFloat = 0, rightInset: CGFloat = 0, bottomInset: CGFloat = 0) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        switch type {
        case .top:
            border.frame = CGRect(x: leftInset, y: topInset, width: self.frame.size.width - leftInset - rightInset, height: width)
        case .left:
            border.frame = CGRect(x: leftInset, y: topInset, width: width, height: self.frame.size.height - topInset - bottomInset)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - rightInset - width, y: topInset, width: width, height: self.frame.size.height - topInset - bottomInset)
        case .bottom:
            border.frame = CGRect(x: leftInset, y: self.frame.size.height - bottomInset - width, width: self.frame.size.width - leftInset - rightInset, height: width)
        }
        self.layer.addSublayer(border)
    }
    
    // safe area anchors
    var safeTopAnchor: NSLayoutYAxisAnchor {
        safeAreaLayoutGuide.topAnchor
    }
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        safeAreaLayoutGuide.leftAnchor
    }
    var safeRightAnchor: NSLayoutXAxisAnchor {
        safeAreaLayoutGuide.rightAnchor
    }
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        safeAreaLayoutGuide.bottomAnchor
    }
    
    // Visual formatting langauge
    func addConstraints(H: String) {
        addConstraints(H: H, V: "")
    }
    func addConstraints(V: String) {
        addConstraints(H: "", V: V)
    }
    func addConstraints(H: String, V: String) {
        let views: [String: UIView] = Mirror(reflecting: self).children.reduce(into: [:]) { views, objc in
            if let label = objc.label, let view = objc.value as? UIView {
                views[label] = view
            }
        }
        if H.starts(with: "|~[") && H.reversed().starts(with: "|~]") {
            let viewName = H.components(separatedBy: CharacterSet.letters.inverted).joined()
            views[viewName]!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            if let size = getSize(from: H) {
                views[viewName]!.widthAnchor.constraint(equalToConstant: size).isActive = true
            }
        } else if !H.isEmpty {
            activateConstraints(format: "H:" + H)
        }
        if V.starts(with: "|~[") && V.reversed().starts(with: "|~]") {
            let viewName = V.components(separatedBy: CharacterSet.letters.inverted).joined()
            views[viewName]!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            if let size = getSize(from: V) {
                views[viewName]!.heightAnchor.constraint(equalToConstant: size).isActive = true
            }
        } else if !V.isEmpty {
            activateConstraints(format: "V:" + V)
        }
        
        func getSize(from str: String) -> CGFloat? {
            let strNum = str.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if let size = Int(strNum) {
                return CGFloat(size)
            }
            return nil
        }
        func activateConstraints(format: String) {
            NSLayoutConstraint.activate(Array(NSLayoutConstraint
                .constraints(withVisualFormat: format, metrics: nil, views: views)
            ))
        }
    }
}
