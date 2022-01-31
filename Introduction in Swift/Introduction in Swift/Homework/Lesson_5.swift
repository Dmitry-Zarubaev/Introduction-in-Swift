//
//  Lesson_5.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 27.01.2022.
//

import Foundation


protocol CarVehicle: AnyObject {
    var manufacturer: String? {get}
    var model: String? {get}
    var year: Int? {get}
    var frame: CarFrame {get}
    
    var engine: Engine? {get}

    var isGlassWindowRaised: Bool {get set}
    var isEngineStarted: Bool {get set}
    
    var payload: Int {get set}
    var fuel: Int {get set}
    
    var isEngineReadyToStart: Bool {
        get
    }
    
    init?(who manufacturer: String, what model: String, when year: Int, frame: CarFrame, engine: Engine?)

    
    func printState() -> Void
    func getShortName() -> String
    func printInfo() -> Void
    
    func doCarAction(do action: CarAction) -> Void
}

extension CarVehicle {

    func printState() -> Void {
        let occupation: String
        switch self.payload {
            case let x where x == frame.weight.getPayloadCapacity():
                occupation = "car is carrying the max payload"
            case let x where x == 0:
                occupation = "car isn't carrying any paylod"
            default:
                occupation = "current payload is \(payload)"
        }
        print("Glass windows are \(isGlassWindowRaised ? "raised" : "lowered"), the engine \(isEngineStarted ? "is working" : "turned off"), the \(occupation), in the tank \(fuel) liters of fuel.")
    }
    
    func printInfo() -> Void {
        var introduction: String = ""
        
        introduction += "\(model == nil ? "This is an unknown model" : "\(model!) car") was made "
        introduction += "by \(manufacturer ?? "an unknown manufacturer") "
        introduction += year == nil ? "in unknown year." : "in \(year!)"
        
        let message = """
        \(introduction). Max payload capacity for this vehicle is \(frame.weight.getPayloadCapacity()) kg and gross weight is \(frame.weight.gvwr) kg.
        The engine placed in the \(frame.enginePosition.rawValue.lowercased()) of its body and the car has the \(frame.driveLayout.rawValue.lowercased()) wheel drive layout.
        About the car's engine. \(engine == nil ? "Right now it hasn't had any engine" : engine!.getInfo()).
        """
        print(message)
    }
    
    func getShortName() -> String {
        if let manufacturer = self.manufacturer, let model = self.model, let year = self.year {
            return "\(manufacturer) \(model) of \(year)"
        } else if manufacturer == nil && model == nil && year == nil {
            return "A car"
        } else {
            var name: String = ""
            name += manufacturer ?? ""
            name += model == nil ? manufacturer == nil ? "A car" : "'s car" : " " + model!
            name += year == nil ? "" : " of \(year!)"
            return name + "."
        }
    }
    
    func actWithEngine(action: EngineAction) -> Void {
        if let _ = self.engine {
            switch action {
                case .Start:
                    if isEngineReadyToStart {
                        print(isEngineStarted ? "The engine is already working!" : "The engine has started fine! Listen how it roars!")
                        isEngineStarted = true
                    } else {
                        print("This engine isn't ready to start")
                    }
                case .TurnOff:
                    print(isEngineStarted ? "The engine is turned off now!" : "The engine is already stopped and was cold for a long time!")
                    isEngineStarted = false
            }
        } else {
            print("This car doesn't have any engine inside!")
        }
    }
    
    func actWithGlassWindow(action: GlassWindowAction) -> Void {
        switch action {
            case .Lower:
            print(isGlassWindowRaised ? "Glass windows have been lowered!" : "It's already lowered!")
                isGlassWindowRaised = false
            case .Raise:
            print(isGlassWindowRaised ? "It's already raised!" : "Glass windows have been raised!")
                isGlassWindowRaised = true
        }
    }
    
    func actWithPayload(action: PayloadAction) -> Void {
        switch action {
            case .PlaceIn(let volume):
                if (payload + volume > frame.weight.getPayloadCapacity()) {
                    print("You can't place so much payload in this trunk! Take less on \(payload + volume - frame.weight.getPayloadCapacity()) kg.")
                } else if (volume <= 0) {
                    print("Are you kidding?!")
                } else {
                    payload += volume
                    print("Payload was placed with great care and accuracy.")
                }
            case .TakeFrom(let volume):
                if (payload - volume < 0) {
                    print("Hey! You're asking too much! Take your \(payload) kg of payload!")
                    payload = 0
                } else if (payload == 0) {
                    print("The trunk is empty. You can't take anything from it.")
                } else {
                    self.payload -= volume
                    print("Here is your payload, sir!")
                }
        }
    }
    
