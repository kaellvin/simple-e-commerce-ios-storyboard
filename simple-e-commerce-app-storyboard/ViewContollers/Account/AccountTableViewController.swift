//
//  AccountTableViewController.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import UIKit
import Combine

class AccountTableViewController: UITableViewController {
    
    struct AccountMenu {
        let title: String
        let iconName: String
    }
    
    var menuList: [AccountMenu] = []
    
    private var viewModel = AccountViewModel(authRepository: DefaultAuthRepository())
    private var cancellables = Set<AnyCancellable>()
    
    private var previousIsSignedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        tableView.separatorStyle = .singleLine
    }
    
    private func bind() {
        
        viewModel
            .$isAuthenticated
            .sink { [weak self] isSignedIn in
                guard let self else { return }
                var filteredMenuList : [AccountMenu] = []
                if !isSignedIn {
                    filteredMenuList.append(AccountMenu(title: "Sign In", iconName: "person.fill"))
                }
                
                if isSignedIn {
                    filteredMenuList.append(AccountMenu(title: "Sign Out", iconName: "person.crop.circle.badge.plus"))
                }
                
                if !isSignedIn {
                    filteredMenuList.append(AccountMenu(title: "Sign Up", iconName: "rectangle.portrait.and.arrow.right"))
                }
                
                filteredMenuList.append(AccountMenu(title: "About App", iconName: "info.circle.fill"))
                
                self.menuList = filteredMenuList

                //NOTE: defer to next run loop
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                if previousIsSignedIn == true && isSignedIn == false {
                    self.showToast(message: "Sign out successfully.")
                }
                
                self.previousIsSignedIn = isSignedIn

            }
            .store(in: &cancellables)
        
        viewModel
            .$userEmail
            .sink { [weak self] userEmail in
                guard let self else { return }
                //NOTE: defer to next run loop
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                }

            }
            .store(in: &cancellables)
        
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
        
        if menu.title != "About App" && menu.title != "Sign Out" {
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
        case "Sign Up":
            let signUpVC =  storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            signUpVC.title = "Sign Up"
            navigationController?.pushViewController(signUpVC, animated: true)
        case "Sign Out":
            Task {
                await viewModel.signOut()
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let userEmail = viewModel.userEmail
        if !userEmail.isEmpty {
            return "Logged in as \(userEmail)"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
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
