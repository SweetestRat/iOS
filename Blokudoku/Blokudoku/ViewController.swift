//
//  ViewController.swift
//  Blokudoku
//
//  Created by Владислава Гильде on 02.02.2022.
//

import UIKit

class ViewController: UIViewController {

    var score: UILabel!
    var table: TiledView!
    var figure1: TiledView!
    var figure2: TiledView!
    var figure3: TiledView!
    var draggableView: TiledView!
    var lastHiddenFigure: TiledView!
    
    var figure1WidthConstraint: NSLayoutConstraint!
    var figure2WidthConstraint: NSLayoutConstraint!
    var figure3WidthConstraint: NSLayoutConstraint!
    var touchFrameFigure1: UIView!
    var touchFrameFigure2: UIView!
    var touchFrameFigure3: UIView!
    var lightTheme: UIBarButtonItem!
    var darkTheme: UIBarButtonItem!
    var shadowsToRemove: CGRect!
    
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    
//    TODO
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setNavigationBar()
        setTable()
        setFigures()
        setDraggableView()
        
        addSubviews()
        setConstraints()
        
    }
    
    func setNavigationBar() {
        
        let leftArrow = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = leftArrow
        
        lightTheme = UIBarButtonItem(image: UIImage(systemName: "paintpalette"), style: .plain, target: self, action: #selector(changeTheme))
        darkTheme = UIBarButtonItem(image: UIImage(systemName: "paintpalette.fill"), style: .plain, target: self, action: #selector(changeTheme))
        
        let settings = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goToSettings))
        
        navigationItem.rightBarButtonItems = [settings, lightTheme]
        
        score = UILabel()
        score.text = "0"
        score.textColor = UIColor.init(red: 44/255, green: 55/255, blue: 84/255, alpha: 1)
    }
    
    func setTable() {
        
        table = TiledView()
        table.cellsState = Array.init(repeating: Array.init(repeating: .unactive, count: 9), count: 9)
        
        let tileSize = (view.frame.width - 50) / 9
        table.tiledLayer.tileSize = CGSize(width: tileSize, height: tileSize)
        table.backgroundColor = .systemBackground
        table.layer.borderWidth = 2
        table.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func setFigures() {
        
        figure1 = TiledView()
        figure2 = TiledView()
        figure3 = TiledView()
        
        figure1.cellsState = figuresLibrary.randomElement()
        figure2.cellsState = figuresLibrary.randomElement()
        figure3.cellsState = figuresLibrary.randomElement()
        
        [figure1, figure2, figure3].compactMap { $0 }
            .forEach {
                
                guard let figureCellsState = $0.cellsState else { return }
                
                let maxLength = max(figureCellsState.count, figureCellsState[0].count, 3)
                let figureTileSize = ((Int(view.frame.width) - 50) / 3 - 10) / maxLength
                
                $0.activeCellColor = UIColor.systemCyan.cgColor
                $0.unactiveCellLightColor = UIColor.white.withAlphaComponent(0).cgColor
                $0.unactiveCellDarkColor = UIColor.white.withAlphaComponent(0).cgColor
                $0.backgroundColor = .white.withAlphaComponent(0)
                $0.tiledLayer.tileSize = CGSize(width: figureTileSize, height: figureTileSize)
            }
        
        touchFrameFigure1 = UIView()
        touchFrameFigure2 = UIView()
        touchFrameFigure3 = UIView()
    }
    
    func setDraggableView() {
        
        draggableView = TiledView()
        
        draggableView.activeCellColor = UIColor.systemMint.cgColor
        draggableView.unactiveCellLightColor = UIColor.white.withAlphaComponent(0).cgColor
        draggableView.unactiveCellDarkColor = UIColor.white.withAlphaComponent(0).cgColor
        draggableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        let draggableFigureTileSize = ((Int(view.frame.width) - 50) / 3 - 10) / 3
        draggableView.tiledLayer.tileSize = CGSize(width: draggableFigureTileSize, height: draggableFigureTileSize)
        draggableView.boundSizeDevider = 10
        draggableView.isHidden = true
    }
    
    func addSubviews() {
        
        [ score,
          table,
          figure1,
          figure2,
          figure3,
          draggableView,
          touchFrameFigure1,
          touchFrameFigure2,
          touchFrameFigure3
        ].compactMap { $0 }
        .forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        
        guard let figure1CellsState = figure1.cellsState else { return }
        guard let figure2CellsState = figure2.cellsState else { return }
        guard let figure3CellsState = figure3.cellsState else { return }
        
        figure1WidthConstraint = figure1.widthAnchor.constraint(equalToConstant: CGFloat(figure1CellsState[0].count) * figure1.tiledLayer.tileSize.width)
        figure2WidthConstraint = figure2.widthAnchor.constraint(equalToConstant: CGFloat(figure2CellsState[0].count) * figure2.tiledLayer.tileSize.width)
        figure3WidthConstraint = figure3.widthAnchor.constraint(equalToConstant: CGFloat(figure3CellsState[0].count) * figure3.tiledLayer.tileSize.width)

        
        NSLayoutConstraint.activate([
            score.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            score.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            table.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            table.heightAnchor.constraint(equalTo: table.widthAnchor),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.topAnchor.constraint(equalTo: score.bottomAnchor, constant: 80),
            
            figure1.centerXAnchor.constraint(equalTo: table.leadingAnchor, constant: (view.frame.width - 50) / 3 / 2),
            figure3.centerXAnchor.constraint(equalTo: table.trailingAnchor, constant: -(view.frame.width - 50) / 3 / 2),
            figure2.centerXAnchor.constraint(equalTo: table.centerXAnchor),
            
            figure1.heightAnchor.constraint(equalTo: table.heightAnchor, multiplier: 1/3, constant: -10),
            figure1.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 30),
            
            figure2.heightAnchor.constraint(equalTo: table.heightAnchor, multiplier: 1/3, constant: -10),
            figure2.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 30),
            
            figure3.heightAnchor.constraint(equalTo: table.heightAnchor, multiplier: 1/3, constant: -10),
            figure3.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 30),
            
            figure1WidthConstraint,
            figure2WidthConstraint,
            figure3WidthConstraint,
            
            touchFrameFigure1.widthAnchor.constraint(equalTo: table.heightAnchor, multiplier: 1/3, constant: -10),
            touchFrameFigure2.widthAnchor.constraint(equalTo: table.heightAnchor, multiplier: 1/3, constant: -10),
            touchFrameFigure3.widthAnchor.constraint(equalTo: table.heightAnchor, multiplier: 1/3, constant: -10),
            
            touchFrameFigure1.heightAnchor.constraint(equalTo: touchFrameFigure1.widthAnchor),
            touchFrameFigure2.heightAnchor.constraint(equalTo: touchFrameFigure2.widthAnchor),
            touchFrameFigure3.heightAnchor.constraint(equalTo: touchFrameFigure3.widthAnchor),

            touchFrameFigure1.leadingAnchor.constraint(equalTo: table.leadingAnchor),
            touchFrameFigure2.centerXAnchor.constraint(equalTo: table.centerXAnchor),
            touchFrameFigure3.trailingAnchor.constraint(equalTo: table.trailingAnchor),
            
            touchFrameFigure1.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 30),
            touchFrameFigure2.topAnchor.constraint(equalTo: touchFrameFigure1.topAnchor),
            touchFrameFigure3.topAnchor.constraint(equalTo: touchFrameFigure1.topAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: view)
        
        if touchFrameFigure1.frame.contains(point ?? CGPoint(x: 0, y: 0)) && !figure1.isHidden {
            
            draggableView.cellsState = figure1.cellsState
            guard let draggableViewCellsState = draggableView.cellsState else { return }
            
            draggableView.frame = CGRect(x: figure1.frame.origin.x,
                                         y: figure1.frame.origin.y,
                                         width: draggableView.tiledLayer.tileSize.width * CGFloat(draggableViewCellsState[0].count),
                                         height: draggableView.tiledLayer.tileSize.height * CGFloat(draggableViewCellsState.count))
            draggableView.frame.origin.y -= draggableView.frame.height
            draggableView.setNeedsDisplay()
            draggableView.isHidden = false
            figure1.isHidden = true
            
            lastHiddenFigure = figure1
        }
        
        if touchFrameFigure2.frame.contains(point ?? CGPoint(x: 0, y: 0)) && !figure2.isHidden {
            draggableView.cellsState = figure2.cellsState
            guard let draggableViewCellsState = draggableView.cellsState else { return }
            
            draggableView.frame = CGRect(x: figure2.frame.origin.x,
                                         y: figure2.frame.origin.y,
                                         width: draggableView.tiledLayer.tileSize.width * CGFloat(draggableViewCellsState[0].count),
                                         height: draggableView.tiledLayer.tileSize.height * CGFloat(draggableViewCellsState.count))
            draggableView.frame.origin.y -= 60
            draggableView.setNeedsDisplay()
            draggableView.isHidden = false
            draggableView.cellsState = figure2.cellsState
            figure2.isHidden = true
            
            lastHiddenFigure = figure2
        }
        
        if touchFrameFigure3.frame.contains(point ?? CGPoint(x: 0, y: 0)) && !figure3.isHidden {
            draggableView.cellsState = figure3.cellsState
            guard let draggableViewCellsState = draggableView.cellsState else { return }
            
            draggableView.frame = CGRect(x: figure3.frame.origin.x,
                                         y: figure3.frame.origin.y,
                                         width: draggableView.tiledLayer.tileSize.width * CGFloat(draggableViewCellsState[0].count),
                                         height: draggableView.tiledLayer.tileSize.height * CGFloat(draggableViewCellsState.count))
            draggableView.frame.origin.y -= 60
            draggableView.setNeedsDisplay()
            draggableView.isHidden = false
            figure3.isHidden = true
            
            lastHiddenFigure = figure3
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            let previousPoint = touch.previousLocation(in: view)
            
            let deltaX = currentPoint.x - previousPoint.x
            let deltaY = currentPoint.y - previousPoint.y
            
            let previousOrigin = draggableView.frame.origin
            
            if !draggableView.isHidden {
                draggableView.frame.origin = CGPoint(x: previousOrigin.x + deltaX, y: previousOrigin.y + deltaY)
            }
             
            
            let leftTopCellDraggableCenterX = draggableView.frame.origin.x + draggableView.tiledLayer.tileSize.width / 2
            let leftTopCellDraggableCenterY = draggableView.frame.origin.y + draggableView.tiledLayer.tileSize.height / 2

            removeShadows()
            
            guard leftTopCellDraggableCenterX - table.frame.origin.x >= 0 && leftTopCellDraggableCenterY - table.frame.origin.y >= 0 else { return }
            
            let xPointIn = Int((leftTopCellDraggableCenterX - table.frame.origin.x) / table.tiledLayer.tileSize.width)
            let yPointIn = Int((leftTopCellDraggableCenterY - table.frame.origin.y) / table.tiledLayer.tileSize.height)
            
            guard var tableCellsState = table.cellsState,
                  let draggableViewCellsState = draggableView.cellsState
            else { return }
            
            table.cellsState = tableCellsState
            
            if  xPointIn >= 0 &&
                yPointIn >= 0 &&
                tableCellsState[0].count - xPointIn >= draggableViewCellsState[0].count &&
                tableCellsState.count - yPointIn >= draggableViewCellsState.count {
                
                for y in 0..<draggableViewCellsState.count {
                    for x in 0..<draggableViewCellsState[y].count {
                        if(tableCellsState[y + yPointIn][x + xPointIn] == .active &&
                           draggableViewCellsState[y][x] == .active) {
                            table.setNeedsDisplay()
                            return
                        }
                    }
                }
                
                for y in 0..<draggableViewCellsState.count {
                    for x in 0..<draggableViewCellsState[y].count {
                        if draggableViewCellsState[y][x] == .active {
                            tableCellsState[y + yPointIn][x + xPointIn] = .shadowed
                            table.cellsState = tableCellsState
                        }
                    }
                }
                
                shadowsToRemove = CGRect(x: CGFloat(xPointIn) * table.tiledLayer.tileSize.width, y: CGFloat(yPointIn) * table.tiledLayer.tileSize.height, width: draggableView.frame.width, height: draggableView.frame.height)
            }
            
            table.setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !draggableView.isHidden {
            
            let leftTopCellDraggableCenterX = draggableView.frame.origin.x + draggableView.tiledLayer.tileSize.width / 2
            let leftTopCellDraggableCenterY = draggableView.frame.origin.y + draggableView.tiledLayer.tileSize.height / 2
            
            let xPointIn = Int((leftTopCellDraggableCenterX - table.frame.origin.x) / table.tiledLayer.tileSize.width)
            let yPointIn = Int((leftTopCellDraggableCenterY - table.frame.origin.y) / table.tiledLayer.tileSize.height)
            
            guard var tableCellsState = table.cellsState,
                  let draggableViewCellsState = draggableView.cellsState
            else { return }
            
            if  xPointIn >= 0 &&
                yPointIn >= 0 &&
                tableCellsState[0].count - xPointIn >= draggableViewCellsState[0].count &&
                tableCellsState.count - yPointIn >= draggableViewCellsState.count {
                
                for y in 0..<draggableViewCellsState.count {
                    for x in 0..<draggableViewCellsState[y].count {
                        if(tableCellsState[y + yPointIn][x + xPointIn] == .active &&
                           draggableViewCellsState[y][x] == .active) {
                        touchesCancelled(touches, with: event)
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                            return
                        }
                    }
                }
                
                for y in 0..<draggableViewCellsState.count {
                    for x in 0..<draggableViewCellsState[y].count {
                        if(tableCellsState[y + yPointIn][x + xPointIn] != .active &&
                           draggableViewCellsState[y][x] == .active) {
                        tableCellsState[y + yPointIn][x + xPointIn] = draggableViewCellsState[y][x]
                        }
                    }
                }
                table.cellsState = tableCellsState
                table.setNeedsDisplay()
                impactFeedbackgenerator.impactOccurred()
                
                removeFilledFigure()
                
                draggableView.isHidden = true
                
                if figure1.isHidden && figure2.isHidden && figure3.isHidden {
                    updateFigures()
                }
                
            } else {
                draggableView.isHidden = true
                lastHiddenFigure.isHidden = false
            }
        }
        
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggableView.isHidden = true
        lastHiddenFigure.isHidden = false
    }

    @objc func backAction() {
        print("Tap-tap backwards")
    }

    @objc func changeTheme() {
        
        if navigationItem.rightBarButtonItems?[1] == lightTheme {
            navigationItem.rightBarButtonItems?[1] = darkTheme
            view.backgroundColor = .systemMint
            table.unactiveCellLightColor = UIColor.systemCyan.cgColor
            table.unactiveCellDarkColor = UIColor.systemPink.cgColor
            table.setNeedsDisplay()
        } else {
            navigationItem.rightBarButtonItems?[1] = lightTheme
            view.backgroundColor = .systemBackground
            table.unactiveCellLightColor = UIColor.systemGray3.cgColor
            table.unactiveCellDarkColor = UIColor.systemGray2.cgColor
            table.setNeedsDisplay()
        }
        
        print("Theme changed")
    }
    
    @objc func goToSettings() {
        print("I'm in settings")
    }
    
    private func removeShadows() {
        
        guard var tableCellsState = table.cellsState,
              let shadowsToRemoveExist = shadowsToRemove
        else { return }
        
        for y in 0..<tableCellsState.count {
            for x in 0..<tableCellsState[y].count {
                if tableCellsState[y][x] == .shadowed {
                    tableCellsState[y][x] = .unactive
                }
            }
        }
        
        table.cellsState = tableCellsState
        table.setNeedsDisplay(shadowsToRemoveExist)
        shadowsToRemove = nil
    }
    
    private func removeFilledFigure() {
        
        guard var tableCellsStateCellsRemove = table.cellsState,
              let tableCellsStateCheck = table.cellsState
        else { return }
        
        //check rows
        for y in 0..<tableCellsStateCheck.count {
            var count = 0
            for x in 0..<tableCellsStateCheck[y].count {
                if tableCellsStateCheck[y][x] == .active {
                    count += 1
                }
            }
            
            if count == 9 {
                for x in 0..<tableCellsStateCheck.count {
                    tableCellsStateCellsRemove[y][x] = .unactive
                }
            }
        }
        
        //check columns
        for x in 0..<tableCellsStateCheck.count {
            var count = 0
            for y in 0..<tableCellsStateCheck[x].count {
                if tableCellsStateCheck[y][x] == .active {
                    count += 1
                }
            }
            
            if count == 9 {
                for y in 0..<tableCellsStateCheck[x].count {
                    tableCellsStateCellsRemove[y][x] = .unactive
                }
            }
        }
        
        //check squares
        for y in [0, 3, 6] {
            for x in [0, 3, 6] {
                var count = 0
                for squareY in 0..<3 {
                    for squareX in 0..<3 {
                        if tableCellsStateCheck[squareY + y][squareX + x] == .active {
                            count += 1
                        }
                    }
                }
                
                if count == 9 {
                    for squareY in 0..<3 {
                        for squareX in 0..<3 {
                            tableCellsStateCellsRemove[squareY + y][squareX + x] = .unactive
                        }
                    }
                }
            }
        }
        
        table.cellsState = tableCellsStateCellsRemove
        table.setNeedsDisplay()
    }
    
    private func updateFigures() {
        figure1.cellsState = figuresLibrary.randomElement()
        figure2.cellsState = figuresLibrary.randomElement()
        figure3.cellsState = figuresLibrary.randomElement()

        [figure1, figure2, figure3].compactMap { $0 }
            .forEach {
                
                guard let figureCellsState = $0.cellsState else { return }
                
                let maxLength = max(figureCellsState.count, figureCellsState[0].count, 3)
                let figureTileSize = ((Int(view.frame.width) - 50) / 3 - 10) / maxLength
                
                $0.tiledLayer.tileSize = CGSize(width: figureTileSize, height: figureTileSize)
            }
        
        guard let figure1CellsState = figure1.cellsState,
              let figure2CellsState = figure2.cellsState,
              let figure3CellsState = figure3.cellsState
        else { return }
        
        figure1WidthConstraint.constant = CGFloat(figure1CellsState[0].count) * figure1.tiledLayer.tileSize.width
        figure2WidthConstraint.constant = CGFloat(figure2CellsState[0].count) * figure2.tiledLayer.tileSize.width
        figure3WidthConstraint.constant = CGFloat(figure3CellsState[0].count) * figure3.tiledLayer.tileSize.width
        
        figure1.isHidden = false
        figure2.isHidden = false
        figure3.isHidden = false
        
        figure1.setNeedsDisplay()
        figure2.setNeedsDisplay()
        figure3.setNeedsDisplay()
    }
}
