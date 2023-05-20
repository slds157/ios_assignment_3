//
//  MovieChooseViewController.swift
//  assignment3
//
//  Created by 桂文杰 on 20/5/2023.
//

import UIKit
import Foundation

class MovieChooseViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    
    var scrollView: UIScrollView!
    var images: [String] = ["image1", "image2", "image3", "image4", "image5"]
    var name: String?
    var imageName: String?
    var currentImage : Int = 0
    var movieTitle : String?
    var movieTitleCollection : [String: String] = ["image1": "Evil Dead Rise", "image2": "Book Club: The Next Chapter", "image3": "Love Again", "image4": "Guardians of the Galaxy - Vol 3", "image5": "John Wick: Chapter 4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageSliding()
    }
    
    private func setImageSliding() {
        let imageWidth = self.view.frame.size.width
        let imageHeight = self.view.frame.size.height * 0.5
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: imageWidth * CGFloat(images.count), height: imageHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        for i in 0 ..< images.count {
            let imageView = UIImageView(frame: CGRect(x: imageWidth * CGFloat(i), y: 0, width: imageWidth, height: imageHeight))
            guard let image = UIImage(named: images[i]) else {
                continue
            }
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            scrollView.addSubview(imageView)
        }
        
        self.view.addSubview(scrollView)
    }
        
    @IBAction func chooseButtonCheck(_ sender: UIButton) {
        currentPageCalculation(scrollView)
    }

    func currentPageCalculation(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        currentImage = Int(scrollView.contentOffset.x / pageWidth)
        imageName = images[currentImage]
        if let imgName = imageName, let title = movieTitleCollection[imgName] {
                self.movieTitle = title
            }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageCalculation(scrollView)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToEdit" {
            if let name = self.nameField.text, !name.isEmpty {
                return true
            } else {
                self.attentionLabel.text = "Please input your name!"
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit", let movieTitle = self.movieTitle {
            let VC = segue.destination as! MovieEditViewController
            VC.movieName = movieTitle
            attentionLabel.text = ""
        }
    }
    }


