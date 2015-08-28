//
//  ViewController.swift
//  SampleAsyn
//
//  Created by Arthit Thongpan on 8/28/2558 BE.
//  Copyright (c) 2558 Arthit Thongpan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var data:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = []
        self.tableView.dataSource = self
        loadData()
    }
    
    
    func loadData(){
        let url = NSURL(string: "https://itunes.apple.com/search?term=Beatles&media=music&entity=album")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { [weak self] response, data, error in
            
            
            if(error != nil) {
                
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            if(err != nil) {
                
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            //Read Data
            let results:NSArray = jsonResult["results"] as! NSArray
            for dic in results{
                print(dic)
                let imageURL = dic["artworkUrl100"] as? String ?? ""
                self?.data.append(imageURL);
                
            }
            
            
            //สนใจแค่ข้างล่างนี้นะครับ 
            dispatch_async(dispatch_get_main_queue(), {
                    self?.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CustomCell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
        }
        let str = data[indexPath.row] as String
        cell!.textLabel?.text = str
       
        
        return cell!
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

