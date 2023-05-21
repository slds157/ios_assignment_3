//
//  MovieChooseViewController.swift
//  assignment3
//
//  Created by 桂文杰 on 20/5/2023.
//

import UIKit
import Foundation

class MovieChooseViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var chooseButton: UIBarButtonItem!
    @IBAction func chooseButtonCheck(_ sender: UIBarButtonItem) {
        currentPageCalculation(scrollView)
    }
    
    var scrollView: UIScrollView!
    var images: [String] = ["image1", "image2", "image3", "image4", "image5"]
    var name: String?
    var imageName: String?
    var currentImage : Int = 0
    var movieTitle : String?
    var movieTitleCollection : [String: String] = ["image1": "Evil Dead Rise", "image2": "Book Club: The Next Chapter", "image3": "Love Again", "image4": "Guardians of the Galaxy - Vol 3", "image5": "John Wick: Chapter 4"]
    var pageControl: UIPageControl!
    var titleLabel: UILabel!
    var nameField: UITextField!
    var attentionLabel: UILabel!
    
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
        let topOffset: CGFloat = (self.navigationController?.navigationBar.frame.size.height ?? 0) + statusBarHeight + 30
        
        let scrollViewY = topOffset

        titleLabel = UILabel(frame: CGRect(x: scrollViewX, y: scrollViewY + imageHeight - 40, width: imageWidth, height: 40))
        titleLabel.textAlignment = .center
        titleLabel.text = movieTitleCollection[images[0]]
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(titleLabel)

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

        pageControl = UIPageControl(frame: CGRect(x: scrollViewX, y: scrollView.frame.maxY, width: imageWidth, height: 20))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
        
        let instructionLabel = UILabel(frame: CGRect(x: scrollViewX, y: pageControl.frame.maxY + 10, width: imageWidth, height: 40)) // Positioned below pageControl
        instructionLabel.textAlignment = .center
        instructionLabel.text = "Please select a movie and enter your name:"
        instructionLabel.font = UIFont.systemFont(ofSize: 16)
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        self.view.addSubview(instructionLabel)
        
        nameField = UITextField(frame: CGRect(x: scrollViewX, y: instructionLabel.frame.maxY + 10, width: imageWidth, height: 40))
        nameField.borderStyle = .roundedRect
        nameField.placeholder = "Enter your name"
        self.view.addSubview(nameField)

        attentionLabel = UILabel(frame: CGRect(x: scrollViewX, y: nameField.frame.maxY + 10, width: imageWidth, height: 40))
        attentionLabel.textColor = .red
        attentionLabel.textAlignment = .center
        attentionLabel.numberOfLines = 0
        attentionLabel.lineBreakMode = .byWordWrapping
        self.view.addSubview(attentionLabel)

    }
    
    func currentPageCalculation(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        currentImage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        imageName = images[currentImage]
        if let imgName = imageName, let title = movieTitleCollection[imgName] {
            self.movieTitle = title
            titleLabel.text = title
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
