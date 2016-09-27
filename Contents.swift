import Foundation

func arrayFromContentsOfFileWithName(fileName: String) -> [String] {
    guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "") else {
        return [String]()
    }
    
    do {
        let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
        return content.componentsSeparatedByString("\n")
    } catch _ as NSError {
        return [String]()
    }
}

var input = arrayFromContentsOfFileWithName("File")

var XY = input[0].characters.split(" ").map{Int(String($0))!}
let X = XY[0]
let Y = XY[1]

var MAP = Array<Array<Int>>( count : X, repeatedValue: Array<Int>( count : Y, repeatedValue: 0 ))

for i in 0 ..< Y {
    var XS = input[i + 1].characters.split(" ").map{Int(String($0))!}
    for j in 0 ..< XS.count {
        MAP[i][j] = XS[j]
    }
}

var memo = Array<Array<Int>>( count : X, repeatedValue: Array<Int>( count : Y, repeatedValue: -Int.max ))
var longestPath = -1
func navigate( x : Int, y : Int ) -> Int {
    if memo[y][x] == -Int.max {
        var N = 0
        var E = 0
        var S = 0
        var W = 0
        
        if y > 0 && MAP[y - 1][x] < MAP[y][x] {
            N = navigate(x, y: y - 1) + 1
        }
        
        if x > 0 && MAP[y][x - 1] < MAP[y][x]{
            W = navigate(x - 1, y: y) + 1
        }
        
        if y < Y - 1 && MAP[y + 1][x] < MAP[y][x] {
            S = navigate(x, y: y + 1) + 1
        }
        
        if x < X - 1 && MAP[y][x + 1] < MAP[y][x] {
            E = navigate(x + 1, y: y) + 1
        }
        memo[y][x] = max( N, E, W, S)
    }
    longestPath = max( longestPath, memo[y][x] )
    return memo[y][x]
}

for x in 0 ..< X {
    for y in 0 ..< Y {
        memo[y][x] = navigate(x, y: y)
    }
}

var deepest = 0

func traceRoute( x : Int, y : Int ) -> Int {
    if memo[y][x] == 0 {
        return 0
    }
    var N = 0
    var E = 0
    var S = 0
    var W = 0
    if y > 0 && memo[y - 1][x] == memo[y][x] - 1 {
        N = traceRoute(x, y: y - 1) + MAP[y][x] - MAP[y - 1][x]
    }
    
    if x > 0 && memo[y][x - 1] == memo[y][x] - 1 {
        W = traceRoute(x - 1, y: y) + MAP[y][x] - MAP[y][x - 1]
    }
    
    if y < Y - 1 && memo[y + 1][x] == memo[y][x] - 1 {
        S = traceRoute(x, y: y + 1) + MAP[y][x] - MAP[y + 1][x]
    }
    
    if x < X - 1 && memo[y][x + 1] == memo[y][x] - 1 {
        E = traceRoute(x + 1, y: y) + MAP[y][x] - MAP[y][x + 1]
    }
    
    return max( N, E, W, S)
}



for x in 0 ..< X {
    for y in 0 ..< Y {
        if memo[y][x] == longestPath {
            deepest = max( deepest, traceRoute(x, y: y))
        }
    }
}

print( String(longestPath + 1) + String(deepest) )
