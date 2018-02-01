//
//  LFImagePickerAlbumsController.swift
//  LFImagePicker
//
//  Created by ios开发 on 2018/1/30.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit
import AssetsLibrary

class LFImagePickerAlbumsController: UITableViewController {

    weak var delegate:LFImagePickerDataSourceDelegate!
    private var dataSource = [LFImagePickerAlbumModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.title = "相册"
        self.tableView.rowHeight = 80
        LFImagePickerDataSource.fetch(type: delegate.source, mediaType: delegate.mediaTypes) { (dataSource) in
            self.dataSource = dataSource
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LFAlbumList") as? LFImagePickerAlbumCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("LFImagePickerAlbumCell", owner: self, options: nil)?.last as? LFImagePickerAlbumCell
        }
        cell?.setup(model: self.dataSource[indexPath.row])
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        let controller = LFImagePickerAssetsController()
        controller.groupModel = model
        controller.delegate = delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    

}
