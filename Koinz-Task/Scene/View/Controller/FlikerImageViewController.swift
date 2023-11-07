//
//  FlikerImageViewController.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import UIKit
import SVProgressHUD
import RealmSwift


class FlikerImageViewController: UIViewController {
    
    //MARK: - Properties
    private var tableView: UITableView!
    private var viewModel: FlickrImagesViewModel!
    private var pictures: [FlickrPictureModel] = []
    private var refreshControl = UIRefreshControl()
    private var lastPage = 0
    private var reuseIdentifier = "FlickrImageCell"
    private var adBannerReuseIdentifier = "AdBannerCell"
    private var items: [[Any]] = []
    
    convenience init(viewModel: FlickrImagesViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshControl()
        showLoading()
        viewModel.fetchImages()
    }
    
    //MARK: - Setups
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.register(FlickrImageCell.self,
                           forCellReuseIdentifier: reuseIdentifier)
        tableView.register(AdBannerCell.self,
                           forCellReuseIdentifier: adBannerReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel?.refresh()
    }
    
    private func showLoading() {
        SVProgressHUD.show()
    }
    
    private func hideLoading() {
        SVProgressHUD.dismiss()
    }
}

extension FlikerImageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.flatMap { $0 }.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flattenedItems = items.flatMap { $0 }
        let item = flattenedItems[indexPath.row]
        
        if let picture = item as? FlickrPictureModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                     for: indexPath) as! FlickrImageCell
            cell.configure(with: picture)
            return cell
        } else if let adBanner = item as? AdBanner {
            let cell = tableView.dequeueReusableCell(withIdentifier: adBannerReuseIdentifier,
                                                     for: indexPath) as! AdBannerCell
            cell.configure(with: adBanner)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension FlikerImageViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.canLoadMore(lastPage: self.lastPage,
                                     currentRow: indexPath.row,
                                     totalDataCount: self.pictures.count) {
                viewModel.loadMore()
            }
        }
    }
}

extension FlikerImageViewController: FlickrImagesViewModelDelegate {
    
    func didFetchImages(_ model: ResponseBody?) {
        guard let photos = model?.photo else { return }
        let picturesPhotos = photos.map {
            FlickrPictureModel(model: $0)
        }
        self.pictures.append(contentsOf: picturesPhotos)
        let chunkedItems = stride(from: 0, to: picturesPhotos.count, by: 5).map {
            Array(picturesPhotos[$0..<min($0 + 5, picturesPhotos.count)]) + [AdBanner(image: UIImage(named: "ad-banner")!)]
        }
        self.items.append(contentsOf: chunkedItems)
        
        self.lastPage = model?.pages ?? 0
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.hideLoading()
        self.viewModel.saveToDataBase(photos: pictures.map {$0.photo}, pages: lastPage)
    }
    
    func didFailWithError(_ error: Error) {
        self.refreshControl.endRefreshing()
        self.hideLoading()
    }
}

extension FlikerImageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
