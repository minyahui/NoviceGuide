//
//  MYHGuideMaskView.swift
//  NewHandGuideDemo
//
//  Created by MYH on 2018/1/24.
//  Copyright © 2018年 MYH. All rights reserved.
//

import UIKit

class MYHGuideMaskView: UIView {
    private enum MYHGuideMaskItemRegion : Int {
        case leftTop = 0 /*👋 左上方 👋*/
        case leftBottom /*👋 左下方 👋*/
        case rightTop /*👋 右上方 👋*/
        case rightBottom /*👋 右下方 👋*/
    }
    /*👋 箭头的图片 👋*/
    var arrowImage : UIImage? = UIImage.init(named: "guide_arrow") {
        didSet{
            self.arrowImageView.image = arrowImage
        }
    }
    /*👋 蒙板背景颜色：默认 黑色 👋*/
    var maskBackgroundColor : UIColor = UIColor.black {
        didSet{
            self.maskLayerView.backgroundColor = maskBackgroundColor
        }
    }
    /*👋 蒙板透明度：默认 0.7 👋*/
    var maskAlpha : CGFloat = 0.7 {
        didSet{
            self.maskLayerView.alpha = maskAlpha
        }
    }
    
    //MARK: 当前正在进行引导的item下标
    private var currentIndex : Int = 0 {
        didSet{
            if showDatas.count > currentIndex {
                self.showItem(data: showDatas[currentIndex])
                self.configItemsFrame(data: showDatas[currentIndex])
            }
        }
    }
    private var showDatas : [MYHGuideInfoModel] = []
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.setupUI()
    }
    
    private func setupUI() {
        self.addSubview(self.maskLayerView)
        self.addSubview(self.arrowImageView)
        self.addSubview(self.interTextLabel)
        self.backgroundColor = UIColor.clear
    }
    
    /// 外部调用，设置提示语的数据源
    ///
    /// - Parameter data: 提示语的数据源
    func showMask(data : [MYHGuideInfoModel]) {
        self.showDatas = data
        self.currentIndex = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    /// 显示蒙版
    ///
    /// - Parameter data: 蒙版数据源
    private func showItem(data : MYHGuideInfoModel) {
        let formPath = self.maskLayer.path
        self.maskLayer.fillColor = UIColor.black.cgColor
        // 获取可见区域的路径(开始路径)
        let visualPath = UIBezierPath.init(roundedRect: self.fetchVisualFrame(), cornerRadius: data.maskCornerRadius)
        // 获取终点路径
        let toPath = UIBezierPath.init(rect: self.bounds)
        toPath.append(visualPath)
        // 遮罩的路径
        self.maskLayer.path = toPath.cgPath
        self.maskLayer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = self.maskLayer
        // 开始移动动画
        let anim = CABasicAnimation.init(keyPath: "path")
        anim.duration = 0.3
        anim.fromValue = formPath
        anim.toValue = toPath.cgPath
        self.maskLayer.add(anim, forKey: nil)
    }
    
    /// 获取可见的视图的frame
    ///
    /// - Returns: 可见的视图的frame
    private func fetchVisualFrame() -> CGRect {
        if self.currentIndex >= self.showDatas.count {
            return CGRect.zero
        }
        var visualRect = self.showDatas[self.currentIndex].frameBaseWindow
        visualRect.origin.x += self.showDatas[self.currentIndex].insetEdge.left;
        visualRect.origin.y += self.showDatas[self.currentIndex].insetEdge.top;
        visualRect.size.width  -= (self.showDatas[self.currentIndex].insetEdge.left + self.showDatas[self.currentIndex].insetEdge.right);
        visualRect.size.height -= (self.showDatas[self.currentIndex].insetEdge.top + self.showDatas[self.currentIndex].insetEdge.bottom);
        return visualRect
    }
   
    /// 设置 items 的 frame
    ///
    /// - Parameter data: 蒙版数据源
    private func configItemsFrame(data : MYHGuideInfoModel) {
        self.interTextLabel.text = data.text
        self.interTextLabel.textColor = data.textColor
        self.interTextLabel.font = data.font
        if data.attributeText != nil {
            self.interTextLabel.attributedText = data.attributeText
        }
        // 设置 文字 与 箭头的位置
        var textRect = CGRect.zero
        var arrowRect = CGRect.zero
        let imgSize : CGSize = self.arrowImageView.image?.size ?? CGSize.init(width: 0, height: 0)
        let maxWidth = self.bounds.width - data.horizontalInset * 2
        
        var textSize = CGSize.zero
        if let desc = data.text as NSString? {
           textSize = desc.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font : data.font], context: nil).size
        }
        var transform = CGAffineTransform.identity
        // 获取item的方位
        switch self.fetchVisualRegion() {
        case .leftTop:
            /// 左上
            transform = CGAffineTransform.init(scaleX: -1, y: 1)
            arrowRect = CGRect.init(x: self.fetchVisualFrame().midX - imgSize.width * 0.5, y: self.fetchVisualFrame().maxY + data.space, width: imgSize.width, height: imgSize.height)
            var x : CGFloat = 0
            if textSize.width < self.fetchVisualFrame().width {
                x = arrowRect.maxX - textSize.width * 0.5
            }else{
                x = data.horizontalInset
            }
            textRect = CGRect.init(x: x, y: arrowRect.maxY, width: textSize.width, height: textSize.height)
            break
        case .rightTop:
            /// 右上
            arrowRect = CGRect.init(x: self.fetchVisualFrame().midX - imgSize.width * 0.5, y: self.fetchVisualFrame().maxY + data.space, width: imgSize.width, height: imgSize.height)
            var x : CGFloat = 0
            if textSize.width < self.fetchVisualFrame().width {
                x = arrowRect.minX - textSize.width * 0.5
            } else {
                x = data.horizontalInset + maxWidth - textSize.width
            }
            textRect = CGRect.init(x: x, y: arrowRect.maxY, width: textSize.width, height: textSize.height)
            break
        case .leftBottom:
            /// 左下
            transform = CGAffineTransform.init(scaleX: -1, y: -1)
            arrowRect = CGRect.init(x: self.fetchVisualFrame().midX - imgSize.width * 0.5, y: self.fetchVisualFrame().minY - data.space - imgSize.height, width: imgSize.width, height: imgSize.height)
            var x : CGFloat = 0
            if textSize.width < self.fetchVisualFrame().width {
                x = arrowRect.maxX - textSize.width * 0.5
            } else {
                x = data.horizontalInset
            }
            textRect = CGRect.init(x: x, y: arrowRect.minY - data.space - textSize.height, width: textSize.width, height: textSize.height)
            break
        case .rightBottom:
            /// 右下
            transform = CGAffineTransform.init(scaleX: 1, y: -1)
            arrowRect = CGRect.init(x: self.fetchVisualFrame().midX - imgSize.width * 0.5, y: self.fetchVisualFrame().maxY - data.space - imgSize.height, width: imgSize.width, height: imgSize.height)
            var x : CGFloat = 0
            if textSize.width < self.fetchVisualFrame().width {
                x = arrowRect.minX - textSize.width * 0.5
            } else {
                x = data.horizontalInset + maxWidth - textSize.width
            }
            textRect = CGRect.init(x: x, y: arrowRect.minY - data.space - imgSize.height, width: textSize.width, height: textSize.height)
            break
        }
        
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = transform
            self.arrowImageView.frame = arrowRect
            self.interTextLabel.frame = textRect
        }
    }
    
    /// 获取可见区域的方位
    ///
    /// - Returns: 可见区域的方位
    private func fetchVisualRegion() -> MYHGuideMaskItemRegion {
        /// 可见区域的中心坐标
        let visualCenter = CGPoint.init(x:self.fetchVisualFrame().midX, y: self.fetchVisualFrame().midY)
        /// self.view 的中心坐标
        let viewCenter = CGPoint.init(x:self.bounds.midX, y: self.bounds.midY)
        if ((visualCenter.x <= viewCenter.x)    &&
            (visualCenter.y <= viewCenter.y))
        {
            /// 当前显示的视图在左上角
            return MYHGuideMaskItemRegion.leftTop
        }
        if ((visualCenter.x > viewCenter.x)     &&
            (visualCenter.y <= viewCenter.y))
        {
            /// 当前显示的视图在右上角
            return MYHGuideMaskItemRegion.rightTop
        }
        if ((visualCenter.x <= viewCenter.x)    &&
            (visualCenter.y > viewCenter.y))
        {
            /// 当前显示的视图在左下角
            return MYHGuideMaskItemRegion.leftBottom
        }
        /// 当前显示的视图在右下角
        return MYHGuideMaskItemRegion.rightBottom
    }
    //MARK: 蒙版
    private lazy var maskLayerView: UIView = {
        var mlv = UIView.init(frame: self.bounds)
        mlv.backgroundColor = UIColor.black
        mlv.alpha = maskAlpha
        return mlv
    }()
    private lazy var maskLayer: CAShapeLayer = {
        var ml = CAShapeLayer()
        ml.frame = self.bounds
        return ml
    }()
    //MARK: 描述的label
    lazy var interTextLabel: UILabel = {
        var lb = UILabel.init()
        lb.numberOfLines = 0
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    //MARK: 箭头图片
    private lazy var arrowImageView: UIImageView = {
        var img = UIImageView.init()
        img.image = UIImage.init(named: "guide_arrow")
        return img
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.currentIndex < self.showDatas.count - 1 {
            self.currentIndex = self.currentIndex + 1
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }, completion: { (finish) in
                self.removeFromSuperview()
            })
        }
    }
}
/*👋 每一个提示的属性 👋*/
class MYHGuideInfoModel: NSObject {
    /*👋 每个item的文字 👋*/
    var text : String?
    /*👋 每个item的文字颜色 👋*/
    var textColor : UIColor = UIColor.white
    /*👋 每个item的属性字符串 👋*/
    var attributeText : NSAttributedString?
    /*👋 每个item文字的大小 👋*/
    var font = UIFont.systemFont(ofSize: 13)
    /*👋 每个 item 的 view 蒙板的圆角：默认为 5 👋*/
    var maskCornerRadius : CGFloat = 5
    /*👋 每个 item 的 view 与蒙板的边距：默认 (-8, -8, -8, -8) 👋*/
    var insetEdge = UIEdgeInsetsMake(-8, -8, -8, -8)
    /*👋 每个 item 的子视图（当前介绍的子视图、箭头、描述文字）之间的间距：默认为 20 👋*/
    var space : CGFloat = 20
    /*👋 每个 item 的文字与左右边框间的距离：默认为 50 👋*/
    var horizontalInset : CGFloat = 50
    /*👋 相对window的frame 👋*/
    var frameBaseWindow = CGRect.zero
}