    func fillFuelTank(volume: Int) -> Void {
        if volume < 0 {
            print("Something totally wrong here.")
        } else {
            if fuel + volume > frame.fuelTank {
                print("You're filling too much! The tank is full now and \(fuel + volume - frame.fuelTank) liters are redundant.")
            } else {
                fuel += volume
                print("Safe road to you!")
            }
        }
    }
}

class Truck: CarVehicle, CustomStringConvertible {
    let manufacturer: String?
    let model: String?
    let year: Int?
    
    let frame: CarFrame
    var forklift: CarLesson4?
    
    var engine: Engine?
    
    var isGlassWindowRaised: Bool = true
    var isEngineStarted: Bool = false
    
    var payload: Int = 0
    var fuel: Int = 0
    
    var isEngineReadyToStart: Bool {
        get {
            if let engine = self.engine {
                return engine.isValidEngine() && fuel > 0
            } else {
                return false
            }
        }
    }
    
    required init(who manufacturer: String, what model: String, when year: Int, frame: CarFrame, engine: Engine? = nil) {
        // <> using of IF here causing the 'constant '' used before being initialized' error
        self.model = model.isEmpty ? nil : model
        self.year = year >= 1886 ? year : nil // https://www.daimler.com/company/tradition/company-history/1885-1886.html
        self.manufacturer = manufacturer.isEmpty ? nil : manufacturer
        // </>

        self.frame = frame
        self.engine = engine
    }
    
    var description: String {
        return getShortName()
    }

    func doCarAction(do action: CarAction) {
        switch action {
            case .Engine(let engineAct):
                actWithEngine(action: engineAct)
            case .GlassWindows(let windowsAct):
                actWithGlassWindow(action: windowsAct)
            case .Payload(let payloadAct):
                if let _ = self.forklift {
                    actWithPayload(action: payloadAct)
                } else {
                    print("You can't do it without a forklift at least!")
                }
            case .Fuel(let volume):
                fillFuelTank(volume: volume)
        }
    }
    
}

class SportCar: CarVehicle, CustomStringConvertible {
    let manufacturer: String?
    let model: String?
    let year: Int?
    
    let frame: CarFrame
    var forklift: CarLesson4?
    
    var engine: Engine?
    
    var isGlassWindowRaised: Bool = true
    var isEngineStarted: Bool = false
    
    var payload: Int = 0
    var fuel: Int = 0
    
    var isEngineReadyToStart: Bool {
        get {
            if let engine = self.engine {
                return engine.isValidEngine() && fuel > 0
            } else {
                return false
            }
        }
    }
    
    var description: String {
        get {
            return getShortName()
        }
    }
    
    private let minSpeedForSportCar: Int = 225 // km/h
    private let minEnginePower: Int = 250 // hp
    private let maxSeatCount: Int = 2
    
    
    required init?(who manufacturer: String, what model: String, when year: Int, frame: CarFrame, engine: Engine?) {
        // <> using of IF here causing the 'constant '' used before being initialized' error
        self.model = model.isEmpty ? nil : model
        self.year = year >= 1886 ? year : nil // https://www.daimler.com/company/tradition/company-history/1885-1886.html
        self.manufacturer = manufacturer.isEmpty ? nil : manufacturer
        // </>

        self.frame = frame
        self.engine = engine
        
        if (engine == nil || frame.maxSpeed < minSpeedForSportCar || frame.seats > maxSeatCount || engine!.maxPower.power < minEnginePower) {return nil}
    }
    
    func doCarAction(do action: CarAction) {
        switch action {
            case .Engine(let engineAct):
                actWithEngine(action: engineAct)
            case .GlassWindows(let windowsAct):
                actWithGlassWindow(action: windowsAct)
            case .Payload(let payloadAct):
                actWithPayload(action: payloadAct)
            case .Fuel(let volume):
                fillFuelTank(volume: volume)
        }
    }
}

