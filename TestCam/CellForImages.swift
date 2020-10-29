//
//  TableViewCell.swift
//  TestCam
//
//  Created by mac on 28/10/2020.
//

import UIKit

class CellForImages: UITableViewCell {

    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var imageVCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageVCell.layer.cornerRadius = 20
        downloadBtn.isHidden = false
        downloadBtn.layer.cornerRadius = 20
//        viewC.layer.cornerRadius = 12
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func downloadClicked(_ sender: Any) {
        guard let image = imageVCell.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        downloadBtn.backgroundColor = .white
    }
}
