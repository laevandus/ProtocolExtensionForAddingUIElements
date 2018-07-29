//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

final class TableViewController: UITableViewController {}

final class CollectionViewController: UICollectionViewController {}

protocol EmptyViewBanner: AnyObject {
    var bannerContainerView: UIView { get }
    var emptyViewText: String { get set }
}

extension EmptyViewBanner {
    var emptyViewText: String {
        get {
            guard let label = bannerContainerView.viewWithTag(10000) as? UILabel else { return "" }
            return label.text ?? ""
        }
        set {
            guard newValue.isEmpty == false else {
                bannerContainerView.viewWithTag(10000)?.removeFromSuperview()
                return
            }
            if bannerContainerView.viewWithTag(10000) == nil {
                let label = UILabel()
                label.numberOfLines = 0
                label.tag = 10000
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                bannerContainerView.addSubview(label)
                label.leadingAnchor.constraint(equalToSystemSpacingAfter: bannerContainerView.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0).isActive = true
                bannerContainerView.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 1.0).isActive = true
                label.centerYAnchor.constraint(equalTo: bannerContainerView.safeAreaLayoutGuide.centerYAnchor).isActive = true
            }
            guard let label = bannerContainerView.viewWithTag(10000) as? UILabel else { fatalError() }
            label.text = newValue
        }
    }
}

extension CollectionViewController: EmptyViewBanner {
    var bannerContainerView: UIView {
        return collectionView
    }
}

extension TableViewController: EmptyViewBanner {
    var bannerContainerView: UIView {
        return tableView
    }
}

let contactsViewController: CollectionViewController = {
    let viewController = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    viewController.collectionView.backgroundColor = .white
    viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
    return viewController
}()
let historyViewController: TableViewController = {
    let viewController = TableViewController()
    viewController.tableView.backgroundColor = .white
    viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
    return viewController
}()
PlaygroundPage.current.liveView = {
    let tabBarViewController = UITabBarController()
    tabBarViewController.setViewControllers([contactsViewController, historyViewController], animated: false)
    contactsViewController.emptyViewText = "There are not any contacts"
    historyViewController.emptyViewText = "There is no history available"
    historyViewController.tableView.separatorStyle = .none
    return tabBarViewController
}()
