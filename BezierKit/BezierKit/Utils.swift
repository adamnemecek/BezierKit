//
//  Utils.swift
//  BezierKit
//
//  Created by Holmes Futrell on 11/3/16.
//  Copyright © 2016 Holmes Futrell. All rights reserved.
//

import Foundation

internal class Utils {

    // float precision significant decimal
    static let epsilon: BKFloat = 0.000001
    static let tau: BKFloat = 2.0 * BKFloat(Double.pi)
    static let quart: BKFloat = BKFloat(Double.pi) / 2.0
    
    // Legendre-Gauss abscissae with n=24 (x_i values, defined at i=n as the roots of the nth order Legendre polynomial Pn(x))
    static let Tvalues: [BKFloat] = [
        -0.0640568928626056260850430826247450385909,
        0.0640568928626056260850430826247450385909,
        -0.1911188674736163091586398207570696318404,
        0.1911188674736163091586398207570696318404,
        -0.3150426796961633743867932913198102407864,
        0.3150426796961633743867932913198102407864,
        -0.4337935076260451384870842319133497124524,
        0.4337935076260451384870842319133497124524,
        -0.5454214713888395356583756172183723700107,
        0.5454214713888395356583756172183723700107,
        -0.6480936519369755692524957869107476266696,
        0.6480936519369755692524957869107476266696,
        -0.7401241915785543642438281030999784255232,
        0.7401241915785543642438281030999784255232,
        -0.8200019859739029219539498726697452080761,
        0.8200019859739029219539498726697452080761,
        -0.8864155270044010342131543419821967550873,
        0.8864155270044010342131543419821967550873,
        -0.9382745520027327585236490017087214496548,
        0.9382745520027327585236490017087214496548,
        -0.9747285559713094981983919930081690617411,
        0.9747285559713094981983919930081690617411,
        -0.9951872199970213601799974097007368118745,
        0.9951872199970213601799974097007368118745
    ]
    
    // Legendre-Gauss weights with n=24 (w_i values, defined by a function linked to in the Bezier primer article)
    static let Cvalues: [BKFloat] = [
        0.1279381953467521569740561652246953718517,
        0.1279381953467521569740561652246953718517,
        0.1258374563468282961213753825111836887264,
        0.1258374563468282961213753825111836887264,
        0.1216704729278033912044631534762624256070,
        0.1216704729278033912044631534762624256070,
        0.1155056680537256013533444839067835598622,
        0.1155056680537256013533444839067835598622,
        0.1074442701159656347825773424466062227946,
        0.1074442701159656347825773424466062227946,
        0.0976186521041138882698806644642471544279,
        0.0976186521041138882698806644642471544279,
        0.0861901615319532759171852029837426671850,
        0.0861901615319532759171852029837426671850,
        0.0733464814110803057340336152531165181193,
        0.0733464814110803057340336152531165181193,
        0.0592985849154367807463677585001085845412,
        0.0592985849154367807463677585001085845412,
        0.0442774388174198061686027482113382288593,
        0.0442774388174198061686027482113382288593,
        0.0285313886289336631813078159518782864491,
        0.0285313886289336631813078159518782864491,
        0.0123412297999871995468056670700372915759,
        0.0123412297999871995468056670700372915759
    ]
    
    static func getABC(n: Int, S: BKPoint, B: BKPoint, E: BKPoint, t: BKFloat = 0.5) -> (A: BKPoint, B: BKPoint, C: BKPoint) {
        let u = Utils.projectionRatio(n: n, t: t)
        let um = 1-u
        let C = BKPoint(
            x: u*S.x + um*E.x,
            y: u*S.y + um*E.y
        )
        let s = Utils.abcRatio(n: n, t: t)
        let A = BKPoint(
            x: B.x + (B.x-C.x)/s,
            y: B.y + (B.y-C.y)/s
        )
        return ( A:A, B:B, C:C )
    }
    
