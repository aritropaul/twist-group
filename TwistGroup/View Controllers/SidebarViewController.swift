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
        let cell = tableView.cellForRow(at: indexPath)
        resetImages()
        switch indexPath.row {
        case 0:
            delegate?.didSelectFilter(filter: .all)
            cell?.imageView?.image = UIImage(systemName: "square.grid.2x2.fill")
        case 1: delegate?.didSelectFilter(filter: .airing)
            cell?.imageView?.image = UIImage(systemName: "tv.fill")
        case 2: delegate?.didSelectFilter(filter: .trending)
            cell?.imageView?.image = UIImage(systemName: "flame.fill")
        case 3: delegate?.didSelectFilter(filter: .rated)
            cell?.imageView?.image = UIImage(systemName: "star.fill")
        default:
            break
        }
    }
    
    func resetImages() {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
