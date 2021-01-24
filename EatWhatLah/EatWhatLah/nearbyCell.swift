////
////  nearbyCell.swift
////  EatWhatLah
////
////  Created by Apple on 23/1/21.
//// Not in used , saved it as archieved
//
//
//import UIKit
//
//class nearbyCell: UICollectionViewCell {
//
//    var data: CustomData? {
//        didSet {
//            guard let data = data else { return }
//            bg.image = data.backgroundImage
//            print("Loaded Data")
//
//        }
//    }
//
//    fileprivate let bg: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.layer.cornerRadius = 12
//        return iv
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//
//        contentView.addSubview(bg)
//
//        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
