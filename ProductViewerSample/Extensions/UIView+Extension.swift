//
//  UIView+Extension.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

extension UIView {

    func addSubviewWithEdgeConstraints(_ view: UIView, safeAreaAvailable: Bool = false) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        if safeAreaAvailable {
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                self.topAnchor.constraint(equalTo: view.topAnchor),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

}

extension NSCoder {
    class func empty() -> NSCoder {
        do {
            let archiver = NSKeyedArchiver(requiringSecureCoding: false)
            let data = archiver.encodedData
            archiver.finishEncoding()
            let unarchived = try NSKeyedUnarchiver(forReadingFrom: data as Data)
            return unarchived
        } catch {
            return NSCoder()
        }
    }
}
