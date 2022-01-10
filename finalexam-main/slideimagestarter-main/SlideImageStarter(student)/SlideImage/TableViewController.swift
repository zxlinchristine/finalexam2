//
//  TableViewController.swift
//  SlideImage
//
//  Created by 羅壽之 on 2020/12/17.
//

import UIKit

class TableViewController: UITableViewController {
    
    var appDelegate: AppDelegate!
    var restaurants:[Restaurant] = []
    
    var scenes = [
        Scene(name: "Taipei 101", city: "Taipei", address: "Taipei 101, Taipei", summary: "The Taipei 101 (台北101) is a supertall skyscraper designed by C.Y. Lee and C.P. Wang in Xinyi, Taipei, Taiwan. This building was officially classified as the world's tallest from its opening in 2004 until the 2010 completion of the Burj Khalifa in Dubai, UAE.", photoCount: 2, image1: "photo0_0", image2: "photo0_1", image3: nil),
        Scene(name: "Taroko National Park", city: "Hualien", address: "Taroko National Park, Hualien, Taiwan", summary: "Taroko National Park (太魯閣國家公園) is one of the nine national parks in Taiwan and was named after the Taroko Gorge, the landmark gorge of the park carved by the Liwu River. The park spans Taichung Municipality, Nantou County, and Hualien County and is located at Xiulin Township, Hualien County, Taiwan.",photoCount: 3, image1: "photo1_0", image2: "photo1_1", image3: "photo1_2"),
        Scene(name: "Kenting National Park", city: "Pingtung", address: "Kenting National Park, Taiwan",summary: "Kenting National Park (墾丁國家公園) is a national park located on the Hengchun Peninsula of Pingtung County, Taiwan, covering Hengchun, Checheng, and Manzhou Townships. Established on 1 January 1984, it is Taiwan's oldest and the southernmost national park on the main island, covering the southernmost area of the Taiwan island along Bashi Channel.", photoCount: 2, image1: "photo2_0", image2: "photo2_1", image3: nil)
        ]
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    // MARK: - UITableView Swipe Actions
    
    //swipe-to-right
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Mark as favorite action
        let actionTitle = restaurants[indexPath.row].isFavorite ? "uncheck" : "check"
        let favoriteAction = UIContextualAction(style: .destructive, title: actionTitle) { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
            //update source array
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            
            //save the data change when mark or unmark the favorites
            self.appDelegate.saveContext()
            
            //update the cell's accessoryType
            cell.accessoryType = self.restaurants[indexPath.row].isFavorite ? .checkmark : .none
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // change the background color of the action button
        favoriteAction.backgroundColor = UIColor.systemYellow
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
        
        return swipeConfiguration
    }
    
    //swipe-to-left
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        //disable the swiping action during the searching
        if searchController.isActive { return UISwipeActionsConfiguration() }

        
        //Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            // Delete the data from the data store
            self.managedContext.delete(restaurant)
            self.appDelegate.saveContext()

            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the button's color
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")

        
        // Configure the action as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
   
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return scenes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for:indexPath)
            
            cell.textLabel?.text = scenes[indexPath.row].name
            cell.detailTextLabel?.text = scenes[indexPath.row].city
            
            return cell
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let des = segue.destination as! DetailViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            des.scene = scenes[selectedRow]
        }
    }
    
}
