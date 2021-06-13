//
//  SplitViewController.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import UIKit

class SplitViewController: UISplitViewController {

    var leftNavController: UINavigationController!
    var rightNavController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.primaryBackgroundStyle = .sidebar
        self.preferredPrimaryColumnWidthFraction = 0.3
        
        leftNavController = (self.viewControllers.first as! UINavigationController)
        rightNavController = (self.viewControllers[1] as! UINavigationController)
        let sidebar = leftNavController.viewControllers.first as! SidebarViewController
        sidebar.delegate = self
        // Do any additional setup after loading the view.
    }

}

extension SplitViewController: FilterDelegate {
    func didSelectFilter(filter: Filter) {
//        print(filter)
        let animeVC = rightNavController.viewControllers.first as! AnimeViewController
        animeVC.updateAnime(filter: filter)
    }
    
    
}
