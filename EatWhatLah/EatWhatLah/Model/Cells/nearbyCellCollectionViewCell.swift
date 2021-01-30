//
//  nearbyCellCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Apple on 24/1/21.
//

import UIKit

class nearbyCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var distanceTextLabel: UILabel!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueTextLabel: UILabel!
    @IBOutlet weak var ratingTextLabel: UILabel!
    
    @IBOutlet weak var venueView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(place: Places) {
        distanceTextLabel.text = String(format: "%.0f", place.distance) + "m";
        venueImageView.image = #imageLiteral(resourceName: "noResult")
        
        venueImageView.downloaded(from: place.venueImage)
        
        //if its nil, use default image
        venueTextLabel.text = String(place.venueName);
        ratingTextLabel.text = String(place.rating);
        
        
    }
    
    
    //Download image asynchronous
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self!.venueImageView.image = UIImage(data: data)
            }
        }
    }
    
    
    class var reuseIdentifier: String {
        return "CollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "nearbyCellCollectionViewCell"
    }
    
}

extension UIImageView {
    
    //Async method
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                
                DispatchQueue.main.async {
                    self.image = #imageLiteral(resourceName: "noResult");
                }
                
                //Cant request for image
                return
            }
            let imageVenue = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.image = imageVenue;
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
