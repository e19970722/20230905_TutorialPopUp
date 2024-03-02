//
//  TutorialViewController.swift
//  20230905_TutorialPopUp
//
//  Created by Yen Lin on 2023/9/5.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    // 當別人呼叫此VC時可以自訂Key
    var userDefaultKey = ""
    
    // 教學圖
    let tutorialImages = ["Onboarding_1", "Onboarding_2", "Onboarding_3"]
    var pageViews = [UIView]()
    var currentIndex: Int = 0 {
        didSet {
            // 首、尾頁按鈕文字不同
            if currentIndex == 0 {
                pillButton.isHidden = false
                controlStackView.isHidden = true
                pillButton.setTitle("Let's Discover", for: .normal)
            }
            // 除了首、尾頁需要PillButton，其餘則是PageControl配CircleButton
            else if currentIndex > 0 && currentIndex < tutorialImages.count-1 {
                pillButton.isHidden = true
                controlStackView.isHidden = false
            }
            else {
                pillButton.isHidden = false
                controlStackView.isHidden = true
                pillButton.setTitle("Get Started", for: .normal)
            }
            print("目前第\(currentIndex)頁")
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let controlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .white
//        pageControl.backgroundStyle = .minimal
        pageControl.allowsContinuousInteraction = false
        return pageControl
    }()
    
    // 右側往下一頁的按鈕
    let circleButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "arrow.right") {
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .black
        }
        button.backgroundColor = .white
        return button
    }()
    
    // 首、尾頁的按鈕
    let pillButton: UIButton = {
        let button = UIButton()
        button.setTitle("Let's Discover", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addPageView()
        
    }
    
    // 由於背景圖是深色，把最上方的Status Bar調為白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 基本Tutorial UI設置
    func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(controlStackView)
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            controlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            controlStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72),
        ])
        
        controlStackView.addArrangedSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = tutorialImages.count
        pageControl.currentPage = currentIndex
        
        controlStackView.addArrangedSubview(circleButton)
        NSLayoutConstraint.activate([
            circleButton.widthAnchor.constraint(equalToConstant: 54),
            circleButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        circleButton.layer.cornerRadius = 27
        circleButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        controlStackView.isHidden = true
        
        view.addSubview(pillButton)
        pillButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pillButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pillButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            pillButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            pillButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72),
            pillButton.heightAnchor.constraint(equalToConstant: 54),
        ])
        
        pillButton.layer.cornerRadius = 27
        pillButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }
    
    // 製作每一頁教學圖的元件
    func addPageView() {
        
        for image in tutorialImages {
            
            let pageView = UIView()
            
            let imageView: UIImageView = {
                let imageView = UIImageView(image: UIImage(named: image))
                imageView.contentMode = .scaleAspectFill
                return imageView
            }()
            
            pageView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: pageView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: pageView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: pageView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: pageView.bottomAnchor)
            ])
            
            stackView.addArrangedSubview(pageView)
            pageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
                pageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
            ])
            
            pageViews.append(pageView)
        }
    }
    
    // 按鈕按下的Action
    @objc func buttonPressed() {
        // 如果不最後一頁，就Index + 1
        if currentIndex < pageViews.count-1 {
            currentIndex += 1
            scrollView.setContentOffset(pageViews[currentIndex].frame.origin, animated: true)
            
        } else if currentIndex == pageViews.count-1 {
            // 最後一頁，要關閉這個VC
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: userDefaultKey)
        }
        
        pageControl.currentPage = currentIndex
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        
        currentIndex = currentPage
        pageControl.currentPage = currentIndex
    }
    
    // 當別人要用此VC時，可以更改儲存的UserDefault Key
    @objc func setUserDefaultKey(_ key: String) {
        userDefaultKey = key
    }

}
