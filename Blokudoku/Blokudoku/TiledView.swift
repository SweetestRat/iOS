import UIKit

class TiledView: UIView {

    var cellHeight = 0
    var cellWidth = 0
    public var activeCellColor = UIColor.systemCyan.cgColor
    public var unactiveCellLightColor = UIColor.systemGray3.cgColor
    public var unactiveCellDarkColor = UIColor.systemGray2.cgColor
    public var shadowedCellColor = UIColor.systemGray.cgColor
    public var readyToDissapearColor = UIColor.blue.cgColor
    public var cellsState: [[CellState]]?
    public var boundSizeDevider = 40

    override class var layerClass: AnyClass { CATiledLayer.self }

    var tiledLayer: CATiledLayer { layer as! CATiledLayer }

    override var contentScaleFactor: CGFloat {
        didSet { super.contentScaleFactor = 1 }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Error loading context") }

        cellWidth = Int(tiledLayer.tileSize.width)
        cellHeight = Int(tiledLayer.tileSize.height)

        context.setFillColor(backgroundColor?.cgColor ?? UIColor.init(red: 99/255, green: 23/255, blue: 185/255, alpha: 1).cgColor)
        context.fill(rect)

        let colNum = Int(rect.origin.x) / cellWidth
        let rowNum = Int(rect.origin.y) / cellHeight
        
        guard let letcellsState = cellsState else {return}
        if rowNum < letcellsState.count && colNum < letcellsState[0].count {
            switch letcellsState[rowNum][colNum] {
            case .active:
                context.setFillColor(activeCellColor)
                break
            case .unactive:
                if ((colNum / 3 % 2) != (rowNum / 3 % 2)) {
                    context.setFillColor(unactiveCellDarkColor)
                } else {
                    context.setFillColor(unactiveCellLightColor)
                }
                break
            case .shadowed:
                context.setFillColor(shadowedCellColor)
            }
        }

        let boundSize = CGFloat(cellWidth) / CGFloat(boundSizeDevider)
        let drawingRect = rect.inset(by: UIEdgeInsets(top: boundSize, left: boundSize, bottom: boundSize, right: boundSize))
        context.fill(drawingRect)
    }

}
