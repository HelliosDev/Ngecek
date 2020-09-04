//
//  BatikML.swift
//  Ngecek
//
//  Created by Wendy Kurniawan on 03/09/20.
//  Copyright © 2020 Wendy Kurniawan. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ClassificationService {
    
    static let shared = ClassificationService()
    
    func detect(image: CIImage, completion: @escaping(VNClassificationObservation?, Error?) -> Void) {
        guard let model = try? VNCoreMLModel(for: BatikClassifier().model) else {
            fatalError("CoreML Loading Failed")
        }
        
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            if let err = error {
                completion(nil, err)
            }
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("Error getting classification")
            }
            completion(result, nil)
        })
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
