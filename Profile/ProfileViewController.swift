//
//  ProfileViewController.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 14/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var user: User?
    var albums = [Album]()
    var items = [NewsFeedItem]()
    
    var indicator  = UIActivityIndicatorView()
    
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 55, height: 55))
        indicator.color = .orange
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        
        Networking.getMyProfile { (result) in
            if let error = result.1 {
                self.showAlert(error.localizedDescription)
            } else {
                self.user = result.0
                self.tableView.reloadData()
            }
        }
        
        Networking.getUserAlbums() { (result) in
            if let error = result.1 {
                self.showAlert(error.localizedDescription)
            } else {
                self.albums = result.0
                self.tableView.reloadData()
            }
        }
        
        Networking.getNewsFeed { (result) in
            if let error = result.1 {
                self.showAlert(error.localizedDescription)
            } else {
                self.items.append(contentsOf: result.0)
                
                self.tableView.reloadData()
            }
        }
        
        let refresh = UIRefreshControl()
        tableView.refreshControl = refresh
        
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionDidLogout() {
        UserDefaults.standard.set(nil, forKey: "authTokenKey")
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.setRootController()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell") as! ProfileTableCell
            cell.userName.text = user?.nume
            if let id = Session.userId {
                cell.userImage.kf.setImage(with: URL(string: "https://graph.facebook.com/" + id + "/picture?type=normal"))
            }
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableCell") as! AlbumTableCell
            cell.albumsNumberLabel.text = albums.count.description
            return cell
            
        }  else if indexPath.row == items.count + 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutTableCell") as! LogoutTableCell
            return cell
            
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableCell") as! NewsFeedTableCell
            cell.titleLabel.text = items[indexPath.row - 2].story
            cell.feedImageView.kf.setImage(with: URL(string: items[indexPath.row - 2].newsPhoto))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumsViewController") as! AlbumsViewController
            controller.albums = albums
            present(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == items.count - 3 {
            
            self.indicator.startAnimating()
            self.indicator.backgroundColor = UIColor.green
            
            Networking.getNextPageFeed { (result) in
                if let error = result.1 {
                    self.showAlert(error.localizedDescription)
                } else {
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    
                    guard !result.0.isEmpty else { return }
                    self.items.append(contentsOf: result.0)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.row == 0 {
            return 100
        } else if indexPath.row == 1 {
            return 55
        }  else if indexPath.row < items.count {
            return 130
        }  else {
            return 55
        }
    }
}
