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
    private var viewModel: FlickrImagesViewModel?
    private var pictures: [FlickrPictureModel] = []
    private var refreshControl = UIRefreshControl()
    var coordinator: FlickrImagesCoordinator?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = FlickrImagesCoordinator(delegate: self)
        viewModel = coordinator?.viewModel
        setupTableView()
        setupRefreshControl()
        fetchCachedImages()
        if pictures.isEmpty {
            viewModel?.fetchImages(page: 0)
        }
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
        
        tableView.register(FlickrImageCell.self, forCellReuseIdentifier: "FlickrImageCell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel?.fetchImages(page: 0)
    }
    private func fetchCachedImages() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in},
            deleteRealmIfMigrationNeeded: true
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            let realm = try Realm()
            let cachedImages = realm.objects(FlickrPhoto.self)
            self.pictures = cachedImages.map { FlickrPictureModel(model: $0) }
            self.tableView.reloadData()
        } catch {
            print("Error initializing Realm: \(error)")
        }
    }
}

extension FlikerImageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrImageCell", for: indexPath) as! FlickrImageCell
        let picture = pictures[indexPath.row]
        cell.configure(with: picture)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


extension FlikerImageViewController: FlickrImagesViewModelDelegate {
    func didStartFetchingImages() {
        if pictures.isEmpty {
            SVProgressHUD.show()
        }
    }
    
    func didFetchImages(_ model: FlickrPictureUIModel) {
        SVProgressHUD.dismiss()
        self.pictures.append(contentsOf: model.images)
        self.tableView.reloadData()
        self.viewModel?.isFetchingNextPage = false
        self.refreshControl.endRefreshing()
    }
    
    
    func didFailWithError(_ error: Error) {
        SVProgressHUD.dismiss()
        viewModel?.isFetchingNextPage = false
        self.refreshControl.endRefreshing()
    }
}

extension FlikerImageViewController: UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let distanceFromBottom = contentHeight - offsetY
        
        if distanceFromBottom < scrollView.frame.height && !(viewModel?.isFetchingNextPage ?? false) {
            viewModel?.fetchNextPage()
        }
    }
}
