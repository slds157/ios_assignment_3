//
//  MovieChooseViewController.swift
//  assignment3
//
//  Created by 桂文杰 on 20/5/2023.
//

import UIKit

class MovieChooseViewController: UIViewController, UIScrollViewDelegate {
    
    // Define the IBOutlet variables
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    
    // Declare variables
    var scrollView: UIScrollView!
    var images: [String] = ["image1", "image2", "image3", "image4", "image5"]
    var name: String?
    var imageName: String?
    var currentImage : Int = 0
    var movieTitle : String?
    var movieTitleCollection : [String: String] = ["image1": "Evil Dead Rise", "image2": "Book Club: The Next Chapter", "image3": "Love Again", "image4": "Guardians of the Galaxy - Vol 3", "image5": "John Wick: Chapter 4"]
    var pageControl: UIPageControl!
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageSliding() // set up the image sliding
    }
    
    // This function sets up the image sliding function
    private func setImageSliding() {
        let imageWidth = self.view.frame.size.width * 0.6
        let imageHeight = self.view.frame.size.height * 0.4
        let scrollViewX = (self.view.frame.size.width - imageWidth) / 2

        // get status bar height
        let statusBarHeight: CGFloat = getStatusBarHeight()

        // calculate top offset
        let topOffset: CGFloat = (self.navigationController?.navigationBar.frame.size.height ?? 0) + statusBarHeight + 30
        
        // set title label
        setTitleLabel(scrollViewX, topOffset, imageWidth, imageHeight)

        // set scroll view
        setScrollView(scrollViewX, topOffset, imageHeight, imageWidth)

        // set page control
        setPageControl(scrollViewX, topOffset, imageWidth, imageHeight)
    }
    
    func getStatusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

    func setTitleLabel(_ scrollViewX: CGFloat, _ topOffset: CGFloat, _ imageWidth: CGFloat, _ imageHeight: CGFloat) {
        titleLabel = UILabel(frame: CGRect(x: scrollViewX, y: topOffset + imageHeight - 40, width: imageWidth, height: 40))
        titleLabel.textAlignment = .center
        titleLabel.text = movieTitleCollection[images[0]]
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(titleLabel)
    }

    func setScrollView(_ scrollViewX: CGFloat, _ topOffset: CGFloat, _ imageHeight: CGFloat, _ imageWidth: CGFloat) {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: topOffset, width: self.view.frame.size.width, height: imageHeight))
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
    }

    func setPageControl(_ scrollViewX: CGFloat, _ topOffset: CGFloat, _ imageWidth: CGFloat, _ imageHeight: CGFloat) {
        pageControl = UIPageControl(frame: CGRect(x: scrollViewX, y: scrollView.frame.maxY, width: imageWidth, height: 20))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
    }
    
    // The function of the choose button
    @IBAction func chooseButtonCheck(_ sender: UIButton) {
        currentPageCalculation(scrollView)
    }

    // Function to calculate current page
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
    
    // Delegate method for the scroll view
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageCalculation(scrollView)
    }
    
    // Check before perform segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToEdit" {
            if let name = self.nameField.text, !name.isEmpty {
                return true
            } else {
                self.attentionLabel.text = "please enter your name!"
                self.attentionLabel.textColor = .red
                return false
            }
        }
        return true
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit", let movieTitle = self.movieTitle {
            let VC = segue.destination as! MovieEditViewController
            VC.movieName = movieTitle
            VC.userName = nameField.text!
            attentionLabel.text = ""
        }
    }
    
}
