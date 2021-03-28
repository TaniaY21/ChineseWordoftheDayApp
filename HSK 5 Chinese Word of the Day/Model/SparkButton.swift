//
//  Designables.swift
//  HSK 5 Chinese Word of the Day
//
//  Created by Tania Yeromiyan on 23/12/2020.
//

import UIKit

@IBDesignable
class SparkButton: UIButton{
    
    var sparkView:SparkView!
    
    //    MARK: -Initializers
    override init (frame : CGRect) {
        super.init(frame : frame)
        setup()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.sparkView.frame = self.bounds
        self.insertSubview(self.sparkView, at: 0)
    }
    
    //    MARK: -Setup Methods
    func setup(){
        self.clipsToBounds = false;
        
        self.sparkView = SparkView()
        //        self.sparkView.backgroundColor = UIColor.redColor()
        self.insertSubview(self.sparkView, at: 0)
    }
    
    func animate () {
        let delay = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.sparkView.animate()
        };
    }
    
    //    MARK: Bouncing Animations
    func likeBounce (_ duration: TimeInterval) {
        self.transform = CGAffineTransform.identity
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.6, y: 1.6);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            })
            
        }, completion: {finished in
            
        })
        
    }
    
    func unLikeBounce (_ duration: TimeInterval) {
        self.transform = CGAffineTransform.identity
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            })
            
        }, completion: {finished in
            
        })
        
    }
    
}

@IBDesignable
class SparkView: UIView{
    
    var explosionInLayer:CAEmitterLayer!
    var explosionOutLayer:CAEmitterLayer!
    
    //    MARK: -Initializers
    override init (frame : CGRect) {
        super.init(frame : frame)
        setup()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY);
        self.explosionInLayer.emitterPosition = center;
        self.explosionOutLayer.emitterPosition = center;
    }
    
    //    MARK: -Setup Methods
    func setup(){
        self.clipsToBounds = false
        self.isUserInteractionEnabled = false
        let image = UIImage(named: "spark")
        let particleScale:CGFloat = 0.06
        let particleScaleRange:CGFloat = 0.03
        
        let explosionOutCell = CAEmitterCell()
        explosionOutCell.name = "explosion";
        explosionOutCell.alphaRange = 0.40;
        explosionOutCell.alphaSpeed = -1.0;  //-1.0
        explosionOutCell.lifetime = 0.8;
        explosionOutCell.lifetimeRange = 0.6;
        explosionOutCell.birthRate = 0;
        explosionOutCell.velocity = 50.00;
        explosionOutCell.velocityRange = 8.00;
        explosionOutCell.contents = image?.cgImage
        explosionOutCell.scale = particleScale
        explosionOutCell.scaleRange = particleScaleRange
        
        self.explosionOutLayer = CAEmitterLayer()
        self.explosionOutLayer.name = "emitterLayer";
        self.explosionOutLayer.emitterShape = CAEmitterLayerEmitterShape.circle;
        self.explosionOutLayer.emitterMode = CAEmitterLayerEmitterMode.outline;
        self.explosionOutLayer.emitterSize = CGSize(width: 30, height: 0);
        self.explosionOutLayer.emitterCells = [explosionOutCell];
        self.explosionOutLayer.renderMode = CAEmitterLayerRenderMode.oldestFirst;
        self.explosionOutLayer.masksToBounds = false;
        self.layer.addSublayer(self.explosionOutLayer)
        
        let explosionInCell = CAEmitterCell()
        explosionInCell.name = "charge";
        explosionInCell.alphaRange = 0.40;
        explosionInCell.alphaSpeed = -1.0;
        explosionInCell.lifetime = 0.4;
        explosionInCell.lifetimeRange = 0.2;
        explosionInCell.birthRate = 0;
        explosionInCell.velocity = -40.0;
        explosionInCell.velocityRange = 0.00;
        explosionInCell.contents = image?.cgImage
        explosionInCell.scale = particleScale
        explosionInCell.scaleRange = particleScaleRange
        
        self.explosionInLayer = CAEmitterLayer()
        self.explosionInLayer.name = "emitterLayer";
        self.explosionInLayer.emitterShape = CAEmitterLayerEmitterShape.circle;
        self.explosionInLayer.emitterMode = CAEmitterLayerEmitterMode.outline;
        self.explosionInLayer.emitterSize = CGSize(width: 30, height: 0);
        self.explosionInLayer.emitterCells = [explosionInCell];
        self.explosionInLayer.renderMode = CAEmitterLayerRenderMode.oldestFirst;
        self.explosionInLayer.masksToBounds = false;
        self.layer.addSublayer(self.explosionInLayer)
        
    }
    
    func animate () {
        self.explosionInLayer.beginTime = CACurrentMediaTime();
        self.explosionInLayer.setValue(60, forKeyPath: "emitterCells.charge.birthRate")
        let delay = DispatchTime.now() + Double(Int64(0.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.explode()
        };
    }
    
    func explode () {
        self.explosionInLayer.setValue(0, forKeyPath: "emitterCells.charge.birthRate")
        self.explosionOutLayer.beginTime = CACurrentMediaTime();
        self.explosionOutLayer.setValue(500, forKeyPath: "emitterCells.explosion.birthRate")
        let delay = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.stop()
        };
    }
    
    func stop () {
        self.explosionInLayer.setValue(0, forKeyPath: "emitterCells.charge.birthRate")
        self.explosionOutLayer.setValue(0, forKeyPath: "emitterCells.explosion.birthRate")
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}


