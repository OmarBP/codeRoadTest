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
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.82)
        posterImage.layer.cornerRadius = 16
        posterImage.clipsToBounds = true
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
