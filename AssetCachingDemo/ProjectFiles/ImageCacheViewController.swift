//
//  ViewController.swift
//  3PGImageCacheLibrary
//
//  Created by Liliana Bulgaru on 16/06/16.
//  Copyright © 2016 Liliana Bulgaru. All rights reserved.
//

import UIKit
import AssetCaching

class ImageCacheViewController: UITableViewController, XMLParserDelegate {
    var imageData = [URL]()
    var photos = [ContentRecord]()
    var xmlParser: XMLParser!
    let kCellReuseIdentifier = "ImageTableViewCellIdentifier"
    var assetManager: AssetManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.assetManager = AssetManager()
        xmlParser = XMLParser()
        xmlParser.delegate = self
        self.makeGetDataRequest()
        self.tableView.register(ImageCacheTableViewCell.classForCoder(), forCellReuseIdentifier:kCellReuseIdentifier)
        let nibName = UINib(nibName: "HeaderView", bundle:Bundle.main)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "TableHeaderViewID")
        assetManager?.clearCache()
    }

    // MARK: Actions

    @IBAction func clearData(_ sender: UIButton) {
        self.assetManager?.clearCache()
        self.photos = []
        self.makeGetDataRequest()
    }

    // MARK: XMLParserDelegate delegate methods

    func parserDidFinishParsing() {
        self.imageData = xmlParser.arrParsedData
        fetchPhotoDetails()
        self.tableView.reloadData()
    }

    func fetchPhotoDetails() {
        for (index, imageUrl) in imageData.enumerated() {
            let name = "img \(index)"
            let photoRecord = ContentRecord(name:name, url:imageUrl)
            self.photos.append(photoRecord)
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerReuseIdentifier = "TableHeaderViewID"
        let dequeuedView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerReuseIdentifier)
        guard let sectionHeaderView = dequeuedView as? HeaderView else { return nil }

        sectionHeaderView.clearCache.titleLabel?.numberOfLines = 0
        return sectionHeaderView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath)
        guard let cell = cellView as? ImageCacheTableViewCell else { return cellView }
        cell.textLabel?.text = ""
        cell.imageView?.image = nil
        loadData(cell: cell, indexPath: indexPath)
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Private functionality

    private func loadData(cell: ImageCacheTableViewCell, indexPath: IndexPath) {
        let data = self.photos[indexPath.row]
        cell.textLabel?.text = data.name
        cell.imageView?.image = #imageLiteral(resourceName: "watermark")
        if let asset = Asset(networkURL: data.url) {
            assetManager?.fetchAsset(asset, completion: { (asset, error) in
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }
                if let url = asset.localURL, let image = UIImage(contentsOfFile: url.path) {
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
                if let error = error {
                    cell.textLabel?.text = "Failed to fetch asset due to error: \(error)"
                }
            })
        }
    }

    private func makeGetDataRequest() {
        if  let url = URL(string: "http://oceanservice.noaa.gov/rss/oceanfacts.xml") {
            xmlParser.startParsingWithContentsOfURL(url)
        }
    }
}
