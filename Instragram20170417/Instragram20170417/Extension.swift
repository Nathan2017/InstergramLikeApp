//
//  Extension.swift
//  Instragram20170417
//
//  Created by Nathan on 4/17/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,left:NSLayoutXAxisAnchor?,right:NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?,paddingTop:CGFloat,paddingLeft:CGFloat,paddingRight:CGFloat,paddingBottom:CGFloat,width:CGFloat,height:CGFloat)
    {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top,constant:paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left,constant:paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right,constant:paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom,constant:paddingBottom).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    func anchorsizeanchor(top: NSLayoutYAxisAnchor?,left:NSLayoutXAxisAnchor?,right:NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?,width:NSLayoutDimension?,height:NSLayoutDimension?,paddingTop:CGFloat,paddingLeft:CGFloat,paddingRight:CGFloat,paddingBottom:CGFloat,xmultiplier:CGFloat,ymultiplier:CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top,constant:paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left,constant:paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right,constant:paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom,constant:paddingBottom).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: xmultiplier).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: ymultiplier).isActive = true
        }

    }
}
