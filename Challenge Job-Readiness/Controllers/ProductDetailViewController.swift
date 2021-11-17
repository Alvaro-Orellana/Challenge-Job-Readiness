//
//  ProductDetailViewController.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 17/11/2021.
//

import UIKit


class ProductDetailViewController: UIViewController {

    typealias FinalProduct = Body
    
    @IBOutlet weak var testLabel: UILabel!
    var selectedProduct: FinalProduct?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = "Title: \(selectedProduct?.title) Price: \(selectedProduct?.price)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
