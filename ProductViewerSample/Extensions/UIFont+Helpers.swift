import UIKit

extension UIFont {
    static var small: UIFont {
        UIFont(name: "sf-pro-text-regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }

    static var medium: UIFont {
        UIFont(name: "sf-pro-text-regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }

    static var standard: UIFont {
        UIFont(name: "sf-pro-text-regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
    }

    static var largeBold: UIFont {
        UIFont(name: "sf-pro-text-bold", size: 21.0) ?? UIFont.boldSystemFont(ofSize: 21.0)
    }

    static var emphasis: UIFont {
        UIFont(name: "sf-pro-text-bold", size: 18.0) ?? UIFont.boldSystemFont(ofSize: 18.0)
    }

}
