import UIKit
import MapboxDirections

typealias Payload = () -> ()

struct Item {
    let title: String
    let subtitle: String?
    // View controller to present on SettingsViewController.tableView(_:didSelectRowAt:)
    let viewControllerType: UIViewController.Type?
    // Closure to call on SettingsViewController.tableView(_:didSelectRowAt:)
    let payload: Payload?
    
    init(title: String, subtitle: String? = nil, viewControllerType: UIViewController.Type? = nil, payload: Payload? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.viewControllerType = viewControllerType
        self.payload = payload
    }
}

struct Section {
    let title: String
    let items: [Item]
}

class SettingsViewController: UITableViewController {
    
    let cellIdentifier = "cellId"
    var dataSource: [Section]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = sections()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let item = dataSource[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataSource[indexPath.section].items[indexPath.row]
        
        if let viewController = item.viewControllerType?.init() {
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        if let payload = item.payload {
            payload()
        }
    }
}