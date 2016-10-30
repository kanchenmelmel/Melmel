



//  MelGuideTableViewController.swift
//  Melmel
//
//  Created by Work on 30/03/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Presentr

class MelGuideTableViewController: UITableViewController,UISearchBarDelegate {
    
    
    
    
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var posts:[Post] = []
    let pendingOperations = PendingOperations()
    var isLoading = false
    
    var reachabilityManager = ReachabilityManager.sharedReachabilityManager
    var alert = Alert()
    
    var numOfPosts:Int?
    var reachToTheEnd = false
    
    var searchBlankView = UIView()
    
    // Popup Presenter
    let filterPresenter:Presentr = {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 113.0)
        //        let screenHeight = UIScreen.main.bounds.height
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x:0,y:65))
        let presenter = Presentr(presentationType: .custom(width: width, height: height, center: center))
        presenter.transitionType = TransitionType.crossDissolve
        presenter.backgroundOpacity = 0
        presenter.roundCorners = false
        
        return presenter
    }()
    
    let messagePresenter:Presentr?
    
    
    @IBOutlet weak var loadMorePostsLabel: UILabel!
    @IBOutlet weak var LoadMoreActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let activityIndicatorView = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
    
    override func viewDidLoad() {
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        super.viewDidLoad()
        
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        setupBlankView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DiscountTableViewController.handleTap))
        self.searchBlankView.addGestureRecognizer(tap)
        
        searchBar.delegate = self
        
        LoadMoreActivityIndicator.isHidden = true
        
        
        
        // Initialize Posts
        let coreDataUtility = CoreDataUtility()
        print("Earliest Date: \(coreDataUtility.getEarliestDate(EntityType.Post))")
        
        
        // Initialize the refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = DISCOUNT_TINT_COLOR
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(self.updatePosts), for: .valueChanged)
        self.refreshControl?.beginRefreshing()
        
        
        self.tableView.setContentOffset(CGPoint(x: 0,y:self.searchBar.bounds.height), animated: true)
        
        let postUpdateUtility = PostsUpdateUtility()
        posts = postUpdateUtility.fetchPosts()
        updatePosts()
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        navigationController?.hidesBarsOnSwipe = true
        
        activityIndicatorView.center = self.tableView.center
        self.tableView.addSubview(activityIndicatorView)
        
        
        
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBlankView.isHidden = true
        self.searchBar.resignFirstResponder()
    }
    
    func handleTap(){
        self.searchBlankView.isHidden = true
        self.searchBar.resignFirstResponder()
        
    }
    
    func setupBlankView(){
        
        let width = self.tableView.frame.size.width
        let height = self.tableView.frame.size.height
        let searchBarHeight = self.searchBar.bounds.height
        
        
        searchBlankView.frame = CGRect(x: 0.0, y: searchBarHeight, width: width, height: height)
        searchBlankView.backgroundColor = UIColor.black
        searchBlankView.alpha = 0.5
        self.view.addSubview(searchBlankView)
        self.searchBlankView.isHidden = true
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "melGuideTableViewCell", for: indexPath) as! MelGuideTableViewCell
        
        // Configure the cell...
        
        let post = posts[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = post.title!
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = "\(dateFormatter.string(from: post.date! as Date).uppercased())" + " "
        
        
        // Configure featured image
        
        if post.featured_image_downloaded == true {
            let fileDownloader = FileDownloader()
            post.featuredImage = fileDownloader.imageFromFile(post.id! as Int, fileName: FEATURED_IMAGE_NAME)
            post.featuredImageState = .downloaded
            
        } else {
            if post.featured_image_url != nil {
                if post.featuredImageState == .downloaded {
                    
                }
                if post.featuredImageState == .new {
                    if (!tableView.isDragging && !tableView.isDecelerating){
                        startOperationsForPhoto(post, indexPath: indexPath)
                    }
                }
                
            }
            
        }
        cell.featuredImage.image = post.featuredImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).row == posts.count-1) && !isLoading{
            isLoading = true
            if reachToTheEnd == false{
                self.LoadMoreActivityIndicator.isHidden = false
                self.LoadMoreActivityIndicator.startAnimating()
                
                self.loadMorePostsLabel.text = "加载中……"
                let oldestPost = posts[(indexPath as NSIndexPath).row]
                self.numOfPosts = self.posts.count
                loadPreviousPosts(oldestPost.date! as Date,excludeId: oldestPost.id as! Int)
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            loadImageForOnScreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImageForOnScreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations(){
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations(){
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImageForOnScreenCells(){
        if let pathsArray = tableView.indexPathsForVisibleRows{
            
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            for indexPath in toBeCancelled{
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath]{
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                
            }
            
            for indexPath in toBeStarted{
                let indexPath = indexPath as IndexPath
                let recordToProcess = self.posts[(indexPath as NSIndexPath).row]
                print("test")
                startOperationsForPhoto(recordToProcess, indexPath: indexPath)
            }
            
        }
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
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postSegue" {
            let postWebVeiwController = segue.destination as! PostWebPageViewController
            let path = tableView.indexPathForSelectedRow!
            postWebVeiwController.webRequestURLString = posts[(path as NSIndexPath).row].link
            postWebVeiwController.postid = String(describing: posts[(path as NSIndexPath).row].id!)
            navigationController?.isNavigationBarHidden = false
            navigationController?.hidesBarsOnSwipe = true
        }
        if segue.identifier == "searchResultSegue" {
            let searchResultTableViewCtrl = segue.destination as! SearchTableViewController
            searchResultTableViewCtrl.searchText = self.searchBar.text
            searchResultTableViewCtrl.postType = .Post
            
        }
    }
    
    
    
    // Image Download Operation Functions
    func startOperationsForPhoto(_ post:Post,indexPath:IndexPath) {
        switch (post.featuredImageState) {
        case .new:
            startDownloadFeaturedImageForPost (post:post,indexPath:indexPath)
        default: break
            //NSLog("Do nothing")
        }
    }
    
    func startDownloadFeaturedImageForPost(post:Post,indexPath:IndexPath) {
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        if reachabilityManager.isReachable(){
            let downloader = ImageDownloader(post: post)
            
            downloader.completionBlock = {
                if downloader.isCancelled {
                    return
                }
                DispatchQueue.main.async(execute: {
                    self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    post.featuredImageState = .downloaded
                })
            }
            
            pendingOperations.downloadsInProgress[indexPath] = downloader
            pendingOperations.downloadQueue.addOperation(downloader)
        }
        
        
    }
    
//    // Image download operation functions for discounts
//    func startOperationsForPhoto(discount:Discount,indexPath:NSIndexPath) {
//        switch (discount.featuredImageState) {
//        case .New:
//            startDownloadFeaturedImageForPost (discount:discount,indexPath:indexPath)
//        default: break
//            //NSLog("Do nothing")
//        }
//    }
//    
//    func startDownloadFeaturedImageForPost(discount discount:Discount,indexPath:NSIndexPath) {
//        if pendingOperations.downloadsInProgress[indexPath] != nil {
//            return
//        }
//        
//        if reachabilityManager.isReachable(){
//            let downloader = ImageDownloader(post: discount)
//            
//            downloader.completionBlock = {
//                if downloader.cancelled {
//                    return
//                }
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
//                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                    post.featuredImageState = .Downloaded
//                })
//            }
//            
//            pendingOperations.downloadsInProgress[indexPath] = downloader
//            pendingOperations.downloadQueue.addOperation(downloader)
//        }
//        
//        
//    }
    
    
    
    func updatePosts(){
        if reachabilityManager.isReachable(){
            print("is Reachable")
            let postUpdateUtility = PostsUpdateUtility()
            postUpdateUtility.updateAllPosts {
                
                DispatchQueue.main.async(execute: {
                    print("Update table view")
                    self.posts = postUpdateUtility.fetchPosts()
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.willMove(toSuperview: self.tableView)
                    self.refreshControl?.endRefreshing()
                })
            }
        } else {
            print("No Internet Connection")
            self.refreshControl?.endRefreshing()
            //  popUpWarningMessage("No Internet Connection")
            alert.showAlert(self)
            
        }
        
        
    }
    
    func loadPreviousPosts(_ oldestPostDate:Date,excludeId:Int){
        
        if reachabilityManager.isReachable(){
            
            let postsUpdateUtility = PostsUpdateUtility()
            postsUpdateUtility.getPreviousPosts(oldestPostDate,excludeId: excludeId) {
                DispatchQueue.main.async(execute: {
                    self.posts = postsUpdateUtility.fetchPosts()
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.willMove(toSuperview: self.tableView)
                    self.isLoading = false
                    self.LoadMoreActivityIndicator.stopAnimating()
                    self.LoadMoreActivityIndicator.isHidden = true
                    if self.numOfPosts == self.posts.count{
                        self.reachToTheEnd = true
                        self.loadMorePostsLabel.isHidden = true
                        self.LoadMoreActivityIndicator.isHidden = true
                    }
                })
            }
        } else {
            //popUpWarningMessage("No Internet Connection")
            alert.showAlert(self)
            self.isLoading = false
        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "searchResultSegue", sender: self.searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBlankView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBlankView.isHidden = true
    }
    
    

    
}
