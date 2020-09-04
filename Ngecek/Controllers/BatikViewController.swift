//
//  ViewController.swift
//  Ngecek
//
//  Created by Wendy Kurniawan on 03/09/20.
//  Copyright © 2020 Wendy Kurniawan. All rights reserved.
//

import UIKit

class BatikViewController: UIViewController {

    @IBOutlet weak var batikImageView: UIImageView!
    @IBOutlet weak var batikTitleLabel: UILabel!
    @IBOutlet weak var batikDescriptionLabel: UILabel!
    
    private let imagePicker = UIImagePickerController()
    private let emptyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideBatikExplanation()
        setupEmptyLabel()
        setupImagePicker()
    }

    // MARK: - Camera Tapping Handler
    @IBAction func handleCameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Batik Title and Description Setup
    private func hideBatikExplanation() {
        batikDescriptionLabel.isHidden = true
        batikTitleLabel.isHidden = true
    }
    
    private func showBatikExplanation() {
        batikDescriptionLabel.isHidden = false
        batikTitleLabel.isHidden = false
    }
    
    // MARK: - Image Picker Setup
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
    }
    
    // MARK: - Empty Label Setup
    private func setupEmptyLabel() {
        emptyLabel.frame = CGRect(x: view.center.x, y: view.center.y, width: 200, height: 20)
        emptyLabel.center = view.center
        emptyLabel.text = "Scan to get Batik Info"
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 20)
        emptyLabel.textColor = UIColor.gray
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = NSTextAlignment.center
        view.addSubview(emptyLabel)
    }
    
    fileprivate func removeEmptyLabel() {
        emptyLabel.removeFromSuperview()
    }
    
}

// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension BatikViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[.originalImage] as? UIImage {
            
            batikImageView.image = chosenImage
            
            guard let batikImage = CIImage(image: chosenImage) else {
                fatalError("Error converting UIImage to CIImage")
            }
            
            ClassificationService.shared.detect(image: batikImage) { (result, error) in
                if let err = error {
                    print("Error: \(err)")
                    return
                }
                if let batikResult = result {
                    let batikName = batikResult.identifier.capitalized
                    self.showBatikExplanation()
                    self.batikTitleLabel.text = batikName
                    
                    NetworkService.shared.fetch(name: batikName) { (batik, error) in
                        if let err = error {
                            print(err)
                            return
                        }
                        if let batik = batik {
                            let description = Array(batik.query.pages.values)[0].extract
                            let firstInfo = description?.components(separatedBy: ".")[0] ?? "Sorry! Information Unavailable"
                            self.batikDescriptionLabel.text = firstInfo
                            self.removeEmptyLabel()
                        }
                    }
                }
            }
            
            imagePicker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
