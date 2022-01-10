//
//  ImageTableViewController.swift
//  SlideImage
//
//  Created by 羅壽之 on 2020/12/17.
//

import UIKit

class DetailViewController: UITableViewController {
    
    @IBOutlet var placeTitle: UILabel!
    @IBOutlet var pageIndicator: UIPageControl!
    
    var restaurant: Restaurant!
    
    var scene = Scene()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTitle.text = scene.name
        pageIndicator.numberOfPages = scene.photoCount
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
   
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for:indexPath)
        
        cell.textLabel?.text = scene.summary
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPager"{
            let des = segue.destination as! PageViewController
            des.scene = scene
      
            des.indexDelegate = self
        }
    }
}


extension DetailViewController: PageIndexDelegate{
    func didUpdatePageIndex(currentIndex: Int) {
        pageIndicator.currentPage = currentIndex
    }
    
}
