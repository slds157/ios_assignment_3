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
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageSliding()
    }
    
    private func setImageSliding() {
        let imageWidth = self.view.frame.size.width * 0.6
        let imageHeight = self.view.frame.size.height * 0.4
        let scrollViewX = (self.view.frame.size.width - imageWidth) / 2

        let statusBarHeight: CGFloat
        if #available(iOS 13.0, *) {
            statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let topOffset: CGFloat = (self.navigationController?.navigationBar.frame.size.height ?? 0) + statusBarHeight
        let scrollViewY = topOffset

        scrollView = UIScrollView(frame: CGRect(x: 0, y: scrollViewY, width: self.view.frame.size.width, height: imageHeight))
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(images.count), height: imageHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self

        for i in 0 ..< images.count {
            let imageView = UIImageView(frame: CGRect(x: self.view.frame.size.width * CGFloat(i) + scrollViewX, y: 0, width: imageWidth, height: imageHeight))
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

        // Create page control
        pageControl = UIPageControl(frame: CGRect(x: scrollViewX, y: scrollView.frame.maxY, width: imageWidth, height: 20))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
    }
    
    @IBAction func chooseButtonCheck(_ sender: UIButton) {
        currentPageCalculation(scrollView)
    }

    func currentPageCalculation(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        currentImage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        imageName = images[currentImage]
        if let imgName = imageName, let title = movieTitleCollection[imgName] {
            self.movieTitle = title
        }
        pageControl.currentPage = currentImage
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
            VC.userName = nameField.text!
            attentionLabel.text = ""
        }
    }
}
