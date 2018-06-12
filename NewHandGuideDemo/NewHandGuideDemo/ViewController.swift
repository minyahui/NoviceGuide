//
//  ViewController.swift
//  NewHandGuideDemo
//
//  Created by MYH on 2018/1/24.
//  Copyright © 2018年 MYH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var modes = [MYHGuideInfoModel]()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let v1 = UIView.init(frame: CGRect.init(x: 30, y: 60, width: 100, height: 100))
        v1.backgroundColor = UIColor.red
        self.view.addSubview(v1)
        let v3 = UIView.init(frame: CGRect.init(x: 30, y: 10, width: 40, height: 80))
        v3.backgroundColor = UIColor.yellow
        v1.addSubview(v3)
        let v2 = UIView.init(frame: CGRect.init(x: 10, y: 20, width: 40, height: 20))
        v2.backgroundColor = UIColor.blue
        v3.addSubview(v2)
        let v4 = UIView.init(frame: CGRect.init(x: 180, y: 140, width: 60, height: 60))
        v4.backgroundColor = UIColor.purple
        self.view.addSubview(v4)
        let v5 = UIView.init(frame: CGRect.init(x: 300, y: 80, width: 40, height: 40))
        v5.backgroundColor = UIColor.gray
        v5.layer.cornerRadius = 20
        self.view.addSubview(v5)
        let v6 = UIView.init(frame: CGRect.init(x: 30, y: 200, width: 60, height: 90))
        v6.backgroundColor = UIColor.darkGray
        self.view.addSubview(v6)
        let v7 = UIView.init(frame: CGRect.init(x: 300, y: 100, width: 20, height: 20))
        v7.backgroundColor = UIColor.green
        v7.layer.cornerRadius = 10
        self.view.addSubview(v7)
        
        let m1 = MYHGuideInfoModel.init()
        let m2 = MYHGuideInfoModel.init()
        let m3 = MYHGuideInfoModel.init()
        let m4 = MYHGuideInfoModel.init()
        let m5 = MYHGuideInfoModel.init()
        let m6 = MYHGuideInfoModel.init()
        let m7 = MYHGuideInfoModel.init()
        m1.text = "你好我好大家好啊！！！！m1"
        m2.text = "你好我好大家好啊！！！！m2"
        m3.text = "你好我好大家好啊！！！！m3"
        m4.text = "你好我好大家好啊！！！！m4"
        m5.text = "你好我好大家好啊！！！！m5"
        m6.text = "你好我好大家好啊！！！！m6"
        m7.text = "你好我好大家好啊！！！！m7"
        // 写到这里的主要原因是：viewDidAppear中keyWindows才有值，控件相对屏幕的位置才准确
        m1.frameBaseWindow = v1.convert(v1.bounds, to: nil)
        m2.frameBaseWindow = v2.convert(v2.bounds, to: nil)
        m3.frameBaseWindow = v3.convert(v3.bounds, to: nil)
        m4.frameBaseWindow = v4.convert(v4.bounds, to: nil)
        m5.frameBaseWindow = v5.convert(v5.bounds, to: nil)
        m6.frameBaseWindow = v6.convert(v6.bounds, to: nil)
        m7.frameBaseWindow = v7.convert(v7.bounds, to: nil)
        m1.textColor = v1.backgroundColor!
        m2.textColor = v2.backgroundColor!
        m3.textColor = v3.backgroundColor!
        m4.textColor = v4.backgroundColor!
        m7.textColor = v7.backgroundColor!
        m5.maskCornerRadius = 20
        m7.maskCornerRadius = 20
        modes.append(m1)
        modes.append(m2)
        modes.append(m3)
        modes.append(m4)
        modes.append(m5)
        modes.append(m6)
        modes.append(m7)
    }
    @objc func show(_ btn : UIButton) {
        let gv = MYHGuideMaskView.init(frame: self.view.bounds)
        gv.showMask(data: modes)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = UIButton.init(type: UIButtonType.contactAdd)
        btn.frame = CGRect.init(x: 0, y: 300, width: 40, height: 40)
        btn.addTarget(self, action: #selector(show(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

