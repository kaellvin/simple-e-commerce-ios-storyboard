//
//  AccountTableViewController.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    struct AccountMenu {
        let title: String
        let iconName: String
    }
    
    let menuList = [
        AccountMenu(title: "Sign In", iconName: "person.fill"),
        //TODO:
//        AccountMenu(title: "Sign Out", iconName: "person.crop.circle.badge.plus"),
        AccountMenu(title: "Sign Up", iconName: "rectangle.portrait.and.arrow.right"),
        AccountMenu(title: "About App", iconName: "info.circle.fill"),
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .singleLine
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = menuList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = menu.title
        content.image = UIImage(systemName: menu.iconName)
        cell.contentConfiguration = content
        
        if menu.title != "About App" {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        }else {
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let menu = menuList[indexPath.row]
        switch menu.title {
        case "Sign In":
            let signInVC =  storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            signInVC.title = "Sign In"
            navigationController?.pushViewController(signInVC, animated: true)
        default:
            break
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
