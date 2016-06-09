//
//  FirstViewController.swift
//  DYK
//
//  Created by Navarjun Singh on 06/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit
import Amplitude_iOS
import Branch


class FactViewController: UIViewController, SuperViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static var identifier = "factViewController"

    var scrollCount:Int = 0

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var factContainerView: UIScrollView!
    @IBOutlet weak var noMoreFactsView: UIView!
    @IBOutlet weak var downvoteButton: AnimatedButton!
    @IBOutlet weak var upvoteButton: AnimatedButton!
    @IBOutlet weak var shareButton: AnimatedButton!
    @IBOutlet weak var factsCollectionView: UICollectionView!


    var factUserEntry = PFObject(className:"UserFacts")

    private enum ButtonTags: Int {
        case Downvote   = 10
        case Share      = 11
        case Upvote     = 12
    }
    
    private var activeFact: Int {
        get {
            let pageWidth = factsCollectionView.frame.size.width;
            print(Int(factsCollectionView.contentOffset.x / pageWidth))
            return Int(factsCollectionView.contentOffset.x / pageWidth)
        }
    }
    private var factsArray: [DYKFact] = [] {
        didSet {
            factsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func fetchFactsNetworkingHelper() {

        NetworkingHelper.sharedInstance.fetchFacts({ (facts) -> Void in
            if let facts = facts {
//                self.factsArray = facts
                self.factsArray += facts
                if (self.factsArray.count != 0) {
                    self.hideNoMoreFactsView(true)
                } else {
                    // Show no more facts view
                    self.hideNoMoreFactsView(false)
                }
                self.stopActivityIndicator()
            }

        }) { (err) -> Void in
            ErrorsHelper.sharedInstance.notifyError(err, overViewController: self)
        }

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        fetchFactsNetworkingHelper()

    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func hideNoMoreFactsView(hidden: Bool) {
        if hidden {
            UIView.animateWithDuration(0.2, animations: {
                    self.noMoreFactsView.alpha = 0
                }, completion: { _ in
                    self.noMoreFactsView.hidden = true
                })
        } else {
            noMoreFactsView.alpha = 0
            noMoreFactsView.hidden = false
            UIView.animateWithDuration(0.2, animations: {
                self.noMoreFactsView.alpha = 1
            })
        }
        
    }
    
    // MARK: - FactViewDelegate
    @IBAction func buttonAction(sender: UIButton) {
        let fact = factsArray[activeFact]
        let factId = fact.objectId!
        switch sender.tag {
        case ButtonTags.Downvote.rawValue:
            NetworkingHelper.sharedInstance.userAction(DYKUserFactActionType.Downvote, onFactId: factId,
                success: { (response) -> Void in
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
//                        self.upvoteButton.backgroundColor = greyColor(1)
//                        self.downvoteButton.backgroundColor = redColor(1)
                        fact.action = .Downvote

                        //downvote event
                        let tracker = GAI.sharedInstance().defaultTracker
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "vote_down", label: "vote_down", value: 1).build()  as [NSObject : AnyObject])
                        Amplitude.instance().logEvent("vote_down")

                        let user = PFUser.currentUser()
                        if (user != nil) {

                            self.factUserEntry["status"] = "downvote"
                            self.factUserEntry.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // TODO: The object has been saved.
                                } else {
                                    // TODO: There was a problem, check error.description
                                }
                            }
                        }

                    })
                }, failure: { (error) -> Void in
                    ErrorsHelper.sharedInstance.notifyError(error, overViewController: self)
            })
            
        case ButtonTags.Upvote.rawValue:
            NetworkingHelper.sharedInstance.userAction(DYKUserFactActionType.Upvote, onFactId: factId,
                success: { (response) -> Void in
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
//                        self.downvoteButton.backgroundColor = greyColor(1)
//                        self.upvoteButton.backgroundColor = greenColor(1)
                        fact.action = .Upvote

                        //upvote event
                        let tracker = GAI.sharedInstance().defaultTracker
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "vote_up", label: "vote_up", value: 1).build()  as [NSObject : AnyObject])
                        Amplitude.instance().logEvent("vote_up")

                        let user = PFUser.currentUser()
                        if (user != nil) {

                            self.factUserEntry["status"] = "upvote"
                            self.factUserEntry.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                } else {
                                    // There was a problem, check error.description
                                }
                            }
                        }


                        
                    })
                }, failure: { (error) -> Void in
                    ErrorsHelper.sharedInstance.notifyError(error, overViewController: self)
            })

        case ButtonTags.Share.rawValue:
            break
            
        default:
            break
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        self.scrollCount++
        print(scrollCount)

        scrollView.userInteractionEnabled = true




//        switch factsArray[activeFact].action {
//            case .Upvote:
//                upvoteButton.backgroundColor = greenColor(1)
//                downvoteButton.backgroundColor = greyColor(1)
//            case .Downvote:
//                upvoteButton.backgroundColor = greyColor(1)
//                downvoteButton.backgroundColor = redColor(1)
//            case .Unknown:
//                upvoteButton.backgroundColor = greenColor(1)
//                downvoteButton.backgroundColor = redColor(1)
//        }
//        

    }

    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        scrollView.userInteractionEnabled = false

    }


    func scrollViewDidScroll(scrollView: UIScrollView) {


        if scrollCount == 3{
            //swipe_3
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "swipe_3", label: "swipe_3", value: 1).build()  as [NSObject : AnyObject])
            Amplitude.instance().logEvent("swipe_3")

        }

        if scrollCount == 7 {
            //swipe_7
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "swipe_7", label: "swipe_7", value: 1).build()  as [NSObject : AnyObject])
            Amplitude.instance().logEvent("swipe_7")
        }

        if scrollCount == 10 {
            //swipe_10
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "swipe_10", label: "swipe_10", value: 1).build()  as [NSObject : AnyObject])
            Amplitude.instance().logEvent("swipe_10")

        }
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return CGSize(width: collectionView.frame.width/1.15, height: collectionView.frame.height)

    }


    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }

    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }


    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        print("indexpath \(indexPath.item)")
        print("factsarray \(factsArray.count)")
        if(indexPath.item == factsArray.count - 1){
            //Last cell was drawn
            fetchFactsNetworkingHelper()
        }


        let identifier = "factCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        let fact = factsArray[indexPath.item]
        if let label = cell.viewWithTag(1) as? UILabel {
            
            label.text = fact.factContent
        }
        // TODO: Mark fact as seen by user.

        let user = PFUser.currentUser()
        var factUserEntry = PFObject(className:"UserFacts")
        self.factUserEntry = factUserEntry

        if (user != nil) {
            self.factUserEntry["userID"] = user
            self.factUserEntry["factID"] = fact
            self.factUserEntry["status"] = "seen"
            self.factUserEntry.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
        }

        
        return cell
    }



    //Branch

    func shareFact() {

        let user = PFUser.currentUser()
        if (user != nil) {
            let username = user?.username
            let name = user?.email
        }

        var params = [ "referringUsername": "Bob",
                       "referringUserId": "1234" ]




//    var params = [ "referringUsername": "Bob",
//                   "referringUserId": "1234" ]
    Branch.getInstance().getShortURLWithParams(params, andCallback: { (url: String!, error: NSError!) -> Void in
    if (error == nil) {
    // Now we can do something with the URL...
    NSLog("url: %@", url);
    }
    })

    }
    
}

