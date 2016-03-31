//
//  HomeTableViewController.swift
//  PetGag
//
//  Created by Akshita Malhotra on 3/29/16.
//  Copyright © 2016 PetGag. All rights reserved.
//

import UIKit


extension UIImageView {
   
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image

            }
        }).resume()
    }
}

class HomeTableViewController: UITableViewController, FBSDKLoginButtonDelegate {

    var trendingItems : Array<TrendingObject> = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)

        let rect = CGRect(
            origin: CGPoint(x: 0, y: 10),
            size: CGSize(
                width: 375,
                height: 40
            )
        )
        
        self.tableView.tableHeaderView = UISearchBar(frame: rect)
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            //            let loginManager = FBSDKLoginManager()
            //            loginManager.logOut() // this is an instance function
            
            
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
            trendingItems = self.fetchTrendingItems();
            
            self.tableView.reloadData();
            
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.trendingItems.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        
        let imageName = "placeholder.png"
       
        let rect = CGRect(
            origin: CGPoint(x: 10, y: 10),
            size: CGSize(
                width: 355,
                height: 140
            )
        )

        
        let imageView = UIImageView(frame: rect) as UIImageView;
        
        imageView.image = UIImage.init(named: imageName)
        
        imageView.frame = rect;
        
        imageView.downloadedFrom(link: trendingItems[indexPath.row].imageURLAsString, contentMode: UIViewContentMode.ScaleToFill)
        
        
        cell.addSubview(imageView);
        
        let upVoteButton   = UIButton(type: UIButtonType.System) as UIButton
        upVoteButton.frame = CGRectMake(10, 160, 30, 30)
        
        let upVoteButtonImage = "thumb_up.png"
        
        upVoteButton.setImage(UIImage.init(named: upVoteButtonImage), forState: UIControlState.Normal)
        upVoteButton.tintColor = UIColor.darkGrayColor();
        cell.addSubview(upVoteButton)
        
    
        
        let downVoteButton   = UIButton(type: UIButtonType.System) as UIButton
        downVoteButton.frame = CGRectMake(50, 160, 30, 30)
        
        let downVoteButtonImage = "thumb_down.png"
        
        downVoteButton.setImage(UIImage.init(named: downVoteButtonImage), forState: UIControlState.Normal)
        downVoteButton.tintColor = UIColor.darkGrayColor();
        cell.addSubview(downVoteButton)
        
        
        let commentsButton   = UIButton(type: UIButtonType.System) as UIButton
        commentsButton.frame = CGRectMake(93, 160, 30, 30)
        
        let commentsButtonImage = "comments.png"
        
        commentsButton.setImage(UIImage.init(named: commentsButtonImage), forState: UIControlState.Normal)
        commentsButton.tintColor = UIColor.darkGrayColor();
        cell.addSubview(commentsButton)
        
        
        let line = UIView(frame: CGRect(x: 0, y: 199, width: 375, height: 1));
        line.backgroundColor = UIColor.lightGrayColor();
        
        
        cell.addSubview(line)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //api calls
    
    func fetchTrendingItems() ->Array<TrendingObject>{
        
        let trendingObject = TrendingObject.init();
        trendingObject.imageURLAsString = "https://v.cdn.vine.co/r/avatars/050772A5341197694558906068992_35c56600b3a.2.1.jpg?versionId=2QyvDQhrHIvG01OZYYaTl4aVZ89k5l4t";
        trendingObject.numberOfUpVotes = 10;
        trendingObject.numberOfDownVotes = 5;
        
        
        let trendingObject2 = TrendingObject.init();
        trendingObject2.imageURLAsString = "https://pbs.twimg.com/profile_images/521554275713830913/TBY5IslL.jpeg";
        trendingObject2.numberOfUpVotes = 20;
        trendingObject2.numberOfDownVotes = 3;
        
        let trendingObject3 = TrendingObject.init();
        trendingObject3.imageURLAsString = "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRqU7nNVUYaCGsWLI5QXCWQqo7lHKkpTJzOy9KrnN1AXevvLJ1N";
        trendingObject3.numberOfUpVotes = 16;
        trendingObject3.numberOfDownVotes = 15;
        
        
        let trendingObject4 = TrendingObject.init();
        trendingObject4.imageURLAsString = "http://static.boredpanda.com/blog/wp-content/org_uploads/2014/06/image92.jpg";
        trendingObject4.numberOfUpVotes = 4;
        trendingObject4.numberOfDownVotes = 23;
        
        
        
        
        return [trendingObject,trendingObject2,trendingObject3];
    }
    
}
