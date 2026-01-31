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
        view.backgroundColor = .black.withAlphaComponent(0.82)
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
        moviesService.getImage(imageURL: posterURL) { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        self?.posterImage.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreViewCell else {
            return UICollectionViewCell()
        }
        let genre = genres[indexPath.item]
        cell.genreTitleLabel.text = genre.uppercased()
        return cell
    }
}
