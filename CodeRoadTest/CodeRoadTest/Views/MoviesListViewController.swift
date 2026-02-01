//
//  MoviesListViewController.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import UIKit

/**
 The main view of the app, where a list of movies or series will appear after a search
 */
class MoviesListViewController: UITableViewController, NetworkActivityView {
    fileprivate let moviesService = MoviesService()
    fileprivate var searchData: SearchData?
    fileprivate var welcomeLabel = UILabel()
    internal var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "OMBD"
        setUpWelcomeMessage()
        setUpActivityIndicator(in: view)
        activityIndicator.alpha = 0
        searchBar.placeholder = "Please enter movie title"
        searchBar.delegate = self
    }
    
    /**
     Sets up a welcome message that will appear when the list is empty
     */
    fileprivate func setUpWelcomeMessage() {
        welcomeLabel.center = view.center
        welcomeLabel.text = "Welcome to the OMDB App, here you can find all the data about your favorite movies"
        welcomeLabel.font = UIFont.systemFont(ofSize: 24)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.bounds.height * 0.7)
        tableView.tableFooterView = welcomeLabel
    }
    
    /**
     Loads a modal view showing all the details for the selected movie or serie
     
     - Parameters:
        - movieID: the ID of the selected movie or serie
     */
    fileprivate func showDetailFor(movieID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "movieDetail") as? MovieDetailViewController else { return }
        movieDetailVC.id = movieID
        let navigation = UINavigationController(rootViewController: movieDetailVC)
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.isHidden = true
        present(navigation, animated: true, completion: nil)
    }
    
    /**
     Refresh the list of items with an animation
     
     - Parameters:
        - data: The new data that will appear on the list
     */
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
            self?.activityIndicator.alpha = 0
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
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        cell.poster.image = UIImage(data: data)
                        UIView.animate(withDuration: 0.5) {
                            cell.poster.alpha = 1
                        }
                    case .failure(_):
                        cell.poster.image = #imageLiteral(resourceName: "No Poster")
                        UIView.animate(withDuration: 0.5) {
                            cell.poster.alpha = 1
                        }
                }
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
        tableView.tableFooterView = nil
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.activityIndicator.alpha = 1
        }
        
        guard let title = searchBar.text else { return }
        moviesService.getList(title: title) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.5) {
                    self?.activityIndicator.alpha = 0
                }
                switch result {
                    case .success(let data):
                        self?.refreshData(data)
                    case .failure(let error):
                        self?.tableView.tableFooterView = self?.welcomeLabel
                        guard let self = self else { break }
                        self.showErrorAlert(in: self, message: error.localizedDescription)
                }
            }
        }
    }
}
