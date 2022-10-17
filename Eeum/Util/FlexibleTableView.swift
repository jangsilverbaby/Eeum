//
//  FlexibleTableView.swift
//  Eeum
//
//  Created by 장은애(Eunae Jang) on 2022/10/17.
//

import UIKit

final class FlexibleTableView: UITableView {
  override var intrinsicContentSize: CGSize {
    let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
    return CGSize(width: self.contentSize.width, height: height)
  }
  override func layoutSubviews() {
    self.invalidateIntrinsicContentSize()
    super.layoutSubviews()
  }
}
