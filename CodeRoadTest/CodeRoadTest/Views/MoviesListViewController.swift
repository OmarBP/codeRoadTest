//
//  MoviesListViewController.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import UIKit

class MoviesListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    fileprivate let moviesService = MoviesService()
    fileprivate var searchData: SearchData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchBar.placeholder = "Please enter movie title"
        searchBar.delegate = self
    }
    
    fileprivate func showDetailFor(movieID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "movieDetail") as? MovieDetailViewController else { return }
        movieDetailVC.id = movieID
        let navigation = UINavigationController(rootViewController: movieDetailVC)
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.isHidden = true
        present(navigation, animated: true, completion: nil)
    }
    
    fileprivate func refreshData(_ data: SearchData) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
            if !(self?.searchData?.search.isEmpty ?? false) {
                var indicesToRemove = [IndexPath]()
                self?.searchData?.search.indices.forEach { i in
                    let indexToRemove = IndexPath(row: i, section: 0)
                    indicesToRemove.append(indexToRemove)
                }
                self?.tableView.deleteRows(at: indicesToRemove, with: .fade)
            }
            self?.searchData = data
            var indicesToInsert = [IndexPath]()
            self?.searchData?.search.indices.forEach { i in
                let indexToInsert = IndexPath(row: i, section: 0)
                indicesToInsert.append(indexToInsert)
            }
            self?.tableView.insertRows(at: indicesToInsert, with: .fade)
            self?.tableView.endUpdates()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData?.search.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieViewCell else {
            return UITableViewCell()
        }
        guard let data = searchData?.search[indexPath.row] else {
            return UITableViewCell()
        }
        cell.titleLabel.text = data.title
        cell.yearLabel.text = data.year
        moviesService.getImage(imageURL: data.poster) { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.poster.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = searchData?.search[indexPath.row] else { return }
        let movieID = data.id
        showDetailFor(movieID: movieID)
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let title = searchBar.text else { return }
        moviesService.getList(title: title) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.refreshData(data)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
