//
//  MovieDetailViewController.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var id: String!
    fileprivate let moviesService = MoviesService()
    fileprivate var genres = [String]()
    fileprivate var ratings = [RatingData]()
    
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
        posterImage.layer.cornerRadius = 16
        posterImage.clipsToBounds = true
        plotLabel.text = "Plot"
        setUpCollectionView()
        moviesService.getDetails(id: id) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.loadPoster(data.poster)
                    self?.loadData(data)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func setUpCollectionView() {
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.backgroundColor = .clear
        let flowLayout = CustomCollectionFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        genresCollectionView.collectionViewLayout = flowLayout
    }
    
    fileprivate func loadPoster(_ posterURL: String) {
        moviesService.getImage(imageURL: posterURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        self?.posterImage.image = UIImage(data: data)
                    case .failure(_):
                        self?.posterImage.image = #imageLiteral(resourceName: "No Poster")
                }
            }
        }
    }
    
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
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        return CGSize(width: 72, height: 96)
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
