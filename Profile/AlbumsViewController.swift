//
//  AlbumsViewController.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 20/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SIngleAlbumTableCell") as! SIngleAlbumTableCell
        cell.titleLabel.text = albums[indexPath.row ].title
        cell.feedImageView.kf.setImage(with: URL(string: "https://graph.facebook.com/" + albums[indexPath.row ].id + "/picture?redirect=true&access_token=\(Session.authToken!)"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        controller.albumId = albums[indexPath.row].id
        present(controller, animated: true, completion: nil)
    }

    
    @IBAction func dismissACtion() {
        dismiss(animated: true, completion: nil)
    }
}