    static func abcRatio(n: Int, t: CGFloat = 0.5) -> BKFloat {
        // see ratio(t) note on http://pomax.github.io/bezierinfo/#abc
        assert(n == 2 || n == 3)
        if ( t == 0 || t == 1) {
            return t
        }
        let bottom = pow(t, CGFloat(n)) + pow(1 - t, CGFloat(n))
        let top = bottom - 1
        return abs(top/bottom)
    }
    
    static func projectionRatio(n: Int, t: CGFloat = 0.5) -> BKFloat {
        // see u(t) note on http://pomax.github.io/bezierinfo/#abc
        assert(n == 2 || n == 3)
        if (t == 0 || t == 1) {
            return t
        }
        let top = pow(1.0 - t, CGFloat(n))
        let bottom = pow(t, CGFloat(n)) + top
        return top/bottom
    }
    
    static func map(_ v: BKFloat,_ ds: BKFloat,_ de: BKFloat,_ ts: BKFloat,_ te: BKFloat) -> BKFloat {
        let d1 = de-ds
        let d2 = te-ts
        let v2 =  v-ds
        let r = v2/d1
        return ts + d2*r        
    }
    
    static func lli8(_ x1: BKFloat,_ y1: BKFloat,_ x2: BKFloat,_ y2: BKFloat,_ x3: BKFloat,_ y3: BKFloat,_ x4: BKFloat,_ y4: BKFloat) -> BKPoint? {
        let nx = (x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4)
        let ny = (x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4)
        let d = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4)
        if d == 0 {
            return nil
        }
        return BKPoint( x: nx/d, y: ny/d )
    }
    
    static func lli4(_ p1: BKPoint,_ p2: BKPoint,_ p3: BKPoint,_ p4: BKPoint) -> BKPoint? {
        let x1 = p1.x; let y1 = p1.y
        let x2 = p2.x; let y2 = p2.y
        let x3 = p3.x; let y3 = p3.y
        let x4 = p4.x; let y4 = p4.y
        return Utils.lli8(x1,y1,x2,y2,x3,y3,x4,y4)
    }
    
    //    static func lli(_ v1: BKFloat,_ v2: BKFloat) -> BKPoint? {
    //        return Utils.lli4(v1,v1.c,v2,v2.c)
    //    }
    
    static func getminmax(list: [BKFloat], value0: BKFloat, value1: BKFloat) -> (min: BKFloat, max: BKFloat) {
        var min = value0 < value1 ? value0 : value1
        var max = value0 < value1 ? value1 : value0
        for t in list {
            if t < min {
                min = t
            }
            else if t > max {
                max = t
            }
        }
        return (min: min, max: max)
    }
    
    static func approximately(_ a: BKFloat,_ b: BKFloat, precision: BKFloat = epsilon) -> Bool {
        return abs(a-b) <= precision
    }
    
    static func between(_ v: BKFloat,_ m: BKFloat,_ M: BKFloat) -> Bool {
        return (m <= v && v <= M) || Utils.approximately(v, m) || Utils.approximately(v, M)
    }
    
    // cube root function yielding real roots
    static func crt(_ v: BKFloat) -> BKFloat {
        return (v < 0) ? -pow(-v,1.0/3.0) : pow(v,1.0/3.0)
    }
    
    static func roots(points: [BKPoint], line: Line = Line(p1: BKPoint(x: 0.0, y: 0.0), p2: BKPoint(x: 1.0, y: 0.0))) -> [BKFloat] {
        let order = points.count - 1
        let p = Utils.align(points, p1: line.p1, p2: line.p2)
        let reduce: (BKFloat) -> Bool = { 0 <= $0 && $0 <= 1 }
        
        if order == 2 {
            let a = p[0].y
            let b = p[1].y
            let c = p[2].y
            let d = a - 2*b + c
            if d != 0 {
                let m1 = -sqrt(b*b-a*c)
                let m2 = -a+b
                let v1: BKFloat = -( m1+m2)/d
                let v2: BKFloat = -(-m1+m2)/d
                return [v1, v2].filter(reduce)
            }
            else if b != c && d == BKFloat(0.0) {
                return [ BKFloat(2.0*b-c)/2.0*(b-c) ].filter(reduce)
            }
            else {
                return []
            }
        }
        else {
            // see http://www.trans4mind.com/personal_development/mathematics/polynomials/cubicAlgebra.htm
            let pa = p[0].y
            let pb = p[1].y
            let pc = p[2].y
            let pd = p[3].y
            let d = (-pa + 3*pb - 3*pc + pd)
            let a = (3*pa - 6*pb + 3*pc) / d
            let b = (-3*pa + 3*pb) / d
            let c = pa / d
            let p = (3*b - a*a)/3
            let p3 = p/3
            let q = (2*a*a*a - 9*a*b + 27*c)/27
            let q2 = q/2
            let discriminant = q2*q2 + p3*p3*p3
            if discriminant < 0 {
                let mp3 = -p/3
                let mp33 = mp3*mp3*mp3
                let r = sqrt( mp33 )
                let t = -q/(2*r)
                let cosphi = t < -1 ? -1 : t > 1 ? 1 : t
                let phi = acos(cosphi)
                let crtr = crt(r)
                let t1 = 2*crtr
                let x1 = t1 * cos(phi/3) - a/3
                let x2 = t1 * cos((phi+tau)/3) - a/3
                let x3 = t1 * cos((phi+2*tau)/3) - a/3
                return [x1, x2, x3].filter(reduce)
            }
            else if discriminant == 0 {
                let u1 = q2 < 0 ? crt(-q2) : -crt(q2)
                let x1 = 2*u1-a/3
                let x2 = -u1 - a/3
                return [x1,x2].filter(reduce)
            }
            else {
                let sd = sqrt(discriminant)
                let u1 = crt(-q2+sd)
                let v1 = crt(q2+sd)
                return [u1-v1-a/3].filter(reduce)
            }
        }
    }
    
    static func droots(_ p: [BKFloat]) -> [BKFloat] {
        if p.count == 3 {
            // quadratic roots are easy
            let a = p[0]
            let b = p[1]
            let c = p[2]
            let d = a - 2*b + c
            if d != 0 {
                let m1 = -sqrt(b*b-a*c)
                let m2 = -a+b
                let v1 = -( m1+m2)/d
                let v2 = -(-m1+m2)/d
                return [v1, v2]
            }
            else if (b != c) && (d == 0) {
                return [(2*b-c)/(2*(b-c))]
            }
            return []
        }
        else if p.count == 2 {
            // linear roots are even easier
            let a = p[0]
            let b = p[1]
            if a != b {
                return [a/(a-b)]
            }
            return []
        }
        else {
            fatalError("bad number of points for root finding")
        }
    }
    
    static func lerp(_ r: BKFloat, _ v1: BKPoint, _ v2: BKPoint) -> BKPoint {
        return v1 + r * (v2 - v1)
    }
    
    static func dist(_ p1: BKPoint,_ p2: BKPoint) -> BKFloat {
        return (p1 - p2).length
    }
    
    static func arcfn(_ t: BKFloat, _ derivativeFn: (_ t: BKFloat) -> BKPoint) -> BKFloat {
        let d = derivativeFn(t)
        return d.length
    }
    
    static func length(_ derivativeFn: (_ t: BKFloat) -> BKPoint) -> BKFloat {
        let z: BKFloat = 0.5
        let len = Utils.Tvalues.count
        var sum: BKFloat = 0.0
        for i in 0..<len {
            let t = z * Utils.Tvalues[i] + z
            sum += Utils.Cvalues[i] * Utils.arcfn(t, derivativeFn)
        }
        return z * sum
    }
    
    static func angle(o: BKPoint, v1: BKPoint, v2: BKPoint) -> BKFloat {
        let dx1 = v1.x - o.x
        let dy1 = v1.y - o.y
        let dx2 = v2.x - o.x
        let dy2 = v2.y - o.y
        let cross = dx1*dy2 - dy1*dx2
        let dot = dx1*dx2 + dy1*dy2
        return atan2(cross, dot)
    }
    
    static func align(_ points: [BKPoint], p1: BKPoint, p2: BKPoint) -> [BKPoint] {
        let tx = p1.x
        let ty = p1.y
        let a = -atan2(p2.y-ty, p2.x-tx)
        let d =  {( v: BKPoint) in
            return BKPoint(
                x: (v.x-tx)*cos(a) - (v.y-ty)*sin(a),
                y: (v.x-tx)*sin(a) + (v.y-ty)*cos(a)
            )
        }
        return points.map(d)
    }
    
    static func closest(_ LUT: [BKPoint],_ point: BKPoint) -> (mdist: BKFloat, mpos: Int) {
        assert(LUT.count > 0)
        var mdist = BKFloat.infinity
        var mpos: Int? = nil
        for i in 0..<LUT.count {
            let p = LUT[i]
            let d = Utils.dist(point, p)
            if d<mdist {
                mdist = d
                mpos = i
            }
        }
        return ( mdist:mdist, mpos:mpos! )
    }
    
    static func makeline(_ p1: BKPoint,_ p2: BKPoint) -> CubicBezierCurve {
        let x1 = p1.x
        let y1 = p1.y
        let x2 = p2.x
        let y2 = p2.y
        let dx = (x2-x1) / 3.0
        let dy = (y2-y1) / 3.0
        return CubicBezierCurve(p0: BKPoint(x: x1, y: y1),
                                p1: BKPoint(x: x1+dx, y: y1+dy),
                                p2: BKPoint(x: x1+2.0*dx, y: y1+2.0*dy),
                                p3: BKPoint(x: x2, y: y2)
        )
    }
    
    static func distance2(_ p: BKPoint,_ l1: BKPoint,_ l2: BKPoint) -> (d2: BKFloat, t: BKFloat) {
        let delta = l2 - l1
        let rel = p - l1
        let dot = rel.dot(delta)
        let param: BKFloat = dot / delta.length2
        var closest: BKPoint
        var t: BKFloat
        if param < 0 {
            t = 0.0
            closest = l1
        }
        else if param > 1 {
            t = 1.0
            closest = l2
        }
        else {
            t = param
            closest = l1 + param * delta
        }
        return (d2: (p - closest).length2, t: t)
    }
    
    static func lineIntersection(_ l11: BKPoint,_ l12: BKPoint,_ l21: BKPoint,_ l22: BKPoint, clamp: Bool = true) -> Intersection? {
        
        let a1 = l11
        let b1 = l12 - l11
        let a2 = l21
        let b2 = l22 - l21
        
        let _a = b1.x
        let _b = -b2.x
        let _c = b1.y
        let _d = -b2.y
        
        // by Cramer's rule we have
        // t1 = ed - bf / ad - bc
        // t2 = af - ec / ad - bc
        let det = _a * _d - _b * _c
        
        let _e = -a1.x + a2.x
        let _f = -a1.y + a2.y
        
        let inv_det = 1.0 / det
        let t1 = ( _e * _d - _b * _f ) * inv_det
        if clamp && (t1 >= 1.0 || t1 <= 0.0)  {
            return nil // t1 out of interval [0, 1]
        }
        let t2 = ( _a * _f - _e * _c ) * inv_det
        if clamp && (t2 >= 1.0 || t2 <= 0.0) {
            return nil // t2 out of interval [0, 1]
        }
        // segments intersect at t1, t2
        return Intersection(t1: t1, t2: t2)
    }
    
    static func lineDistance2(a1: BKPoint, a2: BKPoint, b1: BKPoint, b2: BKPoint) -> (d2: BKFloat, t1: BKFloat, t2: BKFloat) {
        if let i = lineIntersection(a1, a2, b1, b2) {
            return (d2: 0.0, t1: i.t1, t2: i.t2)
        }
        else {
            var (d2, t) = distance2(a1, b1, b2)
            var shortest_d2 = d2
            var t1: BKFloat = 0.0
            var t2: BKFloat = t
            (d2, t) = distance2(a2, b1, b2)
            if d2 < shortest_d2 {
                shortest_d2 = d2
                t1 = 1.0
                t2 = t
            }
            (d2, t) = distance2(b1, a1, a2)
            if d2 < shortest_d2 {
                shortest_d2 = d2
                t1 = t
                t2 = 0.0
            }
            (d2, t) = distance2(b2, a1, a2)
            if d2 < shortest_d2 {
                shortest_d2 = d2
                t1 = t
                t2 = 1.0
            }
            return (shortest_d2, t1, t2)
        }
    }
    
    static func pairiteration(_ c1: Subcurve, _ c2: Subcurve, _ threshold: BKFloat = 0.5) -> [Intersection] {
        
        let flatness1 = c1.curve.flatness()
        let flatness2 = c2.curve.flatness()
        
        let (d2, t1, t2) = lineDistance2(a1: c1.curve.points[0],
                                         a2: c1.curve.points.last!,
                                         b1: c2.curve.points[0],
                                         b2: c2.curve.points.last!)
        
        let threshold2 = threshold * threshold
        if (flatness1 < threshold2) && (flatness2 < threshold2) {
            if d2 == 0.0 {
                return [Intersection(t1: t1 * c1.t2 + (1.0 - t1) * c1.t1,
                                     t2: t2 * c2.t2 + (1.0 - t2) * c2.t1)]
            }
            else {
              return []
            }
        }
        else if ( d2 > flatness1 ) && ( d2 > flatness2 ) {
            return []
        }
        
        var pairs = Array<(left: Subcurve, right: Subcurve)>()
        
        if flatness1 < threshold2 {
            let cc2 = c2.split(at: 0.5)
            pairs = [
                (left: c1, right: cc2.left),
                (left: c1, right: cc2.right)]
        }
        else if flatness2 < threshold {
            let cc1 = c1.split(at: 0.5)
            pairs = [
                (left: cc1.left, right: c2),
                (left: cc1.right, right: c2)]
        }
        else {
            let cc2 = c2.split(at: 0.5)
            let cc1 = c1.split(at: 0.5)
            pairs = [
                (left: cc1.left, right: cc2.left),
                (left: cc1.left, right: cc2.right),
                (left: cc1.right, right: cc2.left),
                (left: cc1.right, right: cc2.right)]
        }
//        pairs = pairs.filter( {(pair) in
//            return pair.left.curve.boundingBox.overlaps(pair.right.curve.boundingBox)
//        })
        
        var results: [Intersection] = Array<Intersection>()
        for pair in pairs {
            results += Utils.pairiteration(pair.left, pair.right, threshold)
        }
        // sort the results by t1 (and by t2 if t1 equal)
        results = results.sorted(by: <)
        // de-dupe the sorted array
        results = results.reduce(Array<Intersection>(), {(result: [Intersection], next: Intersection) in
            return (result.count == 0 || result[result.count-1] != next) ? result + [next] : result
        })
        return results
    }
    
    struct ShapeIntersection {
        var c1: BezierCurve
        var c2: BezierCurve
        //        var s1: Shape
        //        var s2: Shape
        var intersection: [Intersection]
    }
    
    static func shapeintersections(_ s1: Shape,_ bbox1: BoundingBox,_ s2: Shape,_ bbox2: BoundingBox,_ curveIntersectionThreshold: BKFloat) -> [ShapeIntersection] {
        if !bbox1.overlaps(bbox2) {
            return []
        }
        var intersections: [ShapeIntersection] = []
        let a1: [BezierCurve?] = [s1.startcap.virtual ? nil : s1.startcap.curve, s1.forward, s1.back, s1.endcap.virtual ? nil : s1.endcap.curve]
        let a2: [BezierCurve?] = [s2.startcap.virtual ? nil : s1.startcap.curve, s2.forward, s2.back, s2.endcap.virtual ? nil : s1.endcap.curve]
        for l1 in a1 {
            if l1 == nil {
                continue
            }
            for l2 in a2 {
                if l2 == nil {
                    continue
                }
                let iss = l1!.intersects(curve: l2!, curveIntersectionThreshold: curveIntersectionThreshold)
                if iss.count > 0 {
                    intersections.append(ShapeIntersection(c1: l1!, c2: l2!, /*, s1: s1, s2: s2,*/ intersection: iss))
                }
            }
        }
        return intersections
    }
    
    static func makeshape(_ forward: BezierCurve,_ back: BezierCurve,_ curveIntersectionThreshold: BKFloat) -> Shape {
        let bpl = back.points.count
        let fpl = forward.points.count
        let start  = Utils.makeline(back.points[bpl-1], forward.points[0])
        let end    = Utils.makeline(forward.points[fpl-1], back.points[0])
        let shape  = Shape(
            startcap: Shape.Cap(curve: start),
            endcap: Shape.Cap(curve: end),
            forward: forward,
            back: back
        )
        // TODO: intersections method
        //        var self = utils
        //        shape.intersections = function(s2) {
        //        return self.shapeintersections(shape,shape.bbox,s2,s2.bbox, curveIntersectionThreshold)
        //        }
        return shape
    }
    
    static func getccenter( _ p1: BKPoint, _ p2: BKPoint, _ p3: BKPoint, _ interval: Arc.Interval) -> Arc {
        let d1 = p2 - p1
        let d2 = p3 - p2
        let d1p = BKPoint(x: d1.x * cos(quart) - d1.y * sin(quart),
                          y: d1.x * sin(quart) + d1.y * cos(quart))
        let d2p = BKPoint(x: d2.x * cos(quart) - d2.y * sin(quart),
                          y: d2.x * sin(quart) + d2.y * cos(quart))
        // chord midpoints
        let m1 = 0.5 * (p1 + p2)
        let m2 = 0.5 * (p2 + p3)
        // midpoint offsets
        let m1n = m1 + d1p
        let m2n = m2 + d2p
        // intersection of these lines:
        let oo = Utils.lli8(m1.x, m1.y, m1n.x, m1n.y, m2.x, m2.y, m2n.x, m2n.y)
        
        assert(oo != nil)
        
        let o: BKPoint = oo!
        let r = Utils.dist(o, p1)
        // arc start/end values, over mid point:
        var s = atan2(p1.y - o.y, p1.x - o.x)
        let m = atan2(p2.y - o.y, p2.x - o.x)
        var e = atan2(p3.y - o.y, p3.x - o.x)
        // determine arc direction (cw/ccw correction)
        if s<e {
            // if s<m<e, arc(s, e)
            // if m<s<e, arc(e, s + tau)
            // if s<e<m, arc(e, s + tau)
            if s>m || m>e {
                s += tau
            }
            if s>e {
                swap(&s, &e)
            }
        }
        else {
            // if e<m<s, arc(e, s)
            // if m<e<s, arc(s, e + tau)
            // if e<s<m, arc(s, e + tau)
            if e<m && m<s {
                swap(&s, &e)
            }
            else {
                e += tau
            }
        }
        return Arc(origin: o, radius: r, start: s, end: e, interval: interval)
    }
    
    static func hull(_ p: [BKPoint],_ t: BKFloat) -> [BKPoint] {
        let c: Int = p.count
        var q: [BKPoint] = p
        q.reserveCapacity(c * (c+1) / 2) // reserve capacity ahead of time to avoid re-alloc
        // we lerp between all points (in-place), until we have 1 point left.
        var start: Int = 0
        for count in (1 ..< c).reversed()  {
            let end: Int = start + count
            for i in start ..< end {
                let pt = Utils.lerp(t,q[i],q[i+1])
                q.append(pt)
            }
            start = end + 1
        }
        return q
    }
}
