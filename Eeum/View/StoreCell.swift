//
//  StoreCell.swift
//  Eeum
//
//  Created by eunae on 2022/10/16.
//

import UIKit
import SnapKit
import CoreLocation

class StoreCell: UITableViewCell {

    lazy var storeView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray1?.cgColor
        return view
    }()
    
    lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.backgroundColor = .green1
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.green1?.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return label
    }()
    
    lazy var cashbackLabel: UILabel = {
        let label = UILabel()
        label.text = " 10% 캐시백 가맹점 "
        label.isHidden = true
        label.textColor = .green1
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.green1?.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var distanceView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray2
        return label
    }()
    
    lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = .gray2
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        contentView.addSubview(storeView)
        storeView.addSubview(discountLabel)
        storeView.addSubview(cashbackLabel)
        storeView.addSubview(nameLabel)
        storeView.addSubview(addressLabel)
        
        contentView.addSubview(distanceView)
        distanceView.addSubview(distanceLabel)
        distanceView.addSubview(pinImageView)
        
        storeView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        discountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(15)
        }
        
        cashbackLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalTo(discountLabel.snp.trailing).offset(5)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(discountLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(15)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(15)
        }
        
        distanceView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(49)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
        
        pinImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(distanceLabel.snp.leading).offset(-5)
        }
    }
    
    func configure(with store: Store, location: CLLocation?) {
        discountLabel.text = " \(store.discount) "
        if store.cashback {
            cashbackLabel.isHidden = false
        } else {
            cashbackLabel.isHidden = true
        }
        nameLabel.text = store.name
        addressLabel.text = store.address
        
        guard let myLocation = location else { return }
        
        distanceLabel.text = "\(String(format: "%.1f",myLocation.distance(from: CLLocation(latitude: store.latitude, longitude: store.longitude)) / 1000))km"
    }
}
