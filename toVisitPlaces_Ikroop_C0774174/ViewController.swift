//
//  ViewController.swift
//  toVisitPlaces_Ikroop_C0774174
//
//  Created by VirkIkroop on 2020-06-14.
//  Copyright © 2020 VirkIkroop. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
        
        var places : [Places]?
        
        var deleteArray : [Places]?
        
        let defaults = UserDefaults.standard
        
        override func viewDidLoad() {
            super.viewDidLoad()
          tableView.delegate = self
           tableView.dataSource = self
            
            

            
            
        }
        
      override func viewWillAppear(_ animated: Bool) {
           loadData()
          self.tableView.reloadData()
            
        }
        
        func getDataFilePath() -> String {
               let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
               let filePath = documentPath.appending("/places-data.txt")
               return filePath
           }
        
        func loadData() {
            places = [Places]()
            
            let filePath = getDataFilePath()
            
            if FileManager.default.fileExists(atPath: filePath){
                do{
                    
                 let fileContent = try String(contentsOfFile: filePath)
                    
                    let contentArray = fileContent.components(separatedBy: "\n")
                    for content in contentArray{
                       
                        let placeContent = content.components(separatedBy: ",")
                        if placeContent.count == 6 {
                            let place = Places(placeLat: Double(placeContent[0]) ?? 0.0, placeLong: Double(placeContent[1]) ?? 0.0, placeName: placeContent[2], city: placeContent[3], postalCode: placeContent[4], country: placeContent[5])
                            places?.append(place)
                        }
                }
                   
    
                }
                catch{
                    print(error)
                }
            }
        }
        
        func deleteRow() {
            let filePath = getDataFilePath()

            var saveString = ""
            for place in self.deleteArray!{
               saveString = "\(saveString)\(place.placeLat),\(place.placeLong),\(place.placeName),\(place.city),\(place.country),\(place.postalCode)\n"
                do{
               try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
                }
                catch{
                    print(error)
                }
            }
        }

      

        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return places?.count ?? 0
        }

        
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let place = self.places![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")
            cell?.textLabel?.text = place.placeName + " , " + place.city
            cell?.detailTextLabel?.text = place.country + " , " + place.postalCode
        
    
            return cell!
        }
        
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let editedPlace =  self.places![indexPath.row]
            
            defaults.set(editedPlace.placeLat, forKey: "latitude")
            defaults.set(editedPlace.placeLong, forKey: "longitude")
            defaults.set(true, forKey: "bool")
            
            let mapViewVC = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
            mapViewVC.dragablePin()
            self.navigationController?.pushViewController(mapViewVC, animated: true)
            
    
        }

        
        
       
        
         func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
    
            if editingStyle == .delete {
                
                self.places?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                self.deleteArray = self.places
                deleteRow()
                
   
                
            } else if editingStyle == .insert {
                
            }
        }
        

        

    }

    
    
  
