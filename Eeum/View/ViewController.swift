//
//  ViewController.swift
//  Eeum
//
//  Created by eunae on 2022/10/13.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var nowPage = 0
    private var banners: [String] = ["banner1.jpg", "banner2.jpg"]
    
    private let categorys: [String] = ["업종 전체","카페/디저트", "외식/레스토랑", "여행/체험", "스포츠/레저"]
    private let districts: [String] = ["지역 전체", "중구", "동구", "서구"]
    
    private var storeData: [Store] = [
        Store(category: .cafe, district: .junggu, discount: "3% 할인", cashback: false, name: "LIGHT HOUSE", address: "인천시 중구 참외전로 174번길 8-1", longtitude: 126.635135, latitude: 37.4719620),
        Store(category: .cafe, district: .seogu, discount: "1% 할인", cashback: true, name: "카페.경선비", address: "인천시 서구 이름3로 220,상가1동 102호", longtitude: 126.715834, latitude: 37.5887730)
    ]
    
    lazy var backButton = UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(backButtonClicked))
    
    lazy var menuButton =  UIBarButtonItem(
        image: UIImage(systemName: "line.3.horizontal"),
        style: .plain,
        target: self,
        action: nil)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = .zero
        layout.headerReferenceSize = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .black
        
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var categoryTextField: UITextField = {
        let textField = PaddedTextField()
        textField.inputView = categoryPickerView
        textField.inputAccessoryView = toolbar
        textField.text = "업종 전체"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .gray
        textField.backgroundColor = .white
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var downImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")!
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var districtView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var districtTextField: UITextField = {
        let textField = PaddedTextField()
        textField.inputView = districtPickerView
        textField.inputAccessoryView = toolbar
        textField.text = "지역 전체"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .gray
        textField.backgroundColor = .white
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var downImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")!
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(toolbarDoneButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        return toolbar
    }()
    
    lazy var categoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 1
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
        return pickerView
    }()
    
    lazy var districtPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 2
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupSubView()
        
        bannerTimer()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.backgroundColor = .white
        title = "혜택+가맹점"
        backButton.tintColor = .systemGray
        navigationItem.leftBarButtonItem = backButton
        menuButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = menuButton
    }
    
    func setupSubView() {
        view.backgroundColor = .lightGray
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(categoryView)
        categoryView.addSubview(categoryTextField)
        categoryView.addSubview(downImage1)
        stackView.addArrangedSubview(districtView)
        districtView.addSubview(districtTextField)
        districtView.addSubview(downImage2)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top).inset(10)
            $0.trailing.equalTo(collectionView.snp.trailing).inset(30)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        categoryTextField.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        downImage1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        
        districtTextField.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        downImage2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        
    }
    
    @objc func toolbarDoneButtonClicked() {
        categoryTextField.resignFirstResponder()
        districtTextField.resignFirstResponder()
    }
    
    @objc func backButtonClicked() {
        
    }
    
}

extension ViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.frame.size.width != 0 {
            let value = (scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(round(value))
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = banners.count
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.configure(image: banners[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    // 2초마다 실행되는 타이머
    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            self.bannerMove()
        }
    }
    // 배너 움직이는 매서드
    func bannerMove() {
        // 현재페이지가 마지막 페이지일 경우
        if nowPage == banners.count-1 {
            // 맨 처음 페이지로 돌아감
            collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
            return
        }
        // 다음 페이지로 전환
        nowPage += 1
        collectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return categorys.count
        } else {
            return districts.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return categorys[row]
        } else {
            return districts[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            categoryTextField.text = categorys[row]
        } else {
            districtTextField.text = districts[row]
        }
    }
}
