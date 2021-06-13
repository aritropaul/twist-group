//
//  SidebarViewController.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didSelectFilter(filter: Filter)
}

class SidebarViewController: UITableViewController {

    weak var delegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0: delegate?.didSelectFilter(filter: .all)
        case 1: delegate?.didSelectFilter(filter: .airing)
        case 2: delegate?.didSelectFilter(filter: .trending)
        case 3: delegate?.didSelectFilter(filter: .rated)
        default:
            break
        }
    }
}
