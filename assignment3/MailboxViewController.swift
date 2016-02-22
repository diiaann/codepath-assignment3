//
//  MailboxViewController.swift
//  assignment3
//
//  Created by Diandian Xiao on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit


class MailboxViewController: UIViewController {

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
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInitialCenter = messageImage.center
        
        print("message initial center", messageInitialCenter)
        
        scrollView.contentSize = CGSize(width: 320, height: 1000)
        
        //might have to save laterIconImage position
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?){
        if motion == .MotionShake {
            scootFeedDown()
        }
    }

    @IBAction func didMessagePan(sender: UIPanGestureRecognizer) {

        let translation = sender.translationInView(view)
        let location = sender.locationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            messageImageOriginalCenter = messageImage.center
            rightIconOriginalCenter = laterIconImage.center
            leftIconOriginalCenter = archiveIconImage.center
            
        }
        
        else if (sender.state == UIGestureRecognizerState.Changed) {
            
            //always the pan the message
            messageImage.center = CGPoint(x: messageImageOriginalCenter.x + translation.x, y: messageImageOriginalCenter.y)
            
            
            if (translation.x < -60 && translation.x > -260) {
                
                laterIconImage.hidden = false
                listIconImage.hidden = true

                laterIconImage.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + 60, y: rightIconOriginalCenter.y)
                
                laterIconImage.backgroundColor = UIColor(red: 251/255, green: 212/255, blue: 13/255, alpha: 1.0)

                messageView.backgroundColor = UIColor(red: 251/255, green: 212/255, blue: 13/255, alpha: 1.0)
    
            }
            else if (translation.x <= -260) {
                

                laterIconImage.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + 60, y: rightIconOriginalCenter.y)
                
                listIconImage.center = laterIconImage.center
                
                listIconImage.hidden = false
                laterIconImage.hidden = true
                archiveIconImage.hidden = true
                deleteIconImage.hidden = true
                
                messageView.backgroundColor = UIColor(red: 217/255, green: 167/255, blue: 113/255, alpha: 1.0) /* #d9a771 */
            }
            else if (translation.x > 60 && translation.x < 260) {
                onlyShowThisIcon(archiveIconImage)
                
                archiveIconImage.backgroundColor = UIColor(red: 108/255, green: 219/255, blue: 91/255, alpha: 1.0) /* #6cdb5b */
                
                archiveIconImage.center = CGPoint(x: leftIconOriginalCenter.x + translation.x - 60, y: leftIconOriginalCenter.y)
                messageView.backgroundColor = UIColor(red: 108/255, green: 219/255, blue: 91/255, alpha: 1.0) /* #6cdb5b */
            }
            
            else if (translation.x >= 260) {
                
                archiveIconImage.center = CGPoint(x: leftIconOriginalCenter.x + translation.x - 60, y: leftIconOriginalCenter.y)
                
                deleteIconImage.center = archiveIconImage.center
                
                onlyShowThisIcon(deleteIconImage)

                messageView.backgroundColor = UIColor(red: 237/255, green: 83/255, blue: 41/255, alpha: 1.0) /* #ed5329 */
    
            }
        }
            
            
        else if (sender.state == UIGestureRecognizerState.Ended)  {
            listIconImage.hidden = true
            
            // less than 60, put everything back i n place
            if (translation.x > -60 && translation.x < 60) {
                messageImage.center = CGPoint(x: messageImageOriginalCenter.x, y: messageImageOriginalCenter.y)
                laterIconImage.center = CGPoint(x: rightIconOriginalCenter.x, y: rightIconOriginalCenter.y)
                
                listIconImage.center = CGPoint(x: rightIconOriginalCenter.x, y: rightIconOriginalCenter.y)
                
                archiveIconImage.center = CGPoint(x: leftIconOriginalCenter.x, y: leftIconOriginalCenter.y)
            }
            else if (translation.x < -60 && translation.x > -260) {
                //animate the thing
                UIView.animateWithDuration(0.6, animations: { () -> Void in
                    
                    self.archiveIconImage.hidden = true
                    self.messageImage.transform = CGAffineTransformMakeTranslation(-320, 0)
                    self.laterIconImage.transform = CGAffineTransformMakeTranslation(-260, 0)
                })
                delay(0.2) {
                    
                    UIView.animateWithDuration(0.6, animations: { () -> Void in
                        self.rescheduleImage.alpha = 1
                    })
                }
            }
            else if (translation.x <= -260) {
                UIView.animateWithDuration(0.6, animations: { () -> Void in
                    
                    self.listIconImage.hidden = true
                    self.messageImage.transform = CGAffineTransformMakeTranslation(-320, 0)
                    self.listIconImage.transform = CGAffineTransformMakeTranslation(-260, 0)
                })
                delay(0.2) {
                    
                    UIView.animateWithDuration(0.6, animations: { () -> Void in
                        self.listSelectionImage.alpha = 1
                    })
                }
                
            }
            
            else if (translation.x > 60 && translation.x < 260 ) {
                UIView.animateWithDuration(0.6, animations: { () -> Void in
                    
                    self.archiveIconImage.hidden = true
                    self.messageImage.transform = CGAffineTransformMakeTranslation(320, 0)
                })
                scootFeedUp()

            }
            else if (translation.x > 260) {
                UIView.animateWithDuration(0.6, animations: { () -> Void in
                    
                    self.deleteIconImage.hidden = true
                    self.messageImage.transform = CGAffineTransformMakeTranslation(320, 0)
                })
                scootFeedUp()
            }
        }
    }

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
        messageImage.transform = CGAffineTransformMakeTranslation(0, 0)
        messageImage.center = messageImageOriginalCenter
        
        listIconImage.hidden = false
        laterIconImage.hidden = false
        archiveIconImage.hidden = false
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
    
    func onlyShowThisIcon(icon: UIImageView){
        laterIconImage.hidden = true
        listIconImage.hidden = true
        archiveIconImage.hidden = true
        deleteIconImage.hidden = true
        
        icon.hidden = false
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
