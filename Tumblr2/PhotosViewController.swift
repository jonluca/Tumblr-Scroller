//
//  PhotosViewController.swift
//  Tumblr2
//
//  Created by JonLuca De Caro on 9/18/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary] = []
    var mult: Int = 0;
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
                                                         completionHandler: { (data, response, error) in
                                                            if let data = data {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                    with: data, options:[]) as? NSDictionary {
                                                                    print("responseDictionary: \(responseDictionary)")
                                                                    
                                                                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                                                                    // This is how we get the 'response' field
                                                                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                                                                    
                                                                    // This is where you will store the returned array of posts in your posts property
                                                                    self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                                                                    self.tableView.reloadData()
                                                                    refreshControl.endRefreshing()
                                                                }
                                                            }
        });
        task.resume()
    }
    func loadMoreData() {
        mult += 20
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(mult)")
        let request = URLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
                                                         completionHandler: { (data, response, error) in
                                                            if let data = data {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                    with: data, options:[]) as? NSDictionary {
                                                                    print("responseDictionary: \(responseDictionary)")
                                                                    
                                                                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                                                                    // This is how we get the 'response' field
                                                                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                                                                    
                                                                    // This is where you will store the returned array of posts in your posts property
                                                                    let newPosts: [NSDictionary] = responseFieldDictionary["posts"] as! [NSDictionary]
                                                                    self.posts += newPosts
                                                                
                                                                    
                                                                    self.tableView.reloadData()
                                                                }
                                                            }
        });
        task.resume()
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        
    }
    var isMoreDataLoading = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            
            isMoreDataLoading = true
            
            // Code to load more results
            loadMoreData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.refreshControlAction), for: UIControlEvents.valueChanged)
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
                                                         completionHandler: { (data, response, error) in
                                                            if let data = data {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                    with: data, options:[]) as? NSDictionary {
                                                                    print("responseDictionary: \(responseDictionary)")
                                                                    
                                                                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                                                                    // This is how we get the 'response' field
                                                                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                                                                    
                                                                    // This is where you will store the returned array of posts in your posts property
                                                                    self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                                                                    self.tableView.reloadData()
                                                                }
                                                            }
        });
        task.resume()
        tableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 240;
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = NSURL(string: imageUrlString!) {
                cell.photoImageView.setImageWith(imageUrl as URL)
            } else {
                // NSURL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        let currentCell = tableView.cellForRow(at: indexPath!)! as! PhotoCell
        
        vc.image = currentCell.photoImageView.image
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
