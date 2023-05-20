//
//  IssuedTicketViewController.swift
//  assignment3
//
//  Created by Zheng Yuan on 2023-05-20.
//

import UIKit

class IssuedTicketViewController: UIViewController {
    
    var Tickt_Key: String
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goHome(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
