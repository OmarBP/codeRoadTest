//
//  MovieDetailViewController.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import UIKit

/**
 View designed to show all the relevant data about a movie or a serie
 */
class MovieDetailViewController: UIViewController, NetworkActivityView {
    var id: String!
    fileprivate let moviesService = MoviesService()
    fileprivate var genres = [String]()
    fileprivate var ratings = [RatingData]()
    internal var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var boxOfficeLabel: UILabel!
    @IBOutlet weak var writersLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var plotDetailLabel: UILabel!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ModalBackgroundColor") ?? .black
        setUpActivityIndicator(in: view)
        setUpLabels()
        setUpPosterImage()
        plotLabel.text = "Plot"
        setUpCollectionView()
        
        moviesService.getDetails(id: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            switch result {
                case .success(let data):
                    self?.loadPoster(data.poster)
                    self?.loadData(data)
                case .failure(let error):
                    guard let self = self else { break }
                    self.showErrorAlert(in: self, message: error.localizedDescription) {
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }
    
    /**
     Sets up some basic properties for the poster image
     */
    fileprivate func setUpPosterImage() {
        posterImage.layer.cornerRadius = 16
        posterImage.clipsToBounds = true
        posterImage.layer.borderWidth = 1
        posterImage.layer.borderColor = UIColor.white.cgColor
        posterImage.alpha = 0
    }
    
    /**
     Sets up some basic properties for all the labels in the view
     */
    fileprivate func setUpLabels() {
        titleLabel.alpha = 0
        releaseDateLabel.alpha = 0
        directorLabel.alpha = 0
        ratedLabel.alpha = 0
        castLabel.alpha = 0
        boxOfficeLabel.alpha = 0
        writersLabel.alpha = 0
        plotLabel.alpha = 0
        plotDetailLabel.alpha = 0
    }
    
    /**
     Sets up the properties for the collection view
     */
    fileprivate func setUpCollectionView() {
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.backgroundColor = .clear
        
        let flowLayout = CustomCollectionFlowLayout()
        flowLayout.unaffectedSections = [0]
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        genresCollectionView.collectionViewLayout = flowLayout
        genresCollectionView.alpha = 0
    }
    
    /**
     Load the poster images from a service if it exists
     
     - Parameters:
        - posterURL: The url where the poster image  is located
     
     - Postcondition: If there is no data on the service, a default image will appear as the poster
     */
    fileprivate func loadPoster(_ posterURL: String) {
        moviesService.getImage(imageURL: posterURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        self?.posterImage.image = UIImage(data: data)
                        UIView.animate(withDuration: 0.5) {
                            self?.posterImage.alpha = 1
                        }
                    case .failure(_):
                        self?.posterImage.image = #imageLiteral(resourceName: "No Poster")
                        UIView.animate(withDuration: 0.5) {
                            self?.posterImage.alpha = 1
                        }
                }
            }
        }
    }
    
    /**
     Sets all the relevant data to its correspondent UI element and perform an animation to load the data in the screen
     
     - Parameters:
        - data: The data related to the movie or serie
     */
    fileprivate func loadData(_ data: MovieDetailData) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = data.title
            self?.releaseDateLabel.text = data.released
            self?.directorLabel.text = "Directed by: \(data.director)"
            self?.ratedLabel.text = data.rated
            
            if let boxOffice = data.boxOffice {
                self?.boxOfficeLabel.text = "Box office: \(boxOffice)"
            } else if let seasons = data.totalSeasons {
                self?.boxOfficeLabel.text = "Total seasons: \(seasons)"
            } else {
                self?.boxOfficeLabel.text = nil
            }
            
            self?.castLabel.text = "Cast: \(data.actors)"
            self?.writersLabel.text = "Writers: \(data.writer)"
            self?.plotDetailLabel.text = data.plot
            
            let dataGenres = data.genre.split(separator: ",").compactMap({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            self?.genres = dataGenres
            self?.ratings = data.ratings
            self?.genresCollectionView.reloadData()
            
            UIView.animate(withDuration: 0.5) {
                self?.activityIndicator.alpha = 0
                self?.titleLabel.alpha = 1
                self?.releaseDateLabel.alpha = 1
                self?.directorLabel.alpha = 1
                self?.ratedLabel.alpha = 1
                self?.castLabel.alpha = 1
                self?.boxOfficeLabel.alpha = 1
                self?.writersLabel.alpha = 1
                self?.plotLabel.alpha = 1
                self?.plotDetailLabel.alpha = 1
                self?.genresCollectionView.alpha = 1
            }
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? CollectionHeaderView else {
            return UICollectionReusableView()
        }
        switch indexPath.section {
            case 0:
                header.headerTitleLabel.text = "Genres"
            case 1:
                header.headerTitleLabel.text = "Ratings"
            default:
                break
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 84, height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? genres.count : ratings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreViewCell {
                    let genre = genres[indexPath.item]
                    cell.genreTitleLabel.text = genre.uppercased()
                    return cell
                }
            case 1:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ratingCell", for: indexPath) as? RatingViewCell {
                    let rating = ratings[indexPath.item]
                    cell.setProgress(rating.value, source: rating.source)
                    return cell
                }
            default:
                break
        }
        return UICollectionViewCell()
    }
}