func handleCars() -> Void {
    print("We are going to handling with some vehicles of different types!")

    let porscheEngine: Engine = Engine(engineNumber: "741490", gasType: .Gasoline, ignitionType: .SparkIgnition, combustionChamberVolume: 3996, cylinders: 6, cylinderConfig: .Opposed, maxPower: (510, 8400), maxTorque: (470, 6100))
    let porscheWeight: VehicleWeight = VehicleWeight(curbWeight: 1418, dryWeight: 1358, gvwr: 1765)!
    let porscheFrame: CarFrame = CarFrame(vin: "WP0ZZZ95ZJN100108", fuelTank: 64, weight: porscheWeight, driveLayout: .Rear, enginePosition: .Rear, seats: 2, maxSpeed: 320)
    // https://auto.ru/catalog/cars/porsche/911_gt3/22776686/22776768/specifications/
    let porsche911GT3: SportCar = SportCar(who: "Porsche", what: "911 GT3 (992 body)", when: 2021, frame: porscheFrame, engine: porscheEngine)!
    
    // https://avto-russia.ru/autos/freightliner/freightliner_business_class_m2_106_6-7_mt.html
    let freightlinerEngine: Engine = Engine(engineNumber: "5043_7001", gasType: .Diesel, ignitionType: .Diesel, combustionChamberVolume: 6700, cylinders: 6, cylinderConfig: .Straight, maxPower: (power: 200, rpm: 2600), maxTorque: (torque: 705, rpm: 1500))
    let freightlinerWeight: VehicleWeight = VehicleWeight(curbWeight: 6000, dryWeight: 5600, gvwr: 12000)!
    let freightlinerFrame: CarFrame = CarFrame(vin: "1FVACWDTSEHFH4589", fuelTank: 250, weight: freightlinerWeight, driveLayout: .Rear, enginePosition: .Front, seats: 2, maxSpeed: 120)
    let freightlinerM2106: Truck = Truck(who: "Freightliner", what: "M2 106", when: 2002, frame: freightlinerFrame, engine: freightlinerEngine)
    
    
    let porscheHandling: () -> Void = {
        let porschePrimeActions: Array<(description: String, task: () -> Void)> = [1
            ("1. Perform an action with the Porsche", {porsche911GT3.doCarAction(do: getCarActionFromUser())}),
            ("2. Get info.", porsche911GT3.printInfo),
            ("3. Get status.", porsche911GT3.printState)
        ]
        
        actionsPresentation(welcome: "\nPlease, choose one of the actions below:", stopIs: "back", actions: porschePrimeActions)
    }
    
    
    let freightlinerHandling: () -> Void = {
        let forkliftAction: () -> Void = {
            if let _ = freightlinerM2106.forklift {
                print("The truck already has a forklift! What for one more?")
            } else {
                let forkliftEngine: Engine = Engine(engineNumber: "-", gasType: .Gasoline, ignitionType: .SparkIgnition, combustionChamberVolume: 2488, cylinders: 4, cylinderConfig: .Straight, maxPower: (power: 50, rpm: 2300), maxTorque: (torque: 171, rpm: 1600))
                let forkliftWeight: VehicleWeight = VehicleWeight(curbWeight: 3450, dryWeight: 3300, gvwr: 5450)!
                let forkliftFrame: CarFrame = CarFrame(vin: nil, fuelTank: 60, weight: forkliftWeight, driveLayout: .All, enginePosition: .Rear, seats: 1, maxSpeed: 20)
                let forklift: ForkliftLesson4 = ForkliftLesson4(who: "Maximal", what: "2T LPG", when: 2011, frame: forkliftFrame, engine: forkliftEngine)
                freightlinerM2106.forklift = forklift
                print("Now we have a forklift in our usage!")
            }
        }
        
        let freightlinerPrimeActions: Array<(description: String, task: () -> Void)> = [
            ("1. Perform an action with the car", {freightlinerM2106.doCarAction(do: getCarActionFromUser())}),
            ("2. Provide a forklifter", forkliftAction),
            ("3. Get info.", freightlinerM2106.printInfo),
            ("4. Get status.", freightlinerM2106.printState)
        ]
        
        actionsPresentation(welcome: "\nPlease, choose one of the actions below:", stopIs: "back", actions: freightlinerPrimeActions)
    }

    let handlingActions: Array<(description: String, task: () -> Void)> = [
        ("1. \(porsche911GT3.description)", porscheHandling),
        ("2. \(freightlinerM2106.description)", freightlinerHandling)
    ]
    
    actionsPresentation(welcome: "\nPlease, choose one of the following vehicles below:", stopIs: "back", actions: handlingActions)
}

let lesson5: Array<(String, () -> Void)> = [
    ("1. All six tasks in one handling of different cars", handleCarsLesson4)
]
