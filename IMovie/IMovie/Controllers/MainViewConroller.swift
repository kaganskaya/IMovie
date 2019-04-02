//
//  MainViewConroller.swift
//  IMovie
//
//  Created by liza_kaganskaya on 4/1/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit

class MainViewConroller: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    var categories = ["", "Popular Celebrities", "Now Playing", "Trending", "Top Rated"]

    var cancelRequest: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancelRequest = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelRequest = true
    }
    
}

extension MainViewConroller : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell()
        
        switch indexPath.section {
            case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell") as!  commingSoonTableCell
            break
            
        default: break
            
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.red
        header.textLabel?.font = UIFont(name: "Mosk Normal 400", size: 14)
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return categories[section]
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 395
        }
        if indexPath.section == 1 {
            return 90
        }
        return 145
    }
    
}
   


