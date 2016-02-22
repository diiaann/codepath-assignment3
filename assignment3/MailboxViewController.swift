//
//  MailboxViewController.swift
//  assignment3
//
//  Created by Diandian Xiao on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit


class MailboxViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var listIconImage: UIImageView!
    @IBOutlet weak var laterIconImage: UIImageView!
    @IBOutlet weak var deleteIconImage: UIImageView!
    @IBOutlet weak var archiveIconImage: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var listSelectionImage: UIImageView!
    
    @IBOutlet weak var feedImage: UIImageView!
    
    var messageInitialCenter: CGPoint!
    var messageImageOriginalCenter: CGPoint!
    var rightIconOriginalCenter: CGPoint!
    var leftIconOriginalCenter: CGPoint!
    var mainOriginalViewCenter:CGPoint!
    
    //TODO: more constants
    let firstIconThreshold:CGFloat = 60
    let secondIconThreshold:CGFloat = 260
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInitialCenter = messageImage.center
        
        scrollView.contentSize = CGSize(width: 320, height: 1000)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?){
        if motion == .MotionShake {
            scootFeedDown()
        }
    }

    @IBAction func didMessagePan(sender: UIPanGestureRecognizer) {

        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            messageImageOriginalCenter = messageImage.center
            rightIconOriginalCenter = laterIconImage.center
            leftIconOriginalCenter = archiveIconImage.center
            
        }
        
        //TODO: DRY
        else if (sender.state == UIGestureRecognizerState.Changed) {
            
            messageImage.center = CGPoint(x: messageImageOriginalCenter.x + translation.x, y: messageImageOriginalCenter.y)
            
            // fades in the icon
            if (translation.x < firstIconThreshold && translation.x > firstIconThreshold * -1) {
                archiveIconImage.alpha = (fabs(translation.x)/firstIconThreshold)
                laterIconImage.alpha = fabs(translation.x)/firstIconThreshold
            }
            
            else if (translation.x < -firstIconThreshold && translation.x > -secondIconThreshold) {
                
                laterIconImage.hidden = false
                listIconImage.hidden = true
                
                laterIconImage.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + firstIconThreshold, y: rightIconOriginalCenter.y)
                
                //TODO: anyway to just do this once, instead of firing everytime?
                messageView.backgroundColor = UIColor(red: 251/255, green: 212/255, blue: 13/255, alpha: 1.0)
    
            }
                
            else if (translation.x <= -secondIconThreshold) {
                
                //TODO: more elegant way to swap out
                laterIconImage.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + firstIconThreshold, y: rightIconOriginalCenter.y)
                
                listIconImage.center = laterIconImage.center
                
                setIconsHidden(true)
                listIconImage.hidden = false
                
                messageView.backgroundColor = UIColor(red: 217/255, green: 167/255, blue: 113/255, alpha: 1.0) /* #d9a771 */
            }
                
            else if (translation.x > firstIconThreshold && translation.x < secondIconThreshold) {
                setIconsHidden(true)
                archiveIconImage.hidden = false
                
                archiveIconImage.backgroundColor = UIColor(red: 108/255, green: 219/255, blue: 91/255, alpha: 1.0) /* #6cdb5b */
                
                archiveIconImage.center = CGPoint(x: leftIconOriginalCenter.x + translation.x - firstIconThreshold, y: leftIconOriginalCenter.y)
                messageView.backgroundColor = UIColor(red: 108/255, green: 219/255, blue: 91/255, alpha: 1.0) /* #6cdb5b */
            }
            
            else if (translation.x >= secondIconThreshold) {
                
                archiveIconImage.center = CGPoint(x: leftIconOriginalCenter.x + translation.x - firstIconThreshold, y: leftIconOriginalCenter.y)
                
                deleteIconImage.center = archiveIconImage.center
                
                setIconsHidden(true)
                deleteIconImage.hidden = false

                messageView.backgroundColor = UIColor(red: 237/255, green: 83/255, blue: 41/255, alpha: 1.0) /* #ed5329 */
    
            }
        }
            
            
        else if (sender.state == UIGestureRecognizerState.Ended)  {
            listIconImage.hidden = true
            
            // less than firstIconThreshold, put everything back i n place
            if (translation.x > -firstIconThreshold && translation.x < firstIconThreshold) {
                messageImage.center = CGPoint(x: messageImageOriginalCenter.x, y: messageImageOriginalCenter.y)
                laterIconImage.center = CGPoint(x: rightIconOriginalCenter.x, y: rightIconOriginalCenter.y)
                listIconImage.center = CGPoint(x: rightIconOriginalCenter.x, y: rightIconOriginalCenter.y)
                archiveIconImage.center = CGPoint(x: leftIconOriginalCenter.x, y: leftIconOriginalCenter.y)
            }
                
            else if (translation.x < -firstIconThreshold && translation.x > -secondIconThreshold) {
                //animate the thing
                exitAnimation(laterIconImage, coefficient: -1)
                
                delay(0.2) {
                    
                    UIView.animateWithDuration(0.6, animations: { () -> Void in
                        self.rescheduleImage.alpha = 1
                    })
                }
            }
            else if (translation.x <= -secondIconThreshold) {
                exitAnimation(listIconImage, coefficient: -1)
                delay(0.2) {
                    UIView.animateWithDuration(0.6, animations: { () -> Void in
                        self.listSelectionImage.alpha = 1
                    })
                }
                
            }
            
            else if (translation.x > firstIconThreshold && translation.x < secondIconThreshold ) {
                exitAnimation(archiveIconImage, coefficient: 1)
                scootFeedUp()

            }
            else if (translation.x > secondIconThreshold) {
                exitAnimation(deleteIconImage, coefficient: 1)
                scootFeedUp()
            }
        }
    }

    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {
        rescheduleImage.alpha = 0
        listSelectionImage.alpha = 0
        scootFeedUp()
    }
    
    @IBAction func didEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            mainOriginalViewCenter = mainView.center
        }
        
        else if (sender.state == UIGestureRecognizerState.Changed) {
            mainView.center = CGPoint(x: mainOriginalViewCenter.x + translation.x, y: mainOriginalViewCenter.y)
            
            
        }
        //TODO: Spring is a little aggressive
        else if (sender.state == UIGestureRecognizerState.Ended){
            if (velocity.x > 0 ) {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    self.mainView.center = CGPoint(x: self.mainOriginalViewCenter.x + 320, y: self.mainOriginalViewCenter.y)
                    
                    }, completion: { (Bool) -> Void in
                })
                
            }
            else {
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    self.mainView.center = CGPoint(x: self.mainOriginalViewCenter.x + 0, y: self.mainOriginalViewCenter.y)
                    
                    }, completion: { (Bool) -> Void in
                })
            }
        }
    }
    
    
    @IBAction func onMailboxHomePress(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainView.center = CGPoint(x: self.mainOriginalViewCenter.x + 0, y: self.mainOriginalViewCenter.y)
            
            }, completion: { (Bool) -> Void in
        })

    
    }
    
    // -------------------- HELPERS --------------------------------------------

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func scootFeedUp(){
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.feedImage.transform = CGAffineTransformMakeTranslation(0, -85)
        })
    }
    
    func scootFeedDown(){
        
        messageView.backgroundColor = UIColor.lightGrayColor()
        messageImage.transform = CGAffineTransformMakeTranslation(0, 0)
        messageImage.center = messageImageOriginalCenter
        
        setIconsHidden(false)
        
        archiveIconImage.center = CGPoint(x: 30, y: 42)
        laterIconImage.center = CGPoint(x: 290, y:42)
        
        listIconImage.transform = CGAffineTransformMakeTranslation(0, 0)
        laterIconImage.transform = CGAffineTransformMakeTranslation(0, 0)
        deleteIconImage.transform = CGAffineTransformMakeTranslation(0, 0)
        archiveIconImage.transform = CGAffineTransformMakeTranslation(0, 0)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.feedImage.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    func setIconsHidden(isHidden:Bool){
        laterIconImage.hidden = isHidden
        listIconImage.hidden = isHidden
        archiveIconImage.hidden = isHidden
        deleteIconImage.hidden = isHidden
    }
    
    func exitAnimation(icon: UIImageView, coefficient: CGFloat)  {
        
        setIconsHidden(true)
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            
            self.messageImage.transform = CGAffineTransformMakeTranslation(320 * coefficient, 0)
            if (coefficient == -1) {
                icon.transform = CGAffineTransformMakeTranslation(self.secondIconThreshold * coefficient, 0)
            }
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
