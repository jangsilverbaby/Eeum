//
//  ViewController.swift
//  Eeum
//
//  Created by eunae on 2022/10/13.
//

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController {
    
    var nowPage = 0
    let banners: [String] = ["banner1.jpg", "banner2.jpg"]
    
    let categorys: [String] = ["업종 전체","카페/디저트", "외식/레스토랑", "여행/체험", "스포츠/레저"]
    let localitys: [String] = ["지역 전체", "중구", "동구", "서구"]
    
    let stores: [Store] = [
        Store(category: .cafe, locality: .junggu, discount: "3% 할인", cashback: false, name: "LIGHT HOUSE", address: "인천시 중구 참외전로 174번길 8-1", longitude: 126.635135, latitude: 37.4719620),
        Store(category: .cafe, locality: .seogu, discount: "1% 할인", cashback: true, name: "카페.경선비", address: "인천시 서구 이름3로 220,상가1동 102호", longitude: 126.715834, latitude: 37.5887730),
        Store(category: .restorant, locality: .junggu, discount: "1% 할인", cashback: true, name: "본가삼치", address: "인천광역시 중구 우현로67번길 49, 1층(전동)", longitude: 126.628855, latitude: 37.4754022),
        Store(category: .tour, locality: .seogu, discount: "3% 할인", cashback: true, name: "낭만물고기", address: "인천광역시 서구 검단로 492 (마전동, 세훈빌딩) 지하1층", longitude: 126.658890, latitude: 37.6022084),
        Store(category: .restorant, locality: .donggu, discount: "배달e음 5% 할인", cashback: false, name: "우리집 송림점", address: "인천광역시 동구 방축로191번길 21-2, 1층(송림동)", longitude: 126.666332, latitude: 37.4804068)
    ]
    
    var filteredStores: [Store] = []
    var isFiltering = false
    
    lazy var backButton = UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: nil)
    
    lazy var menuButton =  UIBarButtonItem(
        image: UIImage(systemName: "line.3.horizontal"),
        style: .plain,
        target: self,
        action: nil)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .gray1
        return scrollView
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
    
    lazy var localityView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var localityTextField: UITextField = {
        let textField = PaddedTextField()
        textField.inputView = localityPickerView
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
    
    lazy var localityPickerView: UIPickerView = {
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
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.placeholder = "검색어를 입력하세요."
        searchBar.delegate = self
        return searchBar
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
    
    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        button.addTarget(self, action: #selector(addressButtonClicked), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 위치"
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 포그라운드일 때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트
        locationManager.startUpdatingLocation()
        return locationManager
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
        label.text = " \(stores.count) "
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
        toggle.onTintColor = .yellow1
        toggle.addTarget(self, action: #selector(switchClicked), for: .touchUpInside)
        return toggle
    }()
    
    lazy var tableView: UITableView = {
        let tableView = FlexibleTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(StoreCell.classForCoder(), forCellReuseIdentifier: "StoreCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        setupNavigation()
        setupSubView()
        
        bannerTimer()
        
        updateAddress()
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
        
        scrollView.addSubview(collectionView)
        scrollView.addSubview(pageControl)
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(categoryView)
        categoryView.addSubview(categoryTextField)
        categoryView.addSubview(downImage1)
        stackView.addArrangedSubview(localityView)
        localityView.addSubview(localityTextField)
        localityView.addSubview(downImage2)
        
        scrollView.addSubview(searchView)
        searchView.addSubview(searchTextFieldView)
        searchTextFieldView.addSubview(searchBar)
        searchTextFieldView.addSubview(searchButton)
        
        scrollView.addSubview(addressView)
        addressView.addSubview(addressButton)
        addressView.addSubview(addressLabel)
        
        scrollView.addSubview(resultView)
        resultView.addSubview(resultLabel)
        resultView.addSubview(resultCountLabel)
        resultView.addSubview(cashbackSwitch)
        resultView.addSubview(cashbackLabel)
        
        scrollView.addSubview(tableView)
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(200)
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
        
        localityTextField.snp.makeConstraints {
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
        
        searchBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchBar.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(1)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(50)
        }
        
        addressButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(addressButton.snp.trailing).offset(5)
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(resultView.snp.bottom).offset(1)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalToSuperview()
        }
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func reloadResultCount() {
        if isFiltering {
            resultCountLabel.text = " \(filteredStores.count) "
        } else {
            resultCountLabel.text = " \(stores.count) "
        }
    }
    
    func updateAddress() {
        guard let location = locationManager.location else { return }
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            if let placemark = placemarks?.first {
                self.addressLabel.text = "\(placemark.administrativeArea ?? "") \(placemark.locality ?? "") \(placemark.subLocality ?? "") \(placemark.thoroughfare ?? "") \(placemark.name ?? "")"
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func toolbarDoneButtonClicked() {
        categoryTextField.resignFirstResponder()
        localityTextField.resignFirstResponder()
        
        var category: Category? = nil
        var locality: Locality? = nil
        
        switch categoryTextField.text {
        case categorys[1]:
            category = .cafe
        case categorys[2]:
            category = .restorant
        case categorys[3]:
            category = .tour
        case categorys[4]:
            category = .sports
        default:
            category = nil
        }
        
        switch localityTextField.text {
        case localitys[1]:
            locality = .junggu
        case localitys[2]:
            locality = .donggu
        case localitys[3]:
            locality = .seogu
        default:
            locality = nil
        }
        
        if category != nil && locality != nil {
            self.filteredStores.removeAll()
            self.filteredStores = self.stores.filter { $0.category == category && $0.locality == locality }
            dump(filteredStores)
            isFiltering = true
        } else if category == nil && locality != nil {
            self.filteredStores.removeAll()
            self.filteredStores = self.stores.filter { $0.locality == locality }
            dump(filteredStores)
            isFiltering = true
        } else if category != nil && locality == nil {
            self.filteredStores.removeAll()
            self.filteredStores = self.stores.filter { $0.category == category }
            dump(filteredStores)
            isFiltering = true
        } else {
            isFiltering = false
        }
        
        self.reloadResultCount()
        self.tableView.reloadData()
    }
    
    @objc func searchButtonClicked() {
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    
    @objc func addressButtonClicked() {
        updateAddress()
    }
    
    @objc func switchClicked() {
        if cashbackSwitch.isOn {
            self.filteredStores.removeAll()
            self.filteredStores = self.stores.filter { $0.cashback == true }
            dump(filteredStores)
            isFiltering = true
        } else {
            isFiltering = false
        }
        
        self.reloadResultCount()
        self.tableView.reloadData()
    }
}

//MARK: - Banner UIScrollView
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.frame.size.width != 0 {
            let value = (scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(round(value))
        }
    }
}

//MARK: - UICollectionView
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

//MARK: - UIPickerView
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return categorys.count
        } else {
            return localitys.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return categorys[row]
        } else {
            return localitys[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            categoryTextField.text = categorys[row]
        } else {
            localityTextField.text = localitys[row]
        }
    }
}

//MARK: - UISearchBar
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchTerm = searchBar.text, searchTerm.isEmpty == false {
            if isFiltering {
                self.filteredStores = self.filteredStores.filter { $0.name.lowercased().hasPrefix(searchTerm.lowercased()) }
                dump(filteredStores)
            } else {
                self.filteredStores.removeAll()
                self.filteredStores = self.stores.filter { $0.name.lowercased().hasPrefix(searchTerm.lowercased()) }
                dump(filteredStores)
            }
            isFiltering = true
        } else {
            isFiltering = false
        }
        
        self.reloadResultCount()
        self.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchTextFieldView.layer.borderColor = UIColor.yellow1?.cgColor
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchTextFieldView.layer.borderColor = UIColor.black.cgColor
        return true
    }
}

//MARK: - CLLocationManager
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.isFiltering ? self.filteredStores.count : self.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        cell.selectionStyle = .none
        if self.isFiltering {
            cell.configure(with: filteredStores[indexPath.row])
        } else {
            cell.configure(with: stores[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
