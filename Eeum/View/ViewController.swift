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
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .gray1
       return scrollView
    }()
    
    lazy var bannerView: UIView = {
        let view = UIView()
        return view
    }()
    
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
        stackView.spacing = 1
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
        textField.backgroundColor = .white
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var downImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")!
        imageView.tintColor = .black
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
        textField.backgroundColor = .white
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var downImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")!
        imageView.tintColor = .black
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
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var searchTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력하세요."
        return textField
    }()
    
    lazy var searchCancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(searchCancelButtonClicked), for: .touchUpInside)
        button.tintColor = .gray1
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    lazy var addressView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var addressImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "scope")
        imageView.tintColor = .black
        return imageView
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "address~~"
        return label
    }()
    
    lazy var resultView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색결과"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var resultCountLabel: UILabel = {
        let label = UILabel()
        label.text = " 5784 "
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = .red
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    
    lazy var cashbackLabel: UILabel = {
        let label = UILabel()
        label.text = "10% 캐쉬백 가맹점"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var cashbackSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.tintColor = .lightGray
        toggle.layer.cornerRadius = toggle.frame.height / 2
        toggle.backgroundColor = .lightGray
        toggle.onTintColor = .yellow
        return toggle
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
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        menuButton.tintColor = .black
        navigationItem.rightBarButtonItem = menuButton
    }
    
    func setupSubView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(bannerView)
        bannerView.addSubview(collectionView)
        bannerView.addSubview(pageControl)
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(categoryView)
        categoryView.addSubview(categoryTextField)
        categoryView.addSubview(downImage1)
        stackView.addArrangedSubview(districtView)
        districtView.addSubview(districtTextField)
        districtView.addSubview(downImage2)
        
        scrollView.addSubview(searchView)
        searchView.addSubview(searchTextFieldView)
        searchTextFieldView.addSubview(searchTextField)
        searchTextFieldView.addSubview(searchCancelButton)
        searchTextFieldView.addSubview(searchButton)
        
        scrollView.addSubview(addressView)
        addressView.addSubview(addressImage)
        addressView.addSubview(addressLabel)
        
        scrollView.addSubview(resultView)
        resultView.addSubview(resultLabel)
        resultView.addSubview(resultCountLabel)
        resultView.addSubview(cashbackSwitch)
        resultView.addSubview(cashbackLabel)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        bannerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(150)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top).inset(10)
            $0.trailing.equalTo(collectionView.snp.trailing).inset(30)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(1)
            $0.leading.trailing.equalTo(view)
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
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(1)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(80)
        }
        
        searchTextFieldView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(50)
        }
        
        searchTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
        
        searchCancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchTextField.snp.trailing).inset(5)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchCancelButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(1)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(50)
        }
        
        addressImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(addressImage.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        resultView.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom).offset(1)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(50)
        }
        
        resultLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        resultCountLabel.snp.makeConstraints {
            $0.leading.equalTo(resultLabel.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        cashbackSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        cashbackLabel.snp.makeConstraints {
            $0.trailing.equalTo(cashbackSwitch.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func backButtonClicked() {
        
    }
    
    @objc func toolbarDoneButtonClicked() {
        categoryTextField.resignFirstResponder()
        districtTextField.resignFirstResponder()
    }
    
    @objc func searchCancelButtonClicked() {
        
    }
    
    @objc func searchButtonClicked() {
        
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
