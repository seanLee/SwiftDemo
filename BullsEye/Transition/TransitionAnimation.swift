//
//  TransitionAnimation.swift
//  BullsEye
//
//  Created by sean on 16/4/13.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

public class TransitionAnimation: NSObject {
    public var startPoint = CGPointZero {
        didSet {
            bubble.center = startPoint;
        }
    }
    
    public var duration = 0.5;
    
    public var transitionMode:BubbleTransitionMode = .Prensent;
    
    public var bubbleColor:UIColor = .whiteColor();
    
    public private(set) var bubble = UIView();
    
    @objc public enum BubbleTransitionMode: Int {
        case Prensent, Dismiss, Pop
    };
}

extension TransitionAnimation:UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration;
    };
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            return;
        }
        if transitionMode == .Prensent {
            let presentControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!;
            let originCenter = presentControllerView.center;
            let originalSize = presentControllerView.frame.size;
            
            bubble = UIView();
            bubble.frame = frameForBubble(originCenter, size: originalSize, start: startPoint);
            bubble.layer.cornerRadius = bubble.frame.size.height / 2;
            bubble.center = startPoint;
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.backgroundColor = bubbleColor;
            containerView.addSubview(bubble);
            
            presentControllerView.center = startPoint;
            presentControllerView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(CGFloat(M_PI)), CGAffineTransformMakeScale(0.001, 0.001));
            presentControllerView.alpha = 1;
            containerView.addSubview(presentControllerView);

            UIView.animateWithDuration(duration, animations: {
                self.bubble.transform = CGAffineTransformIdentity;
                presentControllerView.transform = CGAffineTransformIdentity;
                presentControllerView.alpha = 1;
                presentControllerView.center = originCenter;
                }, completion: { (_) in
                    transitionContext.completeTransition(true);
            })
        } else {
            let key = (transitionMode == .Pop) ? UITransitionContextToViewKey : UITransitionContextFromViewKey;
            let returningControllerView = transitionContext.viewForKey(key)!;
            let originalCenter = returningControllerView.center;
            let originalSize = returningControllerView.frame.size;
            
            bubble.frame = frameForBubble(originalCenter, size:originalSize , start: startPoint);
            bubble.layer.cornerRadius = bubble.frame.size.height / 2;
            bubble.center = startPoint;
            
            UIView.animateWithDuration(duration, animations: { 
                self.bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-CGFloat(M_PI)), CGAffineTransformMakeScale(0.001, 0.001))
                returningControllerView.center = self.startPoint;
                returningControllerView.alpha = 0
                
                if self.transitionMode == .Pop {
                    containerView.insertSubview(returningControllerView, belowSubview: returningControllerView);
                    containerView.insertSubview(self.bubble, belowSubview: returningControllerView);
                }
                
                }, completion: { (_) in
                    returningControllerView.center = originalCenter;
                    returningControllerView.removeFromSuperview();
                    self.bubble.removeFromSuperview();
                    transitionContext.completeTransition(true);
            })
        }
    }
}

private extension TransitionAnimation {
    private func frameForBubble(originCenter: CGPoint, size originSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originSize.width - start.x);
        let lengthY = fmax(start.y, originSize.height - start.y);
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
        let size = CGSize(width: offset, height: offset);
        
        return CGRect(origin: CGPointZero, size: size);
    }
}
